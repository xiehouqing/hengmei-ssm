CREATE OR REPLACE FUNCTION F_TEST(
IN_TAG_NO IN  VARCHAR,-- TAG NO
IN_SYS_ID IN  VARCHAR, -- SYS ID
IN_P_DATE IN VARCHAR
) 
RETURN NUMBER
IS
--�� �ϐ�
intErrorInfo  NUMBER;
CNT  NUMBER;
--�� �J�[�\��


BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �v�Z���� START >>>>>>>>>>');
    --������ 
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
                    dbms_output.put_line('1.���G���[(' || TO_CHAR(intErrorInfo) || '):�V�X�e���G���[');
                    dbms_output.put_line(SQLCODE||'---'||SQLERRM);
                    RETURN intErrorInfo;
         END;

   DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �v�Z���� END >>>>>>>>>>');
  RETURN(intErrorInfo);
END F_TEST;
