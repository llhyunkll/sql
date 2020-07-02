


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

데이터 베이스에서 주로 사용하는 데이터 타입 : 문자, 숫자, 날짜 / var, num, date 

empno : 숫자 
ename : 문자
hiredate : 날짜 

테이블의 컬럼구성 정보 확인
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

NULL : 아직 모르는 값, 할당되지 않은 값
NULL과 숫자 타입 0은 다르다. 
NULL과 문자 타입의 공백은 다르다. 

NULL의 중요한 특징
NULL을 피연산자로 하는 연산의 결과는 항상 NULL
EX: NULL + 500 = NULL

 * emp 테이블에서 sal 컬럼과 comm 컬럽의 합을 새로운 컬럼으로 표현  
   조회 컬럼은 : empno, ename, sal, comm, sal + comm
   
   ALIAS : 컬럼이나 EXPRESSION에 새로운 이름을 부여 
   적용 방법 : 컬럼, EXPRESSION [AS] 별칭명 
              별칭을 소문자로 표현하고 싶은 경우나 공백을 넣고 싶은 경우 " "를 사용.
   

SELECT empno, ename, sal s , comm AS "commition", sal + comm AS sal_plus_comm
FROM emp ; 


** select 실습2 

SELECT  prod_id AS "id" , prod_name AS "name"
FROM prod ; 

SELECT lprod_gu gu, lprod_nm nm
FROM  lprod ; 

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer ; 


literal : 값 자체 
literal 표기법 : 값을 표현하는 방법
 ex : test 라는 문자열을 표기하는 방법
 java : System.out.println("test")
 SQL : 'test' 

번외
int small = 10;
java 대입 연산자 :  = 
pl/sql 대입 연산자 : :=
언어마다 연산자 표기, literal 표기법이 다르기 때문에 해당 언어에서 지정하는 방식을 잘 따라야 한다. 

문자열 연산 : 결합
일상생활에서 문자열 결합 연산자가 존재? 
java에서 문자열 결합 연산자 : + 
sql에서 문자열 결합 연산자 : ||
sql에서 문자열 결합 함수 : CONCAT (문자열1, 문자열2) ==> 문자열1||문자열2
                        두 개의 문자열을 인자로 받아서 결합 결과를 리턴 

users 테이블의 userid 컬럼과 usernm 컬럼을 결합

SELECT userid, usernm, userid || usernm id_name, CONCAT(userid, usernm) concat_id_name
FROM users ; 

임의의 문자열을 결합 ( sal+500, '아이디 : ' || userid)

SELECT '아이디 : ' || userid, 500, 'test'
FROM users; 



SELECT  TABLE_NAME
FROM user_tables;

SELECT  'SELECT * FROM ' || TABLE_NAME || ';' AS QUERY 
FROM user_tables;

** sel + con1 ] 
CONCAT 함수만 이용해서 

SELECT CONCAT ( CONCAT ('SELECT * FROM ' , TABLE_NAME), ';' ) QUERY
FROM user_tables;


WHERE : 테이블에서 조회할 행의 조건을 기술
        where절에 기술한 조건이 참일 때 해당 행을 조회한다. 
        SQL에서 가장 어려운 부분, 많은 응용이 발생하는 부분
        
SELECT *
FROM users
WHERE userid = 'brown'; 

 emp 테이블에서 deptno 컬럼의 값이 30 보다 크거나 같은 행을 조회, 컬럼은 모든 컬럼
 
SELECT *
FROM emp
WHERE deptno >= 30 ;

emp 총 행수 : 14 
SELECT *
FROM emp
WHERE 1 = 2 ; // 조건이 참이 아닐 경우 결과가 나오지 않음

DATE 타입에 대한 WHERE절 조건 기술
emp 테이블에서 hiredate 값이 1982년1월1일 이후인 사원들만 조회 

SQL 에서 DATE 리터럴 표기법 : 'RR/MM/DD'
단, 서버 설정마다 표기법이 다르다. 
한국 : YY/MM/DD
미국 : MM/DD/YY

'12/11/01' ==> 국가별로 다르게 해석이 가능하기 때문에 DATE 리터럴 보다는
문자열 DATE 타입으로 변경해주는 함수를 주로 사용
TO_DATE('날짜문자열', '첫번째 인자의 형식')

SELECT *
FROM emp
WHERE hiredate >= '82/01/01'

TO_DATE를 통해 문자열을 DATE 타입으로 변경 후 실행

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD'); 

SELECT * 
FROM NLS_SESS


BETWEEN AND : 두 값 사이에 위치한 값을 참으로 인식
사용 방법 : 비교값 BETWEEN 시작값 AND 종료값
비교값이 시작값과 종료값을 포함하여 사이에 있으면 참으로 인식

emp 테이블에서 sal 값이 1000 보다 크거나 같고 2000 보다 작거다 같은 사원들만 조회

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000 ;

sal BETWEEN 1000 AND 2000 조건을 부등호로 나타내면(>=, <=, >, <)?  
sal >= 1000 이면서 sal <= 2000

SELECT *
FROM emp
WHERE sal >= 1000 
  AND sal <= 2000 ;

** where1 ] 

SELECT ename, hiredate
FROM emp 
WHERE hiredate BETWEEN '82/01/01' AND '83/01/01'; 

WHERE hiredate BETWEEN TO_DATE('19820101', YYYYMMDD) AND TO_DATE('19830101', YYYYMMDD) ; 

SELECT ename, hiredate
FROM emp 
WHERE hiredate >= '82/01/01' 
AND hiredate <= '83/01/01'

WHERE hiredate >= TO_DATE('19820101', YYYYMMDD) 
  AND hiredate <= TO_DATE('19830101', YYYYMMDD) ; 


IN 연산자 : 비교값이 나열된 값에 포함될 때 참으로 인식
사용 방법 : 비교값 IN  (비교대상 값1, 비교대상 값2, 비교대상 값3)

사원의 소속 부서가 10번 혹은 20번인 사원을 조회하는 SQL을 IN 연산자로 작성

SELECT *
FROM emp
WHERE deptno IN (10, 20) ; 

WHERE deptno = 10
   OR deptno = 20 ; 

WHERE절에서 사용가능한 연산자 : LIKE 
사용용도 : 문자의 일부분으로 검색을 하고 싶을 때 사용
          ex ename 컬럼의 값이 s로 시작하는 사원들을 조회 
사용방법 : 컬럼 LIKE '패턴문자열'
마스킹 문자열 : 1. %  : 문자가 없거나, 어떤 문자든 여러개의 문자열
                      'S%' : S로 시작하는 모든 문자열, S, SS, SMITH
              2. _ : 어떤 문자든 딱 하나의 문자를 의미
                    'S_' : S로 시작하고 두번째 문자가 어떤 문자든 하나의 문자가 오는 2자리 문자열
                    'S____' : S로 시작하고 문자열의 길이가 5글자인 문자열


emp테이블에서 ename 컬럼의 값이 s로 시작하는 사원들만 조회

SELECT *
FROM emp 
WHERE ename LIKE 'S%' ; 


** WHERE 실습4 ) LIKE, %, _  
SELECT mem_id, mem_name
FROM member 
WHERE mem_name LIKE '신%' ; //신씨 면서 이름이 외자거나 이름이 4글자일수도 있으니까 

** WHERE 실습5 ] 

UPDATE member set mem_name= '쁜이'
WHERE mem_id = 'b001' ; 

SELECT mem_id, mem_name
FROM member 
WHERE mem_name LIKE '%이%'


UPDATE member set mem_name= '신이환'
WHERE mem_id = 'c001' ; 


NULL 비교 : 연산자로 비교 불가 ==> IS 
NULL을 = 비교하여 조회 

comm 컬럼의 값이 null인 사원들만 조회
SELECT empno, ename, comm
FROM emp
WHERE comm = NULL ; (X)

** WHERE절 실습 6 ] 
emp 테이블에서 comm 값이 NULL이 '아닌' 데이터를 조회
AND, OR, NOT 

NULL값에 대한 비교는 = 이 아니라 IS 연산자를 사용한다. 
SELECT empno, ename, comm
FROM emp
WHERE comm IS NOT NULL ; 

논리연산자 : AND, OR, NOT 
AND : 참 거짓 판단식1 AND 참 거짓 판단식2 ==> 식 두개를 동시에 만족하는 행만 참
      일반적으로 AND 조건이 많이 붙으면 조회되는 행의 수가 줄어든다.
      
OR :  참 거짓 판단식1 OR 참 거짓 판단식2 ==> 식 두개 중에 하나라도 만족하면 참

NOT : 조건을 반대로 해석하는 부정형 연산 
      NOT IN 
      IS NOT NULL 

emp 테이블에서 mgr 컬럼의 값이 7698 이고 sal 컬럼의 값이 1000보다 큰 사원 조회 
SELECT * 
FROM emp 
WHERE mgr = 7698
  AND sal > 1000 ; 
  
mgr 값이 7698 이거나 (5명) 
sal 값이 1000보다 크거나(12명) , 두개의 조건을 하나라도 만족하는 행을 조회 // 최대 14명 최소 12명 
SELECT * 
FROM emp 
WHERE mgr = 7698
   OR sal > 1000 ; 

emp 테이블에서 mgr가 7698(5명), 7839(3명)가 아닌 사원들을 조회
SELECT * 
FROM emp 
WHERE mgr NOT IN  (7698, 7839) ; // 결과값이 5명

      !(mgr = 7698 OR mgr = 7839) ==> (mgr != 7698 AND mgr != 7839) 
**** mgr 컬럼에 NULL값이 있을 경우 비교 연산으로 NULL 비교가 불가하기 때문에 NULL을 갖는 행은 무시 된다. 

SELECT * 
FROM emp 
WHERE mgr != 7698 AND mgr != 7839 ;


mgr 사번이 7698이 아니고, 7839가 아니고 NULL이 아닌 직원들을 조회
SELECT * 
FROM emp 
WHERE mgr NOT IN  (7698, 7839, NULL) ; (X) 

mgr가 (7698, 7839, NULL) 포함된다. 
mgr IN  (7698, 7839, NULL) ==> mgr =7698 OR mgr = OR 7839 mgr = NULL (X)
mgr NOR IN  (7698, 7839, NULL) ==> mgr !=7698 AND mgr != 7839 AND mgr != NULL ; (X)

SELECT * 
FROM emp 
WHERE mgr NOT IN  (7698, 7839)
  AND mgr IS NOT NULL ;


**WHERE 실습7 ]
SELECT * 
FROM emp 
WHERE job = 'SALESMAN'   
 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') ; 

SELECT * 
FROM emp 
WHERE job = 'SALESMAN'   
 AND hiredate >= '81/06/01' ; 
 
// 데이터의 내용은 대소문자를 구분, ' ' 사용. 오탈자 확인 

**WHERE 실습 8 ] 
SELECT * 
FROM emp 
WHERE deptno != 10 
 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') ; 
 
 **WHERE 실습 9 ] 
SELECT * 
FROM emp 
WHERE deptno NOT IN 10 
 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') ; 
  
**WHERE 실습 10 ] 
SELECT * 
FROM emp 
WHERE deptno IN (20, 30) 
 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') ; 
 
 **WHERE 실습 11 ] 
SELECT * 
FROM emp 
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') ; 

 **WHERE 실습 12 ] 
 emp 테이블에서 job이 SALESMAN이거나 사원번호(empno)가 78로 시작하는 직원의 정보 조회
LIKE  ' % ' 
SELECT * 
FROM emp 
WHERE job = 'SALESMAN'
   OR empno LIKE '78__' ; // 형변환 : 명시적 / 묵시적(여기에 해당)

empno : 7800 ~ 7899 

**WHERE 실습 13] empno : 7800 ~ 7899, 78, 78% 

SELECT * 
FROM emp 
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899
   OR empno = 78 
   OR empno BETWEEN 780 AND 789 ; 
   
연산자 우선순위 
+, -, *, / 
*, / > +, - 
AND > OR 

**WHERE 실습 14]
SELECT * 
FROM emp 
WHERE job = 'SALESMAN' 
   OR empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD') ; 

sql 작성순서 / 오라클에서 실행하는 순서
1. /    SELECT    / 3.
2. /     FROM     / 1.
3. /    WHERE    / 2.
4. /   ORDER BY   / 4

정렬
RDBMS 집합적인 사상을 따른다
집합에는 순서가 없다 {1, 3, 5} == {3, 5, 1}
집합에는 중복이 없다 {1, 3, 5, 1} == {3, 5, 1}

정렬 방법 : ORDER BY 절을 통해 정렬 기준 컬럼을 명시
          컬럼 뒤에 [ASC | DESC ]을 기술해서 오름차순, 내림차순을 지정할수 있다.
          
1. ORDER BY 컬럼
2. ORDER BY 별칭 
3. ORDER BY SELECT 절에서 나열된 컬럼의 인덱스 번호


SELECT *
FROM emp 
ORDER BY ename ; // 오름차순이 기본 설정. 생략해도 됨 

SELECT *
FROM emp 
ORDER BY ename desc ; //내림차순 

동명이인 일 경우 누구를 위로 정렬할 것인가 
ORDER BY ename desc , mgr ; 

별칭으로 ORDER BY
SELECT empno, ename, sal, sal*12 salary
FROM emp
ORDER BY salary ; 

SELECT 절에 기술된 컬럼 순서 (인덱스)로 정렬
SELECT empno, ename, sal, sal*12 salary
FROM emp
ORDER BY 4 ; 

** ORDER BY 실습 1 ] 
SELECT *
FROM dept 
ORDER BY dname asc ; 

SELECT *
FROM dept 
ORDER BY loc desc ; 

** ORDER BY 실습 2 ] 상여가 있는 사람만 조회, 단 상여가 0이면 상여가 없는 것으로 간주 

SELECT * 
FROM emp 
WHERE comm > 0 
ORDER BY comm desc, empno desc ; 


