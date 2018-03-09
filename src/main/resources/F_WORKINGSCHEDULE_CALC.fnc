CREATE OR REPLACE FUNCTION F_WORKINGSCHEDULE_CALC(
YEAR_MONTH IN  VARCHAR,-- �N�� M_����J�����ԏ���Ǘ�.�N��%TYPE
CREATE_USER IN  VARCHAR -- �쐬�Ҕԍ� M_����J�����ԏ���Ǘ�.�쐬�Ҕԍ�%TYPE
)
RETURN NUMBER
IS
--�� �ϐ�
WEEK_CNT NUMBER;--�T�̏���J������
WEEK_MAX NUMBER;--�T�̏������
WEEK_RESULT NUMBER;--�T�̊���ߎc�Ǝ���
MONTH_CNT NUMBER;--���̏���J������
MONTH_MAX NUMBER;--���̏������
MONTH_RESULT NUMBER;--���̊���ߎc�Ǝ���
OWN_WEEKEND NUMBER;--�T�x�t�^����
USED_WEEKEND NUMBER;--�T�x�̏�������
CONVERT_DAYS NUMBER;--�T�x�̋��^���Z����
LAST_DAY_MONTH VARCHAR(2);--���̍Ō�̓�
DATE_YEAR VARCHAR(4);--������ߑΏ۔N���̔N
DATE_MONTH VARCHAR(2);--������ߑΏ۔N���̌�
intErrorInfo  NUMBER;
CNT  NUMBER;
--�� �J�[�\��
     -- �T�J�[�\��
    CURSOR CUR_WEEKS IS
      SELECT m.weekno AS week_no,min(m.���t) AS start_Date,MAX(m.���t) AS end_Date
      FROM
      (
            SELECT
                   T.*
                   ,TO_CHAR(TO_DATE(T.���t, 'yyyy/mm/dd'),'mm') AS MON
                   ,TO_CHAR(TO_DATE(T.���t, 'yyyy/mm/dd'),'dd') AS DAYS
                   ,TO_CHAR(TO_DATE(T.���t, 'yyyy/mm/dd'),'yyyy/mm') AS YEARMONTH
                   ,ROWNUM
                   ,DECODE(SIGN(ROWNUM-7),-1,1,0,1,DECODE(SIGN(ROWNUM-14),-1,2,0,2,DECODE(SIGN(ROWNUM-21),-1,3,0,3,DECODE(SIGN(ROWNUM-28),-1,4,0,4,DECODE(SIGN(ROWNUM-35),-1,5,0,5,DECODE(SIGN(ROWNUM-42),-1,6,0,6,0)))))) AS WEEKNO
             FROM
                      (
                        SELECT TO_CHAR((select to_date(YEAR_MONTH||'/01','yyyy/mm/dd')-DECODE((select to_char(to_date(YEAR_MONTH||'/01','yyyy/mm/dd'),'D') from dual),7,0,(select to_char(to_date(YEAR_MONTH||'/01','yyyy/mm/dd'),'D') from dual)) from dual) + ROWNUM - 1,'yyyy/mm/dd') as ���t
                        FROM DUAL
                        CONNECT BY ROWNUM <=42
                      ) T
             WHERE
                   ROWNUM <= 42
      ) M
      WHERE M.YEARMONTH = YEAR_MONTH
      GROUP BY m.weekno
      ORDER BY m.weekno;

--�y�P�D�T�̊���ߎc�Ǝ��Ԃ̌v�Z�z--------
       -- �T�̏�����Ԃ��擾
       CURSOR CUR_WEEKMAX(WEEK_NUM NUMBER) IS  SELECT ������� AS MAXTIME  FROM M_����J�����ԏ���Ǘ� WHERE �N��=  YEAR_MONTH AND �T�ԍ� = WEEK_NUM;

      -- �Ј��J�[�\��
      CURSOR CUR_EMPS IS SELECT DISTINCT �Ј�ID AS EMP_ID,���[�UID AS USER_ID FROM T_�Αӎ��� WHERE �ΑӔN���� LIKE YEAR_MONTH||'/%'  ORDER BY �Ј�ID,���[�UID;

      -- �t���[�T�x�t�^�������擾
      CURSOR CUR_OWN_WEEKEND(USER_ID VARCHAR2) IS SELECT * FROM M_�T�x�t�^�Ǘ� A INNER JOIN M_���[�U�Ǘ� B ON A.���[�UID = B.���[�UID AND A.�Ј�ID = B.�Ј�ID AND A.�Ј�ID = USER_ID AND �J�z�t�^�N�x = DATE_YEAR;

      -- �t���[�T�x�̏����������擾
      CURSOR CUR_USED_WEEKEND(USER_ID VARCHAR2) IS SELECT COUNT(*) AS CNT_USED FROM T_�T�x�Ǘ� WHERE ���^���Z�t���O = '0' AND �Ј�ID = USER_ID AND �ΑӔN���� LIKE YEAR_MONTH||'%';

BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �v�Z���� START >>>>>>>>>>');
    --������
    intErrorInfo := 0;
    DBMS_OUTPUT.PUT_LINE('������ߑΏ۔N��:'||YEAR_MONTH); -- ������ߑΏ۔N��
  -- ���̍Ō�̓�
  SELECT DAYS INTO LAST_DAY_MONTH FROM(SELECT to_char(last_day(to_date(YEAR_MONTH,'yyyy/mm')),'dd') AS DAYS from DUAL);
  -- ������ߑΏ۔N���̔N
  SELECT YEARS INTO DATE_YEAR FROM(SELECT to_char(TO_DATE(YEAR_MONTH,'yyyy/mm'),'yyyy') AS YEARS FROM DUAL);
  -- ������ߑΏ۔N���̌�
  SELECT MONTHS INTO DATE_MONTH FROM(SELECT to_char(TO_DATE(YEAR_MONTH,'yyyy/mm'),'mm') AS MONTHS FROM DUAL);

--�v�Z���� START
      -- �Ј��J�[�\��
    FOR EMP IN CUR_EMPS
      LOOP

             BEGIN
             --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �P�D�T�̊���ߎc�Ǝ��Ԃ̌v�Z START >>>>>>>>>>');
                --�T�J�[�\��
                FOR WEEK IN CUR_WEEKS
                    LOOP
                    -- �@ �Ј����A�T���̏���J�����Ԃ��v�Z
                    SELECT COUNT(*) INTO WEEK_CNT
                    FROM T_�Αӎ���
                    WHERE �ΑӔN���� >= WEEK.start_Date
                          AND �ΑӔN���� <= WEEK.end_Date
                          AND (�Ζ��敪 IN('10','20','40','43','65','61','63','16','15','11') OR (select to_char(to_date(�ΑӔN����,'yyyy/mm/dd'),'D') from dual)  = 1 )
                          AND �Ј�ID = EMP.EMP_ID;

                    --�A �T�̏�����Ԃ��擾
                    WEEK_MAX := 0;
                    FOR TMP IN CUR_WEEKMAX(WEEK.week_no) LOOP
                           IF CUR_WEEKMAX%FOUND THEN
                               WEEK_MAX := TMP.MAXTIME;
                           END IF;
                    END LOOP;

                    --�B �T�̊���ߎc�Ǝ��Ԃ��v�Z  ( �@ - �A )  �~ 60��
                     WEEK_RESULT:= (WEEK_CNT*7-WEEK_MAX) * 60;
                     IF WEEK_RESULT IS NULL OR WEEK_RESULT < 0 THEN
                         WEEK_RESULT :=0;
                     END IF;

                    -- �v�Z���ʂ�T_�Αӎ���.�T����ߎc�Ǝ��Ԃɐݒ肷��B�ݒ肷�郌�R�[�h�͊e�T�̍ŏI���̃��R�[�h�B
                    UPDATE T_�Αӎ��� SET �T����ߎc�� = WEEK_RESULT WHERE �Ј�ID = EMP.EMP_ID AND �ΑӔN���� = WEEK.end_Date;

             END LOOP; --�T�J�[�\��  END
             EXCEPTION
                    when others then
                    intErrorInfo := -99;
                    dbms_output.put_line('1.���G���[(' || TO_CHAR(intErrorInfo) || '):�V�X�e���G���[');
                    dbms_output.put_line(SQLCODE||'---'||SQLERRM);
                    RETURN intErrorInfo;
         --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �P�D�T�̊���ߎc�Ǝ��Ԃ̌v�Z END >>>>>>>>>>');
         END;

         BEGIN
         --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �Q�D���̊���ߎc�Ǝ��Ԃ̌v�Z START >>>>>>>>>>');
            -- �@ �Ј����A�����̏���J�����Ԃ��v�Z
            SELECT COUNT(*) INTO MONTH_CNT
            FROM T_�Αӎ���
            WHERE �ΑӔN���� >= YEAR_MONTH||'/01'
                  AND �ΑӔN���� <= YEAR_MONTH||'/'||LAST_DAY_MONTH
                  AND (�Ζ��敪 IN('10','20','40','43','65','61','63','16','15','11') OR (select to_char(to_date(�ΑӔN����,'yyyy/mm/dd'),'D') from dual)  = 1 )
                  AND �Ј�ID = EMP.EMP_ID;

            --�A ���̏�����Ԃ��擾
            MONTH_MAX := 0;
            FOR TMP IN CUR_WEEKMAX(9) LOOP
                   IF CUR_WEEKMAX%FOUND THEN
                       MONTH_MAX := TMP.MAXTIME;
                   END IF;
            END LOOP;

             --�B ���̊���ߎc�Ǝ��Ԃ��v�Z  ( �@ - �A )  �~ 60��
             MONTH_RESULT:= (MONTH_CNT*7-MONTH_MAX) * 60;
             IF MONTH_RESULT IS NULL OR MONTH_RESULT < 0 THEN
                 MONTH_RESULT :=0;
             END IF;

             -- �v�Z���ʂ�T_�Αӎ���.���̊���ߎc�Ǝ��Ԃɐݒ肷��B
             UPDATE T_�Αӎ��� SET ������ߎc�� = MONTH_RESULT WHERE �Ј�ID = EMP.EMP_ID AND �ΑӔN���� = YEAR_MONTH||'/'||LAST_DAY_MONTH;

        EXCEPTION
              when others then
              intErrorInfo := -99;
              DBMS_OUTPUT.PUT_LINE('2.���G���[(' || TO_CHAR(intErrorInfo) ||'):�V�X�e���G���[');
              DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
              RETURN intErrorInfo;
        --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �Q�D���̊���ߎc�Ǝ��Ԃ̌v�Z END >>>>>>>>>>');
        END;

        BEGIN
        --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �R�D�t���[�T�x�̋��^���Z�����v�Z START >>>>>>>>>>');

          -- �@�t���[�T�x�t�^�������擾
          FOR OWN IN CUR_OWN_WEEKEND(EMP.EMP_ID)
            LOOP
              IF CUR_OWN_WEEKEND%FOUND THEN
                   IF DATE_MONTH = '01' THEN
                         OWN_WEEKEND := OWN.��01;
                         ELSIF DATE_MONTH = '02' THEN
                         OWN_WEEKEND := OWN.��02;
                         ELSIF DATE_MONTH = '03' THEN
                         OWN_WEEKEND := OWN.��03;
                         ELSIF DATE_MONTH = '04' THEN
                         OWN_WEEKEND := OWN.��04;
                         ELSIF DATE_MONTH = '05' THEN
                         OWN_WEEKEND := OWN.��05;
                         ELSIF DATE_MONTH = '06' THEN
                         OWN_WEEKEND := OWN.��06;
                         ELSIF DATE_MONTH = '07' THEN
                         OWN_WEEKEND := OWN.��07;
                         ELSIF DATE_MONTH = '08' THEN
                         OWN_WEEKEND := OWN.��08;
                         ELSIF DATE_MONTH = '09' THEN
                         OWN_WEEKEND := OWN.��09;
                         ELSIF DATE_MONTH = '10' THEN
                         OWN_WEEKEND := OWN.��10;
                         ELSIF DATE_MONTH = '11' THEN
                         OWN_WEEKEND := OWN.��11;
                         ELSIF DATE_MONTH = '12' THEN
                         OWN_WEEKEND := OWN.��12;
                     END IF;
               ELSE
                     OWN_WEEKEND := 0;
               END IF;
            END LOOP;

          -- �A�t���[�T�x�̏����������擾
            USED_WEEKEND := 0;
            FOR TMP IN CUR_USED_WEEKEND(EMP.EMP_ID) LOOP
                   IF CUR_USED_WEEKEND%FOUND THEN
                       USED_WEEKEND := TMP.CNT_USED;
                   END IF;
            END LOOP;
            
            IF USED_WEEKEND > 0 THEN
                  -- �B�t���[�T�x�̋��^���Z�������v�Z���A�e�[�u���ɓo�^ �@ - �A�@���@���^���Z����
                  CONVERT_DAYS := (OWN_WEEKEND-USED_WEEKEND);
                   IF CONVERT_DAYS IS NULL OR CONVERT_DAYS < 0 THEN
                       CONVERT_DAYS :=0;
                   END IF;

                  -- �T�x�Ǘ��e�[�u���ɓo�^����B
                  SELECT COUNT(1) INTO CNT FROM T_�T�x�Ǘ� WHERE �ΑӔN���� = (YEAR_MONTH||'/99') AND �Ј�ID = EMP.EMP_ID AND ���[�UID = EMP.USER_ID;
                   IF CNT = 0 THEN
                        INSERT INTO T_�T�x�Ǘ� VALUES(
                        YEAR_MONTH||'/99' --�ΑӔN����
                        ,EMP.EMP_ID --�Ј�ID
                        ,EMP.USER_ID --���[�UID
                        ,CREATE_USER --�쐬�Ҕԍ�
                        ,SYSDATE --�쐬����
                        ,CREATE_USER --�ŏI�X�V�Ҕԍ�
                        ,SYSDATE --�ŏI�X�V����
                        ,'1' --���^���Z�t���O
                         ,CONVERT_DAYS --���^���Z����
                        );
                    ELSE
                       UPDATE T_�T�x�Ǘ� SET  �ŏI�X�V�Ҕԍ� = CREATE_USER,�ŏI�X�V���� = SYSDATE,���^���Z�t���O = '1',���^���Z���� = CONVERT_DAYS
                       WHERE �ΑӔN���� = (YEAR_MONTH||'/99') AND �Ј�ID = EMP.EMP_ID AND ���[�UID = EMP.USER_ID;
                      END IF;
            END IF;


        EXCEPTION
          WHEN OTHERS THEN
          intErrorInfo := -99;
          DBMS_OUTPUT.PUT_LINE('3.���G���[(' || TO_CHAR(intErrorInfo) || '):�V�X�e���G���[');
          DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
          RETURN intErrorInfo;
    --DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �R�D�t���[�T�x�̋��^���Z�����v�Z END >>>>>>>>>>');
    END;

    END LOOP;-- �Ј��J�[�\��  END
   --�v�Z���� END
   DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< �v�Z���� END >>>>>>>>>>');
  RETURN(intErrorInfo);
END F_WORKINGSCHEDULE_CALC;
/
