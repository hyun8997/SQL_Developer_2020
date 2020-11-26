-- [DML (Data Manipulation Language) ] : ������ ���۾�
-- ���̺��� �� ���� �߰�
-- ���̺��� ���� ���� ����
-- ���̺����� ���� ���� ����

-- INSERT ����(�� ����)
-- 1)	�� �� ����
-- INSERT INTO ���̺��� VALUES (������ ������);
INSERT INTO DEPT
VALUES (50, 'A', 'B');

SELECT * FROM DEPT;

-- 2) NULL ���� ���� ���� ����
-- �Ͻ���: �� ����Ʈ���� ���� ����
INSERT INTO DEPT (DEPTNO, DNAME)
VALUES (60, 'C');

SELECT * FROM DEPT;

-- ������: VALUES ������ NULL Ű���� ����
INSERT INTO DEPT
VALUES (70, 'D', NULL);

SELECT * FROM DEPT;

-- 3)	Ư���� ����: �Լ� ��� ����
INSERT INTO EMP (EMPNO, HIREDATE)
VALUES (9090, SYSDATE);

SELECT * FROM EMP WHERE EMPNO=9090;

-- cf)
SELECT SYSDATE FROM DUAL
UNION ALL
SELECT CURRENT_DATE FROM DUAL;

--	SYSDATE: �ý��ۿ����� ���� �ð��� ��ȯ
--	CURRENT_DATE: ���� ���ǿ����� ���� �ð��� ��ȯ

SELECT SESSIONTIMEZONE, CURRENT_DATE FROM DUAL;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';
ALTER SESSION SET TIME_ZONE = '-5:0';   --���� �ð��� ����
SELECT SESSIONTIMEZONE, CURRENT_DATE FROM DUAL;

-- 4) Ư�� ��¥ �� �ð� ����
ALTER SESSION SET NLS_LANGUAGE = 'AMERICAN';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR';
INSERT INTO EMP(EMPNO, HIREDATE)
VALUES(9091, SYSDATE);

SELECT * FROM EMP WHERE EMPNO=9091;

SELECT * FROM EMP;

INSERT INTO EMP(EMPNO, HIREDATE)
VALUES(9092, TO_DATE(SYSDATE, 'DD-MON-RR'));

SELECT * FROM EMP;

ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';
ALTER SESSION SET NLS_LANGUAGE = 'KOREAN';

SELECT * FROM EMP;

DELETE FROM EMP  WHERE EMPNO IN (9090, 9091, 9092);
SELECT * FROM EMP;

--5)	��ũ��Ʈ �ۼ�
--SQL���� &ġȯ�� ����Ͽ� ���� �Է��ϵ��� �䱸
--&ġȯ - &�������� ���� ��ġ ǥ����
INSERT INTO DEPT(DEPTNO, DNAME, LOC)
VALUES (&DEPTNO, '&DNAME', '&LOC');

--6)	�ٸ� ���̺����� �� �����ؼ� ����
INSERT INTO DEPT (DEPTNO)
    SELECT GRADE FROM SALGRADE
    WHERE GRADE = 1;
    
SELECT * FROM DEPT;

--UPDATE ���� (������ ����)
--1)	���̺� �� ����
--WHERE �� �� : ��� �� ����
--WHERE �� �� : Ư�� �� ����
UPDATE DEPT
SET DNAME = 'G'
WHERE DEPTNO= 60;

SELECT * FROM DEPT;

--2)	���������� ����Ͽ� ���� �� ���� ����
--7900 ����� ��å�� �޿��� ���ÿ� ���� <- 7521 ����� ��å�� �޿��� ����
UPDATE EMP
SET JOB = (SELECT JOB
                    FROM EMP
                    WHERE EMPNO=7521),
        SAL =  (SELECT SAL
                    FROM EMP
                    WHERE EMPNO=7521)
WHERE EMPNO = 7900;

SELECT EMPNO, JOB, SAL
FROM EMP
WHERE EMPNO IN(7900,7521);

-- ���� : EMP ���̺����� ����� 7499�� ����� ������ ��å�� ���� ������� SAL ���� 7902 ����� SAL ������ ����
UPDATE EMP
SET SAL = (SELECT SAL
                    FROM EMP
                    WHERE EMPNO=7902)
WHERE JOB = (SELECT JOB
                        FROM EMP
                        WHERE EMPNO =7499);

SELECT EMPNO, JOB, SAL FROM EMP;

ROLLBACK;

SELECT * FROM EMP;

SELECT * FROM DEPT;

-- 3) �ٸ� ���̺��� ������� �� ����: �������� �̿�
CREATE TABLE COPY_EMP
AS
SELECT * FROM EMP;

SELECT * FROM COPY_EMP;

-- EMP ���̺� ������� �Ͽ� ��� ��ȣ�� 7934�� ����� ��å�� ������ ����� �μ���ȣ�� 
-- ���� 7902 ����� �μ���ȣ�� ��� �����Ѵ�.
UPDATE COPY_EMP
SET DEPTNO = (SELECT DEPTNO
                        FROM EMP
                        WHERE EMPNO=7902)
WHERE JOB = (SELECT JOB
                        FROM EMP
                        WHERE EMPNO=7934);
                        
SELECT * FROM COPY_EMP;

-- ���� : EMP ���̺��� ������� �����ȣ�� 7934�� ����� �Ŵ����� ������ �μ���ȣ�� ������ �ִ�
-- ��� ����� �μ���ȣ�� ����(COPY_EMP) 7902 ����� �μ���ȣ�� ��� �����Ͻÿ�.
UPDATE COPY_EMP
SET DEPTNO = (SELECT DEPTNO
                        FROM EMP
                        WHERE EMPNO=7902)
WHERE DEPTNO = (SELECT DEPTNO
                              FROM EMP
                              WHERE EMPNO=(SELECT MGR
                                                         FROM EMP
                                                         WHERE EMPNO=7934));
                                                         
CREATE TABLE COPY_EMP_2
AS
SELECT * FROM EMP; 

UPDATE COPY_EMP_2
SET DEPTNO = (SELECT DEPTNO
                        FROM EMP
                        WHERE EMPNO=7902)
WHERE DEPTNO = (SELECT C.DEPTNO
                              FROM EMP E JOIN EMP C
                              ON C.EMPNO= E.MGR
                              WHERE E.EMPNO=7934);
                              
 SELECT * FROM COPY_EMP_2;                             
                              
SELECT * FROM EMP;
SELECT * FROM COPY_EMP;


--DELETE ����
--1)	���̺����� �� ����
--  	WHERE �� �� : ��� �� ����
--	    WHERE �� �� : Ư�� �� ����
SELECT * FROM DEPT;

DELETE FROM DEPT
WHERE DEPTNO = 50;

-- ���������� DELETE ������ FROM ���� ����
DELETE DEPT
WHERE DEPTNO IN (60, 70);

--2)	�ٸ� ���̺��� ������� �� ���� ����
DELETE FROM COPY_EMP
WHERE DEPTNO = (SELECT DEPTNO
                                FROM DEPT
                                WHERE DNAME = 'RESEARCH');

SELECT * FROM COPY_EMP;

ROLLBACK;

SELECT * FROM COPY_EMP;

SELECT * FROM DEPT;

--cf) TRUNCATE�� (DDL��)
-- : ���̺� ������ �״��, ��� �� ����
-- : ��, �ѹ��� �ȵ�
-- ���� : TRUNCATE TABLE ���̺���;



























