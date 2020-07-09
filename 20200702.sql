GROUP BY 함수의 특징
1. NULL은 그룹함수 연산에서 제외가 된다. 

부사번호 별 사원의 sal, comm 컬럼의 총 합을 구하기

SELECT deptno, SUM(sal + comm), SUM(sal + NVL(comm,0)), SUM(sal) + SUM(comm)
FROM emp
GROUP BY deptno ; 

SELECT *
FROM emp ; 
    // SUM(sal + comm) 내부에서 NULL값에 대한 연산이 일어남

NULL 처리의 효율
SELECT deptno, SUM(sal) + SUM(NVL(comm, 0)),
               SUM(sal) + NVL(SUM(comm), 0)
FROM emp
GROUP BY deptno ; 
    //comm 컬럼을 먼저 null처리 해주고 하는 것과 연산을 다 하고 null 처리 하는 것의 차이 

*** 개발자들이 하지말아야할 칠거지악 : decode 또는 case 사용시에 새끼를 증손자(3중첩) 이상 낳지 마라.

** grp1 실습 ) 
SELECT MAX(sal) MAX_SAL, MIN(sal) MIN_SAL, ROUND(AVG(sal), 2) AVG_SAL, 
       SUM(sal) SUM_SAL, COUNT(sal) COUNT_SAL, COUNT(mgr)COUNT_MGR, COUNT(*) COUNT_ALL
FROM emp ;  

** grp 2 실습 ) 부서 기준!!!
SELECT deptno, MAX(sal) MAX_SAL, MIN(sal) MIN_SAL, ROUND(AVG(sal), 2) AVG_SAL, 
       SUM(sal) SUM_SAL, COUNT(sal) COUNT_SAL, COUNT(mgr)COUNT_MGR, COUNT(*) COUNT_ALL
FROM emp 
GROUP BY deptno; 

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp 
GROUP BY deptno ; -- 내가 작성함

** grp 3 실습
SELECT DECODE(deptno, 10, 'ACCONTING', 20, 'RESEARCH', 30, 'SALSE', 'DDIT') DNAME,
       MAX(sal) MAX_SAL, MIN(sal) MIN_SAL, ROUND(AVG(sal), 2) AVG_SAL, 
       SUM(sal) SUM_SAL, COUNT(sal) COUNT_SAL, COUNT(mgr)COUNT_MGR, COUNT(*) COUNT_ALL
FROM emp 
GROUP BY deptno;

SELECT DECODE(deptno, 10, 'ACCONTING', 20, 'RESEARCH', 30, 'SALSE', 'DDIT') DNAME,
       MAX(sal) MAX_SAL, MIN(sal) MIN_SAL, ROUND(AVG(sal), 2) AVG_SAL, 
       SUM(sal) SUM_SAL, COUNT(sal) COUNT_SAL, COUNT(mgr)COUNT_MGR, COUNT(*) COUNT_ALL
FROM emp 
GROUP BY DECODE(deptno, 10, 'ACCONTING', 20, 'RESEARCH', 30, 'SALSE', 'DDIT');

SELECT 
******보충해야돼!!! 
FROM DECODE(deptno, 10, 'ACCONTING', 20, 'RESEARCH', 30, 'SALSE', 'DDIT') DNAME,
       MAX(sal) MAX_SAL, MIN(sal) MIN_SAL, ROUND(AVG(sal), 2) AVG_SAL, 
       SUM(sal) SUM_SAL, COUNT(sal) COUNT_SAL, COUNT(mgr)COUNT_MGR, COUNT(*) COUNT_ALL
FROM emp 
GROUP BY DECODE(deptno, 10, 'ACCONTING', 20, 'RESEARCH', 30, 'SALSE', 'DDIT');

** grp 4 실습 )
SELECT TO_CHAR(hiredate, 'YYYYMM'), COUNT(*)
FROM emp 
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

** grp 5 실습 )
SELECT TO_CHAR(hiredate, 'YYYY'), COUNT(*)
FROM emp 
GROUP BY TO_CHAR(hiredate, 'YYYY');

** grp 6 실습 )
SELECT *
FROM dept ;

SELECT COUNT(*) CNT
FROM dept ; 
    //모든 행을 하나로 합치니까 그룹핑 하지 않는다. 
    
** grp 7 )
SELECT *
FROM emp ;

SELECT COUNT(*)
FROM (SELECT deptno
      FROM emp 
      GROUP BY deptno) ; 
     
SELECT COUNT(COUNT(deptno)) CNT
FROM emp
GROUP BY deptno ; 


JOIN : 컬럼을 확장하는 방법 (데이터를 연결한다)
       다른 테이블의 컬럼을 가져온다
       
RDBMS가 중복을 최소화하는 구조이기 때문에
하나의 테이블에 데이터를 전부 담지 않고, 목적에 맞게 설계한 테이블에
데이터가 분산이 된다.
하지만 데이터를 조회할때 다른 테이블의 데이터를 연결하여 컬럼을 가져올 수 있다. 

ANSI-SQL : ANSI [American National Standards Institute] 
표준을 미국에서 지정?
ORACLE-SQL 문법

JOIN : ANSI-SQL
        ORACLE-SQL의 차이가 다소 발생
        
ANSI-SQL
NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로 행을 연결
               컬럼 이름뿐만 아니라 데이터 타입도 동일해야함 --조인할 컬럼을 명시해주지 않아도 됨
문법
SELECT 컬럼...
FROM 테이블1 NATURAL JOIN 테이블2

emp , dept 두 테이블의 공통된 이름을 갖는 컬럼 : deptno

조인 조건으로 사용된 컬럼은 테이블 한정자 붙이면 에러(ANSI-SQL)
SELECT emp.empno, emp.ename, deptno, dnpt.dname ----- dname으로! 
FROM emp NATURAL JOIN dept ; ----- 에러!!!

위의 쿼리를 ORACLE 버전으로 수정 
오라클에서는 조인 조건을 WHERE절에 기술
행을 제한하는 조건, 조인 조건 ==>  WHERE절에 기술

SELECT emp.*, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno ; 
    //테이블 이름.컬럼 ==> 한정자를 써서 어디에서 왔는지 알려줌
    //deptno = deptno 라고 쓰면 에러. 어디에서 왔는지 모호함. 한정자를 붙여야함
    //select절에서 전체를 조회하면 조인으로 겹쳐진 내용이 중복으로 조회됨
    // != 다를때 연결하라는 뜻. 그럼 부서번호가 10인 것과 20, 30, 40이 조인됨 3배의 결과가 나옴

ANSI-SQL : JOIN with USING
조인 테이블간 동일한 이름의 컬럼이 복수개 인데
이름이 같은 컬럼중 일부로만 조인하고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING (deptno) ; 

위의 쿼리를 ORACLE조인으로 변경하면? 
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno ; 

ANSI-SQL : JOIN with ON 
위에서 배운 NATUNAL JOIN, JOIM with USING의 경우 조인 테이블의 조인 컬럼이 이름이 같아야한다는 제약조건이 있음
설계상 두 테이블의 컬럼 이름 다를수도 있음. 컬럼 이름 다를 경우
개발자가 직접 조인 조건을 기술할수 있도록 제공해주는 문법

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

ORACLE-SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno ; 

SELF-JOIN : 동일한 테이블끼리 조인할 때 지칭하는 명령(별도의 키워드가 아니다)

SELECT 사원번호, 사원이름, 사원의 상사 사원번호, 사원의 상사 이름            
FROM emp; 

SELECT e.empno, e.ename, e.mgr, m.ename mgr_name
FROM emp e JOIN emp m ON ( e.mgr = m.empno );
    //상사가 없는 정보는 안나옴
    
사원 중 사원의 번호가 7369~7698인 사원만 대상으로 해당 사원의
사원번호, 이름, 상사의 사원번호, 상사의 이름 

SELECT e.empno, e.ename, m.empno, m.ename 
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno >= 7369
    AND e.empno <= 7698 ; 
    
WHERE e.empno BETWEEN 7369 AND 7698 ;  

SELECT a.*, emp.ename
FROM 
    (SELECT empno, ename, mgr
     FROM emp 
     WHERE empno BETWEEN 7369 AND 7698) a JOIN emp ON ( a.mgr = emp.empno) ; 
   
NON-EQUI-JOIM : 조인 조건이 = 이 아닌 조인
 != 값이 다를 때 연결

SELECT *
FROM salgrade; 
    //700~9999 까지 빠지는 값이 없음. 선분데이터 

SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal ; 

실습 0 

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno ; 

실습 1 
SELECT empno, ename, emp.deptno, dname 
FROM emp, dept
WHERE emp.deptno = dept.deptno 
    AND emp.deptno IN (10, 30); 
    
