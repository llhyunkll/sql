


SELECT 실습
FROM 테이블명

SELECT * | { columnl, columnl2 ... 
FROM 테이블명;

SELECT *
FROM prod ;

SELECT prod_id, prod_name
FROM prod;

expression : 컬럼값을 가공을 하거나, 존재하지 않는 새로운 상수값(정해진 값)을 표현
            연산을 통해 새로운 컬럼을 조회할 수 있다. 
            연산을 하더라도 해당 SQL 조회 결과에만 나올 뿐이고 실제 테이블의 데이터에는 
            영향을 주지 않는다.
            SELECT 구문은 테이블의 데이터에 영향을 주지 않음;
            
SELECT *
FROM emp ;

SELECT * 
FROM dept ; 

SELECT sal, sal + 500, sal -500, sal/5, sal*5, 500
FROM emp ; 

날짜에 대한 사칙연산 : 수학적으로 정의가 되어 있지 않음
SQL에서는 날짜 데이터 + - 정수 ==> 정수를 일수 취급

'2020년 6월 25일' + 5 " 2020년 6월 25일 부터 5일 이후 날짜
'2020년 6월 25일' - 5 " 2020년 6월 25일 부터 5일 이전 날짜

데이터 베이스에서 주로 사용하는 데이터 타입 : 문자, 숫자, 날짜

empno : 숫자 
ename : 문자
hiredate : 날짜 

테이블의 컬럼구정 정보 확인
DESC 테이블명 (DESCRIBE 테이블명)

DESC emp ; 

SELECT hiredate, hiredate + 5, hiredate -5
FROM emp ;

* users 테이블의 컬럼타입을 확인하고 
  reg_dt 컬럼 값에 5일 뒤 날짜를 새로운컬럼으로 표현
  조회 컬럼 : userid, reg_dt, reg_dt의 5일 뒤 날짜

DESC users ;

SELECT userid, reg_dt, reg_dt + 5
FROM users ; 


