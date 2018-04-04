CREATE OR REPLACE FUNCTION F_TEST(
IN_TABLE IN VARCHAR -- 表名
,IN_TAG_NO IN  VARCHAR -- tag_no
,IN_SYS_ID IN  VARCHAR -- sys_id
,IN_DATE IN VARCHAR -- 日期
,IN_HOUR IN VARCHAR -- 小?
,IN_ADD_DAY IN NUMBER -- 增加天数
,IN_PLUS_MINUS IN NUMBER -- 符号（空或0 : + | 1: -）
,IN_INCREMENT IN NUMBER -- 增量 (默?10，)
)
RETURN NUMBER
IS
--■ 変数
intErrorInfo  NUMBER;
CNT  NUMBER;
MAX_COUNT NUMBER;
SPACE VARCHAR2(1);
T_DATE VARCHAR2(32);
T_HOUR VARCHAR2(32);
FORMAT VARCHAR2(32);
FORMAT_HH VARCHAR2(32);
FORMAT_HH_MI VARCHAR2(32);
FORMAT_FULL VARCHAR2(32);
PLUS_MINUS NUMBER;
INCREMENT NUMBER;
CNT_RECORD NUMBER;-- ??数量
P_VAL NUMBER;
--■ 游?


BEGIN
    DBMS_OUTPUT.ENABLE (buffer_size=>null) ;
    DBMS_OUTPUT.PUT_LINE('<<<<<<<<<< 計算処理 START >>>>>>>>>>');
    --初期化
    intErrorInfo := 0;
    SPACE := ' ';
    CNT_RECORD := -1;
    FORMAT := 'yyyy/mm/dd';
    FORMAT_HH := 'yyyy/mm/dd hh24';
    FORMAT_FULL := 'yyyy/mm/dd hh24:mi:ss';
    P_VAL := 0;

    -- DATE
    T_DATE := IN_DATE;
    IF IN_DATE IS NULL THEN
       T_DATE := TO_CHAR(SYSDATE,FORMAT);
    END IF;

    -- 小?
    T_HOUR := IN_HOUR;
    IF IN_HOUR IS  NULL THEN
      T_HOUR := TO_CHAR(SYSDATE,'hh24');
    END IF;

    -- 增加天
    IF IN_ADD_DAY IS NOT NULL THEN
       T_DATE := TO_CHAR(TO_DATE(T_DATE,FORMAT) + IN_ADD_DAY,FORMAT);
    END IF;

    -- 正?号
    IF IN_PLUS_MINUS IS NULL OR IN_PLUS_MINUS = '0' THEN
       PLUS_MINUS := 1;
    ELSIF IN_PLUS_MINUS = '1' THEN
       PLUS_MINUS := -1;
    END IF;

    -- 增量
    INCREMENT := 10;
    IF IN_INCREMENT IS NOT NULL AND IN_INCREMENT != 0 THEN
       INCREMENT := IN_INCREMENT;
    END IF;


--1、小数( 0 ~ 1)

     -- select dbms_random.value from dual ;

--2、指定范?内的小数 ( 0 ~ 100 )
      -- select dbms_random.value(0,100) from dual ;


--3、指定范?内的整数 ( 0 ~ 100 )

     -- select trunc(dbms_random.value(0,100)) from dual ;

    -- "1,LSDDAYRP", "2,LSDMONRP", "3,LSDYERRP", "4,LSDREALT"

    IF IN_TABLE IS NULL OR IN_TABLE = '1' THEN
       MAX_COUNT := 24;
       T_DATE:= TO_CHAR(to_date(T_DATE,FORMAT),FORMAT)||' 00:00:00';
    ELSIF IN_TABLE = '2' OR IN_TABLE = 2 THEN
       MAX_COUNT := 31;
    ELSIF IN_TABLE = '3' OR IN_TABLE = 3 THEN
       MAX_COUNT := 12;
    ELSIF IN_TABLE = '4' OR IN_TABLE = 4 THEN
       MAX_COUNT := 60;
       T_DATE:= TO_CHAR(to_date(T_DATE,FORMAT),FORMAT)||SPACE||T_HOUR||':00:00';
    END IF;

             BEGIN
             CNT := 1;
             LOOP
                EXIT WHEN CNT> MAX_COUNT;
                     IF IN_INCREMENT = '0' THEN
                        SELECT trunc(dbms_random.value(1,100)) INTO INCREMENT FROM dual;
                     END if;
                --day:CNT hour:CNT/24 minute:CNT/24/60 second:CNT/24/60/60
             -- 插入的数据
             P_VAL := PLUS_MINUS*CNT*INCREMENT;
             IF IN_TABLE IS NULL OR IN_TABLE = '1' THEN -- LSDDAYRP
               -- 判断数据是否已?存在 start
                SELECT COUNT(1) INTO CNT_RECORD FROM LSDDAYRP
                              WHERE SYS_ID = IN_SYS_ID
                                   AND TAG_NO = IN_TAG_NO
                                   AND P_DATE =  (TO_DATE(T_DATE,FORMAT_FULL) + (CNT - 1) /24);
                -- 判断数据是否已?存在 end
                IF CNT_RECORD = 0 THEN
                     INSERT INTO LSDDAYRP("SYS_ID","TAG_NO","P_DATE","P_VAL1","REC_FLG","REC_PGID","REC_DATE"
                     )VALUES(
                     IN_SYS_ID,
                     IN_TAG_NO,
                     (TO_DATE(T_DATE,FORMAT_FULL) + (CNT - 1) /24),
                     P_VAL,
                     '00',
                     'SONIS',
                     SYSDATE
                     );
                ELSE
                     UPDATE LSDDAYRP SET P_VAL1 = P_VAL
                                   WHERE SYS_ID = IN_SYS_ID
                                        AND TAG_NO = IN_TAG_NO
                                        AND P_DATE =  (TO_DATE(T_DATE,FORMAT_FULL) + (CNT - 1) /24);
                END IF;

             ELSIF IN_TABLE = '4' THEN -- LSDREALT
               -- 判断数据是否已?存在 start
                SELECT COUNT(1) INTO CNT_RECORD FROM LSDREALT
                            WHERE SYS_ID = IN_SYS_ID
                                 AND TAG_NO = IN_TAG_NO
                                 AND P_DATE =  (TO_DATE(T_DATE,FORMAT_FULL) + (CNT - 1) /24 /60);
                -- 判断数据是否已?存在 end
                IF CNT_RECORD = 0 THEN
                     INSERT INTO LSDREALT("SYS_ID","TAG_NO","P_DATE","P_VAL1","REC_FLG","REC_PGID","REC_DATE"
                     )VALUES(
                     IN_SYS_ID,
                     IN_TAG_NO,
                     (TO_DATE(T_DATE,FORMAT_FULL) + (CNT - 1) /24 /60),
                     P_VAL,
                     '00',
                     'SONIS',
                     SYSDATE
                     );
                ELSE
                     UPDATE LSDREALT SET P_VAL1 = P_VAL
                                    WHERE SYS_ID = IN_SYS_ID
                                         AND TAG_NO = IN_TAG_NO
                                         AND P_DATE =  (TO_DATE(T_DATE,FORMAT_FULL) + (CNT - 1) /24 /60);
                END IF;

             END IF;
                CNT:= CNT + 1;
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
/
