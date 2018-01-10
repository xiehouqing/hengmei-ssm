CREATE OR REPLACE FUNCTION F_TEST(
IN_TAG_NO IN  VARCHAR,-- TAG NO
IN_SYS_ID IN  VARCHAR, -- SYS ID
IN_P_DATE IN VARCHAR
) 
RETURN NUMBER
IS
--■ 変数
intErrorInfo  NUMBER;
CNT  NUMBER;
--■ カーソル


BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 START >>>>>>>>>>');
    --初期化 
    intErrorInfo := 0; 

             BEGIN
             
             CNT := 0;
             LOOP
                EXIT WHEN CNT>24;
                --dbms_output.put_line(IN_SYS_ID||','||IN_TAG_NO||','||TO_CHAR((TO_DATE(IN_P_DATE)+CNT/24),'yyyy/mm/dd hh24:mi')||','||CNT);
             INSERT INTO LSDDAYRP("SYS_ID","TAG_NO","P_DATE","P_VAL1","REC_FLG","REC_PGID","REC_DATE"
             )VALUES(
             IN_SYS_ID,
             IN_TAG_NO,
             (TO_DATE(IN_P_DATE)+(CNT+1)/24),
             (CNT+1)*10,
             '00',
             'SOINS',
             SYSDATE
             );
                CNT:=CNT+1;
              END LOOP;

             EXCEPTION
                    when others then
                    intErrorInfo := -99;
                    dbms_output.put_line('1.★エラー(' || TO_CHAR(intErrorInfo) || '):システムエラー');
                    dbms_output.put_line(SQLCODE||'---'||SQLERRM);
                    RETURN intErrorInfo;
         END;

   DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 END >>>>>>>>>>');
  RETURN(intErrorInfo);
END F_TEST;
