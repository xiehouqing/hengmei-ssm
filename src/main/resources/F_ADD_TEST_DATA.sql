CREATE OR REPLACE FUNCTION F_ADD_TEST_DATA(
MAX_NUM IN  NUMBER,-- max
CREATE_USER IN  VARCHAR -- �쐬�Ҕԍ� M_����J�����ԏ���Ǘ�.�쐬�Ҕԍ�%TYPE
)
RETURN NUMBER
IS
--�� �ϐ�
intErrorInfo  NUMBER;
CNT  NUMBER;
i NUMBER;
--�� �J�[�\��
BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �v�Z���� START >>>>>>>>>>');
    --������
    intErrorInfo := 0;
    --�v�Z���� START
     i := 1;
     LOOP
     --INSERT INTO dual(param1,param2)VALUES(val1,val2);
     --UPDATE dual SET param1 = val1,param2=val2 WHERE id= 'id';
     i := i + 1;
     EXIT WHEN i > MAX_NUM;
     END LOOP;
    --�v�Z���� END
     EXCEPTION
        WHEN OTHERS THEN
        intErrorInfo := -99;
        DBMS_OUTPUT.PUT_LINE('���G���[(' || TO_CHAR(intErrorInfo) || '):�V�X�e���G���[');
        DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
        RETURN intErrorInfo;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �v�Z���� END >>>>>>>>>>');
          
  RETURN(intErrorInfo);
END F_ADD_TEST_DATA;
/
