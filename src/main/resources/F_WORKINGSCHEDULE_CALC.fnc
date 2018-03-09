CREATE OR REPLACE FUNCTION F_WORKINGSCHEDULE_CALC(
YEAR_MONTH IN  VARCHAR,-- 年月 M_所定労働時間上限管理.年月%TYPE
CREATE_USER IN  VARCHAR -- 作成者番号 M_所定労働時間上限管理.作成者番号%TYPE
)
RETURN NUMBER
IS
--■ 変数
WEEK_CNT NUMBER;--週の所定労働時間
WEEK_MAX NUMBER;--週の上限時間
WEEK_RESULT NUMBER;--週の基準超過残業時間
MONTH_CNT NUMBER;--月の所定労働時間
MONTH_MAX NUMBER;--月の上限時間
MONTH_RESULT NUMBER;--月の基準超過残業時間
OWN_WEEKEND NUMBER;--週休付与日数
USED_WEEKEND NUMBER;--週休の消化日数
CONVERT_DAYS NUMBER;--週休の給与換算日数
LAST_DAY_MONTH VARCHAR(2);--月の最後の日
DATE_YEAR VARCHAR(4);--今回締め対象年月の年
DATE_MONTH VARCHAR(2);--今回締め対象年月の月
intErrorInfo  NUMBER;
CNT  NUMBER;
--■ カーソル
     -- 週カーソル
    CURSOR CUR_WEEKS IS
      SELECT m.weekno AS week_no,min(m.日付) AS start_Date,MAX(m.日付) AS end_Date
      FROM
      (
            SELECT
                   T.*
                   ,TO_CHAR(TO_DATE(T.日付, 'yyyy/mm/dd'),'mm') AS MON
                   ,TO_CHAR(TO_DATE(T.日付, 'yyyy/mm/dd'),'dd') AS DAYS
                   ,TO_CHAR(TO_DATE(T.日付, 'yyyy/mm/dd'),'yyyy/mm') AS YEARMONTH
                   ,ROWNUM
                   ,DECODE(SIGN(ROWNUM-7),-1,1,0,1,DECODE(SIGN(ROWNUM-14),-1,2,0,2,DECODE(SIGN(ROWNUM-21),-1,3,0,3,DECODE(SIGN(ROWNUM-28),-1,4,0,4,DECODE(SIGN(ROWNUM-35),-1,5,0,5,DECODE(SIGN(ROWNUM-42),-1,6,0,6,0)))))) AS WEEKNO
             FROM
                      (
                        SELECT TO_CHAR((select to_date(YEAR_MONTH||'/01','yyyy/mm/dd')-DECODE((select to_char(to_date(YEAR_MONTH||'/01','yyyy/mm/dd'),'D') from dual),7,0,(select to_char(to_date(YEAR_MONTH||'/01','yyyy/mm/dd'),'D') from dual)) from dual) + ROWNUM - 1,'yyyy/mm/dd') as 日付
                        FROM DUAL
                        CONNECT BY ROWNUM <=42
                      ) T
             WHERE
                   ROWNUM <= 42
      ) M
      WHERE M.YEARMONTH = YEAR_MONTH
      GROUP BY m.weekno
      ORDER BY m.weekno;

--【１．週の基準超過残業時間の計算】--------
       -- 週の上限時間を取得
       CURSOR CUR_WEEKMAX(WEEK_NUM NUMBER) IS  SELECT 上限時間 AS MAXTIME  FROM M_所定労働時間上限管理 WHERE 年月=  YEAR_MONTH AND 週番号 = WEEK_NUM;

      -- 社員カーソル
      CURSOR CUR_EMPS IS SELECT DISTINCT 社員ID AS EMP_ID,ユーザID AS USER_ID FROM T_勤怠実績 WHERE 勤怠年月日 LIKE YEAR_MONTH||'/%'  ORDER BY 社員ID,ユーザID;

      -- フリー週休付与日数を取得
      CURSOR CUR_OWN_WEEKEND(USER_ID VARCHAR2) IS SELECT * FROM M_週休付与管理 A INNER JOIN M_ユーザ管理 B ON A.ユーザID = B.ユーザID AND A.社員ID = B.社員ID AND A.社員ID = USER_ID AND 繰越付与年度 = DATE_YEAR;

      -- フリー週休の消化日数を取得
      CURSOR CUR_USED_WEEKEND(USER_ID VARCHAR2) IS SELECT COUNT(*) AS CNT_USED FROM T_週休管理 WHERE 給与換算フラグ = '0' AND 社員ID = USER_ID AND 勤怠年月日 LIKE YEAR_MONTH||'%';

BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 START >>>>>>>>>>');
    --初期化
    intErrorInfo := 0;
    DBMS_OUTPUT.PUT_LINE('今回締め対象年月:'||YEAR_MONTH); -- 今回締め対象年月
  -- 月の最後の日
  SELECT DAYS INTO LAST_DAY_MONTH FROM(SELECT to_char(last_day(to_date(YEAR_MONTH,'yyyy/mm')),'dd') AS DAYS from DUAL);
  -- 今回締め対象年月の年
  SELECT YEARS INTO DATE_YEAR FROM(SELECT to_char(TO_DATE(YEAR_MONTH,'yyyy/mm'),'yyyy') AS YEARS FROM DUAL);
  -- 今回締め対象年月の月
  SELECT MONTHS INTO DATE_MONTH FROM(SELECT to_char(TO_DATE(YEAR_MONTH,'yyyy/mm'),'mm') AS MONTHS FROM DUAL);

--計算処理 START
      -- 社員カーソル
    FOR EMP IN CUR_EMPS
      LOOP

             BEGIN
             --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< １．週の基準超過残業時間の計算 START >>>>>>>>>>');
                --週カーソル
                FOR WEEK IN CUR_WEEKS
                    LOOP
                    -- ① 社員毎、週毎の所定労働時間を計算
                    SELECT COUNT(*) INTO WEEK_CNT
                    FROM T_勤怠実績
                    WHERE 勤怠年月日 >= WEEK.start_Date
                          AND 勤怠年月日 <= WEEK.end_Date
                          AND (勤務区分 IN('10','20','40','43','65','61','63','16','15','11') OR (select to_char(to_date(勤怠年月日,'yyyy/mm/dd'),'D') from dual)  = 1 )
                          AND 社員ID = EMP.EMP_ID;

                    --② 週の上限時間を取得
                    WEEK_MAX := 0;
                    FOR TMP IN CUR_WEEKMAX(WEEK.week_no) LOOP
                           IF CUR_WEEKMAX%FOUND THEN
                               WEEK_MAX := TMP.MAXTIME;
                           END IF;
                    END LOOP;

                    --③ 週の基準超過残業時間を計算  ( ① - ② )  × 60分
                     WEEK_RESULT:= (WEEK_CNT*7-WEEK_MAX) * 60;
                     IF WEEK_RESULT IS NULL OR WEEK_RESULT < 0 THEN
                         WEEK_RESULT :=0;
                     END IF;

                    -- 計算結果をT_勤怠実績.週基準超過残業時間に設定する。設定するレコードは各週の最終日のレコード。
                    UPDATE T_勤怠実績 SET 週基準超過残業 = WEEK_RESULT WHERE 社員ID = EMP.EMP_ID AND 勤怠年月日 = WEEK.end_Date;

             END LOOP; --週カーソル  END
             EXCEPTION
                    when others then
                    intErrorInfo := -99;
                    dbms_output.put_line('1.★エラー(' || TO_CHAR(intErrorInfo) || '):システムエラー');
                    dbms_output.put_line(SQLCODE||'---'||SQLERRM);
                    RETURN intErrorInfo;
         --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< １．週の基準超過残業時間の計算 END >>>>>>>>>>');
         END;

         BEGIN
         --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< ２．月の基準超過残業時間の計算 START >>>>>>>>>>');
            -- ① 社員毎、月毎の所定労働時間を計算
            SELECT COUNT(*) INTO MONTH_CNT
            FROM T_勤怠実績
            WHERE 勤怠年月日 >= YEAR_MONTH||'/01'
                  AND 勤怠年月日 <= YEAR_MONTH||'/'||LAST_DAY_MONTH
                  AND (勤務区分 IN('10','20','40','43','65','61','63','16','15','11') OR (select to_char(to_date(勤怠年月日,'yyyy/mm/dd'),'D') from dual)  = 1 )
                  AND 社員ID = EMP.EMP_ID;

            --② 月の上限時間を取得
            MONTH_MAX := 0;
            FOR TMP IN CUR_WEEKMAX(9) LOOP
                   IF CUR_WEEKMAX%FOUND THEN
                       MONTH_MAX := TMP.MAXTIME;
                   END IF;
            END LOOP;

             --③ 月の基準超過残業時間を計算  ( ① - ② )  × 60分
             MONTH_RESULT:= (MONTH_CNT*7-MONTH_MAX) * 60;
             IF MONTH_RESULT IS NULL OR MONTH_RESULT < 0 THEN
                 MONTH_RESULT :=0;
             END IF;

             -- 計算結果をT_勤怠実績.月の基準超過残業時間に設定する。
             UPDATE T_勤怠実績 SET 月基準超過残業 = MONTH_RESULT WHERE 社員ID = EMP.EMP_ID AND 勤怠年月日 = YEAR_MONTH||'/'||LAST_DAY_MONTH;

        EXCEPTION
              when others then
              intErrorInfo := -99;
              DBMS_OUTPUT.PUT_LINE('2.★エラー(' || TO_CHAR(intErrorInfo) ||'):システムエラー');
              DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
              RETURN intErrorInfo;
        --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< ２．月の基準超過残業時間の計算 END >>>>>>>>>>');
        END;

        BEGIN
        --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< ３．フリー週休の給与換算日数計算 START >>>>>>>>>>');

          -- ①フリー週休付与日数を取得
          FOR OWN IN CUR_OWN_WEEKEND(EMP.EMP_ID)
            LOOP
              IF CUR_OWN_WEEKEND%FOUND THEN
                   IF DATE_MONTH = '01' THEN
                         OWN_WEEKEND := OWN.月01;
                         ELSIF DATE_MONTH = '02' THEN
                         OWN_WEEKEND := OWN.月02;
                         ELSIF DATE_MONTH = '03' THEN
                         OWN_WEEKEND := OWN.月03;
                         ELSIF DATE_MONTH = '04' THEN
                         OWN_WEEKEND := OWN.月04;
                         ELSIF DATE_MONTH = '05' THEN
                         OWN_WEEKEND := OWN.月05;
                         ELSIF DATE_MONTH = '06' THEN
                         OWN_WEEKEND := OWN.月06;
                         ELSIF DATE_MONTH = '07' THEN
                         OWN_WEEKEND := OWN.月07;
                         ELSIF DATE_MONTH = '08' THEN
                         OWN_WEEKEND := OWN.月08;
                         ELSIF DATE_MONTH = '09' THEN
                         OWN_WEEKEND := OWN.月09;
                         ELSIF DATE_MONTH = '10' THEN
                         OWN_WEEKEND := OWN.月10;
                         ELSIF DATE_MONTH = '11' THEN
                         OWN_WEEKEND := OWN.月11;
                         ELSIF DATE_MONTH = '12' THEN
                         OWN_WEEKEND := OWN.月12;
                     END IF;
               ELSE
                     OWN_WEEKEND := 0;
               END IF;
            END LOOP;

          -- ②フリー週休の消化日数を取得
            USED_WEEKEND := 0;
            FOR TMP IN CUR_USED_WEEKEND(EMP.EMP_ID) LOOP
                   IF CUR_USED_WEEKEND%FOUND THEN
                       USED_WEEKEND := TMP.CNT_USED;
                   END IF;
            END LOOP;
            
            IF USED_WEEKEND > 0 THEN
                  -- ③フリー週休の給与換算日数を計算し、テーブルに登録 ① - ②　＝　給与換算日数
                  CONVERT_DAYS := (OWN_WEEKEND-USED_WEEKEND);
                   IF CONVERT_DAYS IS NULL OR CONVERT_DAYS < 0 THEN
                       CONVERT_DAYS :=0;
                   END IF;

                  -- 週休管理テーブルに登録する。
                  SELECT COUNT(1) INTO CNT FROM T_週休管理 WHERE 勤怠年月日 = (YEAR_MONTH||'/99') AND 社員ID = EMP.EMP_ID AND ユーザID = EMP.USER_ID;
                   IF CNT = 0 THEN
                        INSERT INTO T_週休管理 VALUES(
                        YEAR_MONTH||'/99' --勤怠年月日
                        ,EMP.EMP_ID --社員ID
                        ,EMP.USER_ID --ユーザID
                        ,CREATE_USER --作成者番号
                        ,SYSDATE --作成日時
                        ,CREATE_USER --最終更新者番号
                        ,SYSDATE --最終更新日時
                        ,'1' --給与換算フラグ
                         ,CONVERT_DAYS --給与換算日数
                        );
                    ELSE
                       UPDATE T_週休管理 SET  最終更新者番号 = CREATE_USER,最終更新日時 = SYSDATE,給与換算フラグ = '1',給与換算日数 = CONVERT_DAYS
                       WHERE 勤怠年月日 = (YEAR_MONTH||'/99') AND 社員ID = EMP.EMP_ID AND ユーザID = EMP.USER_ID;
                      END IF;
            END IF;


        EXCEPTION
          WHEN OTHERS THEN
          intErrorInfo := -99;
          DBMS_OUTPUT.PUT_LINE('3.★エラー(' || TO_CHAR(intErrorInfo) || '):システムエラー');
          DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
          RETURN intErrorInfo;
    --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< ３．フリー週休の給与換算日数計算 END >>>>>>>>>>');
    END;

    END LOOP;-- 社員カーソル  END
   --計算処理 END
   DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 END >>>>>>>>>>');
  RETURN(intErrorInfo);
END F_WORKINGSCHEDULE_CALC;
/
