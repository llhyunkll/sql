** join 0-2 )
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
   AND sal > 2500 ; 

** join 0-3 )
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
   AND sal > 2500 
   AND empno > 7600 ; 

** join 04 )
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
   AND sal > 2500 
   AND empno > 7600 
   AND dname = 'RESEARCH' ;
   
** join 1 ) 220p
ANSI-SQL 두 테이블의 연결 컬럼명이 다르기 때문에
NATURAL JOIN, JOIN with USING은 사용 x

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod 
WHERE prod.prod_lgu = lprod.lprod_gu ;
    //한번에 조회되는 수가 50개 PgDn 눌러주면 나머지 데이터가 더 나옴

FROM prod JOIN lprod ON (prod_lgu = lprod_gu)

** join 2 ) 
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer -- 테이블의 기술 순서는 중요하지 않음, 바껴도 상관없다.
WHERE prod.prod_buyer = buyer.buyer_id ; 

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON (prod_buyer = buyer_id);

** join 3 ) 
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member AND cart.cart_prod = prod.prod_id ;

ANSI-SQL
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON ( member.mem_id = cart.cart_member )
            JOIN prod ON ( cart.cart_prod = prod.prod_id) ; 

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN (cart JOIN prod ON (cart_prod = prod_id)) ON(mem_id = cart_member) ;
-----내가 한 것!

** join 4 ~ 7             
CUSTOMER : 고객
PRODUCT : 제품
CYCLE(주기) : 고객 제품 애음 주기 

SELECT *
FROM customer ;

** 4
SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
 AND (cnm = 'brown' OR cnm = 'sally');

SELECT cid, cnm, pid, day, cnt 
FROM customer NATURAL JOIN cycle
WHERE cnm = 'brown' OR cnm = 'sally'; 

** 5
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid 
    AND cycle.pid = product.pid 
    AND cnm IN('brown', 'sally') ; 
    
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid) 
 JOIN product ON (cycle.pid = product.pid)
WHERE cnm IN('brown', 'sally') ; 
  
** 6 
SELECT customer.cid, cnm, cycle.pid, pnm, SUM(cnt)
FROM customer, cycle, product
WHERE customer.cid = cycle.cid 
    AND cycle.pid = product.pid 
GROUP BY customer.cid, cnm, cycle.pid, pnm ;
***** 보충 
cycle 15 데이터를 

** 7
SELECT cycle.pid, pnm, SUM(cnt)
FROM cycle, product 
WHERE cycle.pid = product.pid 
GROUP BY cycle.pid, pnm ; 

** 조인 성공 여부로 데이터 조회를 결정하는 구분 방법
INNER JOIN : 조인에 성공하느 데이터만 조회하는 조인 방법
OUTER JOIN : 조인에 실패하더라고, 개발자가 지정한 기준이 되는 테이블의 데이터는 나오도록 하는 조인

OUTER <==> INNER JOIN

복습 - 사원의 관리자 이름을 알고 싶은 상황
조회 컬럼 : 사원의 사번, 사원의 이름, 사원의 관리자의 사번 사원의 관리자의 이름

동일한 테이블끼리 조인 되었기 때문에 SELF JOIN
SELECT e.empno, e.ename, e.mgr, m.ename  
FROM emp e, emp m; 
WHERE e.mgr = m.empno ; 

KING의 경우 PRESIDENT이기 때문에 mgr 컬럼의 값이 null --> 조인에 실패
킹의 데이터는 조회되지 않음 총 14건의 데이터중 13건의 데이터만 조인 성공
outer 조인을 이용하여 조인 테이블 중 기준이 되는 테이블을 선택하면 
조인에 실패하더라도 기준 테이블의 데이터는 조회되도록 할수 있다
LEFT/ RIGHT OUTET

ANSI-SQL 
테이블1 JOIN 테이블2 ON (....)
테이블1 LEFT OUTER JOIN 테이블2 ON (....)
위 쿼리는 아래와 동일 RIGHT OUTER JOIN 

SELECT e.empno, e.ename, m.empno, m.ename  
FROM emp e LEFT OUTER emp n ON ( 
WHERE e.mgr = m.empno ; 

** join 8 )
SELECT region_id, regions.region_name, countries.country_name
FROM countries NATURAL JOIN regions ; 



























