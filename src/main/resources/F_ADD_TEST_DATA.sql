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
--■ カーソル
BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 START >>>>>>>>>>');
    --初期化
    intErrorInfo := 0;
    --計算処理 START
     i := 1;
     LOOP
     --INSERT INTO dual(param1,param2)VALUES(val1,val2);
     --UPDATE dual SET param1 = val1,param2=val2 WHERE id= 'id';
     i := i + 1;
     EXIT WHEN i > MAX_NUM;
     END LOOP;
    --計算処理 END
     EXCEPTION
        WHEN OTHERS THEN
        intErrorInfo := -99;
        DBMS_OUTPUT.PUT_LINE('★エラー(' || TO_CHAR(intErrorInfo) || '):システムエラー');
        DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
        RETURN intErrorInfo;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 END >>>>>>>>>>');
          
  RETURN(intErrorInfo);
END F_ADD_TEST_DATA;
/
