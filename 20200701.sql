** cond 1 실습 ) 
SELECT empno, ename, deptno,
    CASE 
        WHEN deptno = 10 THEN 'ACCOUNTING' 
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 10 THEN 'OPERATIONS'
        ELSE 'DDIT'
    END DNAME
FROM emp ; 

* decode 사용 
SELECT empno, ename, deptno,
    DECODE(deptno, 10, 'ACCOUNTING',
                   20, 'RESEARCH', 
                   30, 'SALES',
                   40, 'OPERATIONS',
                   'DDIT') DNAME
FROM emp; 


** DECODE : 조건에 따라 반환 값이 달라지는 함수 
     => 비교, JAVA(=if), SQL CASE와 비슷.  
     단, 비교연산이 (=) 만 가능
     CASE의 WHEN절에 기술할 수 있는 코드는 참 거짓 판단할 수 있는 코드면 가능
    ex. sal > 1000
    이것과 다르게 DECODE 함수에는 sal = 1000, sal = 2000, equal 비교만 가능
     
DECODE는 가변인자(인자의 갯수가 정해지지 않음, 상황에 따라 늘어날 수도 있다)를 갖는 함수
문법 : DECODE (기준값[col | expression], 
                비교값1, 반환값1,
                비교값2, 반환값2, 
                비교값3, 반환값3,
                옵션[기준값이 비교값 중에 일치하는 값이 없을 때 기본적으로 반환할 값])
==> java
if (기준값 == 비교값1)
    반환값1을 반환해준다
else if ( 기준값 == 비교값2 )
    반환값2을 반환해준다
else if (기준값 == 비교값3)
    반환값3을 반환해준다
else
    마지막 인자가 있을 경우 마지막 인자를 반환하고 
    마지막 인자가 없을 경우 null을 반환

* decode 사용 

SELECT empno, ename, deptno,
    DECODE(deptno, 10, 'ACCOUNTING',
                   20, 'RESEARCH', 
                   30, 'SALES',
                   40, 'OPERATIONS',
                   'DDIT') DNAME
FROM emp; 

SELECT ename, job, sal, DECODE(job, 'SALESMAN', sal*1.05,
                                    'MANAGER', sal*1.10, 
                                    'PRESIDENT', sal*1.20,
                                    sal*1) bonus
FROM emp ;                                     
    
* 위의 문제처럼 JOB에 따라서 sal을 인상을 한다.
  단, 추가 조건으로 job이 manager이면서 소속부서(deptno)가 30(sales)이면  sal*1.5

SELECT ename, job, sal, deptno, 
   CASE
     WHEN job = 'SALESMAN' THEN sal*1.05
     WHEN job = 'MANAGER' THEN sal*1.10
     WHEN job = 'MANAGER' AND deptno = 30 THEN sal*1.5
     WHEN job = 'PRESIDENT' THEN sal*1.20
     ELSE sal
   END bonus  
FROM emp ; 
    //조건에 맞는 문장을 먼저 접하면 뒤에 있는 조건은 스킵하고 넘어감. 매니저일때 1.1 문장만 하고 다음은 X 

SELECT ename, job, sal, deptno, 
   CASE
     WHEN job = 'SALESMAN' THEN sal*1.05
     WHEN job = 'MANAGER' AND deptno = 30 THEN sal*1.5
     WHEN job = 'MANAGER' THEN sal*1.10
     WHEN job = 'PRESIDENT' THEN sal*1.20
     ELSE sal
   END bonus  
FROM emp ; 

SELECT ename, job, sal, deptno, 
   CASE
     WHEN job = 'SALESMAN' THEN sal*1.05
     WHEN job = 'MANAGER' THEN 
                                CASE 
                                    WHEN deptno = 30 THEN sal*1.5
                                    ELSE sal*1.10
                                END
     WHEN job = 'PRESIDENT' THEN sal*1.20
     ELSE sal
   END bonus  
FROM emp ; 
    //CASE 도 중첩이 되는 것이 가능 

SELECT ename, job, sal, deptno, 
    DECODE(job, 'SALESMAN', sal*1.05, 
                'MANAGER', DECODE(deptno, 30, sal*1.5, sal*1.10 ),
                'PRESIDENT', sal*1.20,
                sal*1) bonus
FROM emp ;                                     


** condition 실습 cond2 )
해당사원의 입사가 홀수년인지, 짝수년인지 구분
짝수 => 2로 나눴을 때 나머지가 항상 0 / 홀수 => 2로 나눴을 때 나머지가 항상 1
==> 함수 MOD
SELECT empno, ename, hiredate, 
    CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자' 
    END contact_to_doctor   
FROM emp ; 

SELECT empno, ename, hiredate, 
    DECODE(MOD(TO_CHAR(hiredate, 'YYYY'), 2), MOD(TO_CHAR(SYSDATE, 'YYYY'), 2), '건강검진 대상자', 
    '건강검진 비대상자') CONTACT_TO_DOCTOR  
FROM emp ; 

** condition 실습 cond3 )

SELECT userid, usernm, reg_dt, 
        DECODE(MOD(TO_CHAR(reg_dt, 'YYYY'), 2), MOD(TO_CHAR(SYSDATE, 'YYYY'), 2), 
        '건강검진 대상자', '건강검진 비대상자') CONTACT_TO_DOCTOR
FROM users ; 


* 그룹함수 : 여러 개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수
SUM : 합계
COUNT : 행의 수
AVG : 평균
MAX : 그룹에서 가장 큰 값
MIN : 그룹에서 가장 작은 값

사용방법
SELECT 행들을 묶을 기준1, 행들을 묶을 기준2, 그룹함수
FROM 테이블
[WHERE]
GROUP BY 행들을 묶을 기준1, 행들을 묶을 기준2

부서번호별 sal 컬럼의 합 ==> 부서번호가 같은 행들을 하나의 행으로 만든다.
SELECT deptno, SUM(sal)
FROM emp  
GROUP BY deptno ; 
    //emp 테이블에 부서번호를 기준으로 3개, 3개로 그룹핑됨. 그룹별 sal의 합계

1. 부서번호별 sal 컬럼의 합계    
2. 부서번호별 가장 큰 급여를 받는 사람 급여 액수
3. 부서번호별 가장 작은 급여를 받는 사람의 급여 액수 
4. 부서번호별 급여 평균(소수점 2자리까지) 
5. 부서번호별 급여가 존재하는 사람의 수(sal컬럼이 null이 아닌 행의 수)
* : 그 그룹의 행수
SELECT deptno, SUM(sal), MAX(sal), MIN(sal), ROUND(AVG(sal), 2), 
        COUNT(sal), COUNT(comm), COUNT(*)
FROM emp 
GROUP BY deptno ; 

그룹함수의 특징 1 : null값을 무시한다. 
30번 부서에서 6명중 2명은 comm값이 null 
SELECT deptno, comm
FROM emp ;

SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno ; 

그룹함수의 특징 2 : GROUP BY를 적용할때 여러행을 하나의 행으로 묶게 되면
                  SELECT절에 기술할수 있는 컬럼이 제한됨
                  ==> SELECT 절에 기술되는 일반 컬럼들은 (그룹 함수를 적용하지 않은)
                      반드시 GROUP BY 절에 기술되어야 한다.
                      * 단, 그룹핑에 영향을 주지 않는 고정된 상수, 함수는 기술하는 것이 가능하다.
SELECT deptno, ename, SUM(sal)
FROM emp
GROUP BY deptno ; 
    //부서 번호로 그룹핑 했는데 사원 이름은 부서번호로 그룹핑 되지 않기 때문에 에러. 
    요구사항에 맞게 기술하는 것이 필요. 그룹핑이 되도록 
SELECT deptno, SUM(sal), 10 
FROM emp
GROUP BY deptno ; 

* 그룹함수의 제한사항
부서번호별 가장 높은 급여를 받는 사람의 급여액
그래서 그 사람이 누군데??? (서브쿼리, 분석함수에서 배우는 내용) 
    ==> 가장 큰 급여액은 알수 있지만 누군지는 알수 없다.(ename 적용할수없음)
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno ;  

그룹함수 이해하기 힘들면 ==> 엑셀에 데이터를 그려보자!

그룹함수의 특징 3 : 일반함수를 WHERE절에서 사용하는 것이 가능
                  (WHERE UPPER('smith')= 'SMITH')
                  그룹함수의 경우 WHERE절에서 사용하는게 불가능
                  하지만 HAVING절에 기술하여 동일한 결과를 나타낼수 있다.
         
* SUM(sal)값이 9000보다 큰 행들만 조회하고 싶은 경우

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno 
HAVING SUM(sal) > 9000 ; 

위의 쿼리를 HAVING절 없이 SQL 작성 : IN-LIVE절
SELECT * 
FROM (SELECT deptno, SUM(sal) sum_sal
      FROM emp
      GROUP BY deptno) 
WHERE sum_sal > 9000 ; 

SELECT 쿼리 문법 총정리 
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY

GROUP BY 절에 행을 그룹핑할 기준을 작성
EX. 부서번호별로 그룹을 만들 경우 
    GROUP BY deptno
전체 행을 기준으로 그룹핑을 하려면 GROUP BY 절에 어떤 컬럼을 기술해야할까?
emp 테이블에 등록된 14명의 사원 전체의 급여 합계를 구하려면? 결과는 1개의 행
==> GROUP BY 절을 기술하지 않는다. 
SELECT SUM(sal)
FROM emp ; 

GROUP BY 절에 기술한 컬럼을 SELECT절에 기술하지 않은 경우 
SELECT SUM(sal)
FROM emp
GROUP BY deptno ; 
