CREATE OR REPLACE FUNCTION F_WORKINGSCHEDULE_CALC(
YEAR_MONTH IN  VARCHAR,-- N M_èJ­ÔãÀÇ.N%TYPE
CREATE_USER IN  VARCHAR -- ì¬ÒÔ M_èJ­ÔãÀÇ.ì¬ÒÔ%TYPE
)
RETURN NUMBER
IS
--¡ Ï
WEEK_CNT NUMBER;--TÌèJ­Ô
WEEK_MAX NUMBER;--TÌãÀÔ
WEEK_RESULT NUMBER;--TÌî´ßcÆÔ
MONTH_CNT NUMBER;--ÌèJ­Ô
MONTH_MAX NUMBER;--ÌãÀÔ
MONTH_RESULT NUMBER;--Ìî´ßcÆÔ
OWN_WEEKEND NUMBER;--Txt^ú
USED_WEEKEND NUMBER;--TxÌÁ»ú
CONVERT_DAYS NUMBER;--TxÌ^·Zú
LAST_DAY_MONTH VARCHAR(2);--ÌÅãÌú
DATE_YEAR VARCHAR(4);--¡ñ÷ßÎÛNÌN
DATE_MONTH VARCHAR(2);--¡ñ÷ßÎÛNÌ
intErrorInfo  NUMBER;
CNT  NUMBER;
--¡ J[\
     -- TJ[\
    CURSOR CUR_WEEKS IS
      SELECT m.weekno AS week_no,min(m.út) AS start_Date,MAX(m.út) AS end_Date
      FROM
      (
            SELECT
                   T.*
                   ,TO_CHAR(TO_DATE(T.út, 'yyyy/mm/dd'),'mm') AS MON
                   ,TO_CHAR(TO_DATE(T.út, 'yyyy/mm/dd'),'dd') AS DAYS
                   ,TO_CHAR(TO_DATE(T.út, 'yyyy/mm/dd'),'yyyy/mm') AS YEARMONTH
                   ,ROWNUM
                   ,DECODE(SIGN(ROWNUM-7),-1,1,0,1,DECODE(SIGN(ROWNUM-14),-1,2,0,2,DECODE(SIGN(ROWNUM-21),-1,3,0,3,DECODE(SIGN(ROWNUM-28),-1,4,0,4,DECODE(SIGN(ROWNUM-35),-1,5,0,5,DECODE(SIGN(ROWNUM-42),-1,6,0,6,0)))))) AS WEEKNO
             FROM
                      (
                        SELECT TO_CHAR((select to_date(YEAR_MONTH||'/01','yyyy/mm/dd')-DECODE((select to_char(to_date(YEAR_MONTH||'/01','yyyy/mm/dd'),'D') from dual),7,0,(select to_char(to_date(YEAR_MONTH||'/01','yyyy/mm/dd'),'D') from dual)) from dual) + ROWNUM - 1,'yyyy/mm/dd') as út
                        FROM DUAL
                        CONNECT BY ROWNUM <=42
                      ) T
             WHERE
                   ROWNUM <= 42
      ) M
      WHERE M.YEARMONTH = YEAR_MONTH
      GROUP BY m.weekno
      ORDER BY m.weekno;

--yPDTÌî´ßcÆÔÌvZz--------
       -- TÌãÀÔðæ¾
       CURSOR CUR_WEEKMAX(WEEK_NUM NUMBER) IS  SELECT ãÀÔ AS MAXTIME  FROM M_èJ­ÔãÀÇ WHERE N=  YEAR_MONTH AND TÔ = WEEK_NUM;

      -- ÐõJ[\
      CURSOR CUR_EMPS IS SELECT DISTINCT ÐõID AS EMP_ID,[UID AS USER_ID FROM T_ÎÓÀÑ WHERE ÎÓNú LIKE YEAR_MONTH||'/%'  ORDER BY ÐõID,[UID;

      -- t[Txt^úðæ¾
      CURSOR CUR_OWN_WEEKEND(USER_ID VARCHAR2) IS SELECT * FROM M_Txt^Ç A INNER JOIN M_[UÇ B ON A.[UID = B.[UID AND A.ÐõID = B.ÐõID AND A.ÐõID = USER_ID AND Jzt^Nx = DATE_YEAR;

      -- t[TxÌÁ»úðæ¾
      CURSOR CUR_USED_WEEKEND(USER_ID VARCHAR2) IS SELECT COUNT(*) AS CNT_USED FROM T_TxÇ WHERE ^·ZtO = '0' AND ÐõID = USER_ID AND ÎÓNú LIKE YEAR_MONTH||'%';

BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< vZ START >>>>>>>>>>');
    --ú»
    intErrorInfo := 0;
    DBMS_OUTPUT.PUT_LINE('¡ñ÷ßÎÛN:'||YEAR_MONTH); -- ¡ñ÷ßÎÛN
  -- ÌÅãÌú
  SELECT DAYS INTO LAST_DAY_MONTH FROM(SELECT to_char(last_day(to_date(YEAR_MONTH,'yyyy/mm')),'dd') AS DAYS from DUAL);
  -- ¡ñ÷ßÎÛNÌN
  SELECT YEARS INTO DATE_YEAR FROM(SELECT to_char(TO_DATE(YEAR_MONTH,'yyyy/mm'),'yyyy') AS YEARS FROM DUAL);
  -- ¡ñ÷ßÎÛNÌ
  SELECT MONTHS INTO DATE_MONTH FROM(SELECT to_char(TO_DATE(YEAR_MONTH,'yyyy/mm'),'mm') AS MONTHS FROM DUAL);

--vZ START
      -- ÐõJ[\
    FOR EMP IN CUR_EMPS
      LOOP

             BEGIN
             --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< PDTÌî´ßcÆÔÌvZ START >>>>>>>>>>');
                --TJ[\
                FOR WEEK IN CUR_WEEKS
                    LOOP
                    -- @ ÐõATÌèJ­ÔðvZ
                    SELECT COUNT(*) INTO WEEK_CNT
                    FROM T_ÎÓÀÑ
                    WHERE ÎÓNú >= WEEK.start_Date
                          AND ÎÓNú <= WEEK.end_Date
                          AND (Î±æª IN('10','20','40','43','65','61','63','16','15','11') OR (select to_char(to_date(ÎÓNú,'yyyy/mm/dd'),'D') from dual)  = 1 )
                          AND ÐõID = EMP.EMP_ID;

                    --A TÌãÀÔðæ¾
                    WEEK_MAX := 0;
                    FOR TMP IN CUR_WEEKMAX(WEEK.week_no) LOOP
                           IF CUR_WEEKMAX%FOUND THEN
                               WEEK_MAX := TMP.MAXTIME;
                           END IF;
                    END LOOP;

                    --B TÌî´ßcÆÔðvZ  ( @ - A )  ~ 60ª
                     WEEK_RESULT:= (WEEK_CNT*7-WEEK_MAX) * 60;
                     IF WEEK_RESULT IS NULL OR WEEK_RESULT < 0 THEN
                         WEEK_RESULT :=0;
                     END IF;

                    -- vZÊðT_ÎÓÀÑ.Tî´ßcÆÔÉÝè·éBÝè·éR[hÍeTÌÅIúÌR[hB
                    UPDATE T_ÎÓÀÑ SET Tî´ßcÆ = WEEK_RESULT WHERE ÐõID = EMP.EMP_ID AND ÎÓNú = WEEK.end_Date;

             END LOOP; --TJ[\  END
             EXCEPTION
                    when others then
                    intErrorInfo := -99;
                    dbms_output.put_line('1.G[(' || TO_CHAR(intErrorInfo) || '):VXeG[');
                    dbms_output.put_line(SQLCODE||'---'||SQLERRM);
                    RETURN intErrorInfo;
         --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< PDTÌî´ßcÆÔÌvZ END >>>>>>>>>>');
         END;

         BEGIN
         --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< QDÌî´ßcÆÔÌvZ START >>>>>>>>>>');
            -- @ ÐõAÌèJ­ÔðvZ
            SELECT COUNT(*) INTO MONTH_CNT
            FROM T_ÎÓÀÑ
            WHERE ÎÓNú >= YEAR_MONTH||'/01'
                  AND ÎÓNú <= YEAR_MONTH||'/'||LAST_DAY_MONTH
                  AND (Î±æª IN('10','20','40','43','65','61','63','16','15','11') OR (select to_char(to_date(ÎÓNú,'yyyy/mm/dd'),'D') from dual)  = 1 )
                  AND ÐõID = EMP.EMP_ID;

            --A ÌãÀÔðæ¾
            MONTH_MAX := 0;
            FOR TMP IN CUR_WEEKMAX(9) LOOP
                   IF CUR_WEEKMAX%FOUND THEN
                       MONTH_MAX := TMP.MAXTIME;
                   END IF;
            END LOOP;

             --B Ìî´ßcÆÔðvZ  ( @ - A )  ~ 60ª
             MONTH_RESULT:= (MONTH_CNT*7-MONTH_MAX) * 60;
             IF MONTH_RESULT IS NULL OR MONTH_RESULT < 0 THEN
                 MONTH_RESULT :=0;
             END IF;

             -- vZÊðT_ÎÓÀÑ.Ìî´ßcÆÔÉÝè·éB
             UPDATE T_ÎÓÀÑ SET î´ßcÆ = MONTH_RESULT WHERE ÐõID = EMP.EMP_ID AND ÎÓNú = YEAR_MONTH||'/'||LAST_DAY_MONTH;

        EXCEPTION
              when others then
              intErrorInfo := -99;
              DBMS_OUTPUT.PUT_LINE('2.G[(' || TO_CHAR(intErrorInfo) ||'):VXeG[');
              DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
              RETURN intErrorInfo;
        --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< QDÌî´ßcÆÔÌvZ END >>>>>>>>>>');
        END;

        BEGIN
        --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< RDt[TxÌ^·ZúvZ START >>>>>>>>>>');

          -- @t[Txt^úðæ¾
          FOR OWN IN CUR_OWN_WEEKEND(EMP.EMP_ID)
            LOOP
              IF CUR_OWN_WEEKEND%FOUND THEN
                   IF DATE_MONTH = '01' THEN
                         OWN_WEEKEND := OWN.01;
                         ELSIF DATE_MONTH = '02' THEN
                         OWN_WEEKEND := OWN.02;
                         ELSIF DATE_MONTH = '03' THEN
                         OWN_WEEKEND := OWN.03;
                         ELSIF DATE_MONTH = '04' THEN
                         OWN_WEEKEND := OWN.04;
                         ELSIF DATE_MONTH = '05' THEN
                         OWN_WEEKEND := OWN.05;
                         ELSIF DATE_MONTH = '06' THEN
                         OWN_WEEKEND := OWN.06;
                         ELSIF DATE_MONTH = '07' THEN
                         OWN_WEEKEND := OWN.07;
                         ELSIF DATE_MONTH = '08' THEN
                         OWN_WEEKEND := OWN.08;
                         ELSIF DATE_MONTH = '09' THEN
                         OWN_WEEKEND := OWN.09;
                         ELSIF DATE_MONTH = '10' THEN
                         OWN_WEEKEND := OWN.10;
                         ELSIF DATE_MONTH = '11' THEN
                         OWN_WEEKEND := OWN.11;
                         ELSIF DATE_MONTH = '12' THEN
                         OWN_WEEKEND := OWN.12;
                     END IF;
               ELSE
                     OWN_WEEKEND := 0;
               END IF;
            END LOOP;

          -- At[TxÌÁ»úðæ¾
            USED_WEEKEND := 0;
            FOR TMP IN CUR_USED_WEEKEND(EMP.EMP_ID) LOOP
                   IF CUR_USED_WEEKEND%FOUND THEN
                       USED_WEEKEND := TMP.CNT_USED;
                   END IF;
            END LOOP;
            
            IF USED_WEEKEND > 0 THEN
                  -- Bt[TxÌ^·ZúðvZµAe[uÉo^ @ - A@@^·Zú
                  CONVERT_DAYS := (OWN_WEEKEND-USED_WEEKEND);
                   IF CONVERT_DAYS IS NULL OR CONVERT_DAYS < 0 THEN
                       CONVERT_DAYS :=0;
                   END IF;

                  -- TxÇe[uÉo^·éB
                  SELECT COUNT(1) INTO CNT FROM T_TxÇ WHERE ÎÓNú = (YEAR_MONTH||'/99') AND ÐõID = EMP.EMP_ID AND [UID = EMP.USER_ID;
                   IF CNT = 0 THEN
                        INSERT INTO T_TxÇ VALUES(
                        YEAR_MONTH||'/99' --ÎÓNú
                        ,EMP.EMP_ID --ÐõID
                        ,EMP.USER_ID --[UID
                        ,CREATE_USER --ì¬ÒÔ
                        ,SYSDATE --ì¬ú
                        ,CREATE_USER --ÅIXVÒÔ
                        ,SYSDATE --ÅIXVú
                        ,'1' --^·ZtO
                         ,CONVERT_DAYS --^·Zú
                        );
                    ELSE
                       UPDATE T_TxÇ SET  ÅIXVÒÔ = CREATE_USER,ÅIXVú = SYSDATE,^·ZtO = '1',^·Zú = CONVERT_DAYS
                       WHERE ÎÓNú = (YEAR_MONTH||'/99') AND ÐõID = EMP.EMP_ID AND [UID = EMP.USER_ID;
                      END IF;
            END IF;


        EXCEPTION
          WHEN OTHERS THEN
          intErrorInfo := -99;
          DBMS_OUTPUT.PUT_LINE('3.G[(' || TO_CHAR(intErrorInfo) || '):VXeG[');
          DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
          RETURN intErrorInfo;
    --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< RDt[TxÌ^·ZúvZ END >>>>>>>>>>');
    END;

    END LOOP;-- ÐõJ[\  END
   --vZ END
   DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< vZ END >>>>>>>>>>');
  RETURN(intErrorInfo);
END F_WORKINGSCHEDULE_CALC;
/
