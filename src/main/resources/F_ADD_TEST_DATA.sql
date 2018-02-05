CREATE OR REPLACE FUNCTION F_ADD_TEST_DATA(
MAX_NUM IN  NUMBER,-- max
CREATE_USER IN  VARCHAR -- 作成者番号 M_所定労働時間上限管理.作成者番号%TYPE
)
RETURN NUMBER
IS
--■ 変数
intErrorInfo  NUMBER;
CNT  NUMBER;
i NUMBER;
j NUMBER;
k NUMBER;
--■ カーソル
BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;

    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 START >>>>>>>>>>');

    --初期化
    intErrorInfo := 0;
    --計算処理 START
    BEGIN
         i := 1;
         j := 1;
         k := 1;
         LOOP
         --INSERT INTO dual(param1,param2)VALUES(val1,val2);
         --UPDATE dual SET param1 = val1,param2=val2 WHERE id= 'id';
         -- EESC_USER

/*         INSERT INTO EESC_USER(従業員ＮＯ,氏名＿漢字,氏名＿カナ,メールアドレス,所属職制コード１,所属職制簡略名１,職位コード１,職位名１)VALUES(
         (SELECT replace(lpad(i,3),' ','0') FROM dual)
         ,'漢字'||i
         ,'カナ'||i
         ,'kawamoto@adf.co.jp'
         ,(SELECT replace(lpad(i,3),' ','0') FROM dual)
         ,'簡略'||i
         ,'ZW'||(SELECT replace(lpad(i,3),' ','0') FROM dual)
         ,'職位'||i
         );*/


         -- EESC_SECTION
/*         INSERT INTO EESC_SECTION(職制表示順,職制コード,部課内細区分職制コード,会社コード,会社名,簡略名)VALUES(
         i
         ,(SELECT replace(lpad(i,3),' ','0') FROM dual)
         ,(SELECT replace(lpad(i,3),' ','0') FROM dual)
         ,(SELECT replace(lpad(i,3),' ','0') FROM dual)
         ,'会社'||i
         ,'簡略'||i
         );*/


        -- CDOSHEAD
/*        INSERT INTO CDOSHEAD(物件番号,ＯＳ番号,ＩＮＱ番号,最終需要家名,工事件名)VALUES(
         i
         ,'PJNO'||(SELECT replace(lpad(i,3),' ','0') FROM dual)
         ,'INQ'||(SELECT replace(lpad(i,3),' ','0') FROM dual)
         ,'終需家'||i
         ,'総括品'||i
         );*/

         -- IDENT_T_INCIDENT
/*         INSERT INTO IDENT_T_INCIDENT(INCIDENT_ID,INCIDENT_NO,CALL_CONTENT,CALL_START_DATE,CALL_END_DATE,INCIDENT_TYPE,INCIDENT_STS)VALUES(
         i -- インシデントID(Sequence) NUMBER(10)
         ,'INC'||i -- インシデント番号 VARCHAR2(20)
         ,'受付内容'||i -- 受付内容 VARCHAR2(2000)
         ,SYSDATE+(1/24)*i -- 受付開始時刻
         ,SYSDATE+1+(1/24)*i-- 受付終了時刻
         ,j -- インシデント分類  1-6
         ,k -- 業種区分 1-3
         );*/

         -- EBS_CUSTOMER_SITES
         INSERT INTO EBS_CUSTOMER_SITES(CUST_ACCOUNT_ID,CUST_ACCT_SITE_ID,SITE_USE_ID,ADDRESS1,FORMAL_CUST_NAME_1,FORMAL_CUST_NAME_2)VALUES(
         i
         ,i
         ,i
         ,'所在地'||i
         ,'正式名称'||i
         ,'正式名称'||i
         );

         i := i + 1;
         j := j +1;
         k := k +1;
         IF j > 6 THEN j := 1; END IF;
         IF k > 3 THEN k:= 1; END IF;
         EXIT WHEN i > MAX_NUM;
         END LOOP;
        --計算処理 END
         EXCEPTION
            WHEN OTHERS THEN
            intErrorInfo := -99;
            DBMS_OUTPUT.PUT_LINE('★エラー(' || TO_CHAR(intErrorInfo) || '):システムエラー');
            DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
            RETURN intErrorInfo;
    END;

    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 END >>>>>>>>>>');

  RETURN(intErrorInfo);
END F_ADD_TEST_DATA;
