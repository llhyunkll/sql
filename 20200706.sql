OUTER JOIN <==> INNER JOIN

INNER JOIN : 조인 조건을 만족하는 (조인에 성공하는) 데이터만 조회
OUTER JOIN : 조인 조건을 만족하지 않더라도 (조인에 실패하더라도) 기준이 되는 테이블 쪽의 
테이터(컬럼)은 조회가 되도록 하는 조인 방식

OUTER JOIN 
LEFT OUTER JOIN : 조인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
RIGHT OUTER JOIN : 조인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN 중복되는 것 제외

ANSI-SQL
FROM 테이블1 LEFT OUTER JOIN 테이블2 ON (조인 조건)

ORACLE-SQL : 데이터가 없는데 나와야하는 테이블의 컬럼 
FROM 테이블1, 테이블2
WHERE 테이블1.컬럼 = 테이블2.컬럼(+) 

ansi-sql outer
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

oracle 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+);

OUTER JOIN시 조인 조건(ON절에 기술)과 일반 조건(WHERE절에 기술)적용시 주의 사항
: OUTER JOIN 을 사용하는데 WHERE절에 별도의 다른 조건을 기술할 경우 원하는 결과가 안나올수 있다.
==> OUTER JOIN의 결과가 무시될수 있다 

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);

ORACLE-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+) 
  AND m.deptno(+) = 10;


==> OUTERE JOIN 조인조건을 WHERE절로 변경한 경우
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno ) 
WHERE m.deptno = 10; 

위의 쿼리는 OUTER JOIN을 적용하지 않은 아래의 쿼리와 동일한 결과를 나타낸다.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno ) 
WHERE m.deptno = 10; 

ORACLE-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+) 
  AND m.deptno = 10; ---(+)가 빠지면 INNER JOIN 한 것과 같은 결과 나온다. 

RIGHT OUTER JOIN : 기준 테이블이 오른쪽 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno ) ; 
--- 정보가 안나온 사람들은 누군가의 매니저가 아님. 평사원

FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno):
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno):

FULL OUTER JOIN = LEFT OUTER + RIGHT OUTER - 중복제거 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno ) ;

ORACLE SQL에서는 FULL OUTER 문법을 제공하지 않음 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr(+) = m.empno(+) ; --- 실행되지 않음 

** FULL OUTER 검증
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno ) 
UNION --- 행을 더해서 늘림. 중복되는 것은 삭제
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno ) 
MINUS -- 빼기
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno ) ; 


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno ) 
UNION 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno ) 
INTERSECT --- 교집합이라는 키워드 
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno ) ; 

*** outer join 1~5 과제 

<< 
WHERE : 행을 제한 
JOIN :
GROUP FUNCTION : 

시도 : 서울특별시 , 충청남도
시군구 : 강남구, 청주시
시토어 구분 : 

** outer join 1 )
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buy_prod = prod_id AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD')) ; 

** outer join 2 ) 
SELECT NVL(buy_date, TO_DATE('2005/01/25', 'YY/MM/DD')) buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buy_prod = prod_id AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD')) ; 

** outer join 3 ) 
SELECT NVL(buy_date, TO_DATE('2005/01/25', 'YY/MM/DD')) buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod RIGHT OUTER JOIN prod ON (buy_prod = prod_id AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD')) ; 

** outer join 4 )  
SELECT p.pid, pnm, NVL(cid, 1) cid, NVL(day, 0) day, NVL(cnt, 0) cnt
FROM cycle c RIGHT OUTER JOIN product p ON (c.pid = p.pid AND cid = 1) ;  

SELECT *
FROM cycle ;
SELECT * 
FROM product; 

** outer join 5 ) 
SELECT p.pid, pnm, NVL(m.cid, 1), cnm, NVL(day, 0), NVL(cnt, 0)
FROM cycle c OUTER JOIN product p ON (c.pid = p.pid) RIGHT OUTER JOIN customer m ON (c.cid = m.cid AND c.cid = 1 ); 



