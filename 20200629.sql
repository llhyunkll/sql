ROWNUM : SELECT 순서대로 행 번호를 부여해주는 가상 컬럼
특징 : WHERE 절에서도 사용 하는게 가능
     *** 사용할수 있는 형태가 정해져 있음
     WHERE ROWNUM = 1; // ROWNUM이 1일 때  
     WHERE ROWNUM <= N; // ROWNUM이 N보다 작거나 같은 경우, 작은 경우
     WHERE ROWNUM BETWEEN 1 AND N ; // ROWNUMDL 1보다 크거나 같고 N보다 작거나 같은 경우
      ==> ROWNUM은 1부터 순차적으로 읽는 환경에서만 사용이 가능
      
 SELECT ROWNUM, empno, ename
 FROM emp;

WHERE절에서 사용할수 있는 형태 
 SELECT ROWNUM, empno, ename
 FROM emp
 WHERE ROWNUM <= 10 ; 

SELECT ROWNUM, empno, ename
FROM emp 
WHERE ROWNUM >=10 ; (X) 
  //WHERE ROWNUM <= 10; (X)
   
***** 안되는 경우
WHERE ROWNUM = 2; 
WHERE ROWNUM => 2; 
    
ROWNUM 사용 용도 : 페이징 처리
페이징 처리 : 네이버 카페에서 게시글 리스트를 한 화면에 제한적인 갯수로 조회(100개)
            카페에 전체 게시글 수는 굉장히 많음
            ==> 한 화면에 못보여줌. (1.웹브라우저가 버벅임, 2. 사용자의 사용성이 굉장히 불편)
            ==> 한 페이지당 건수를 정해놓고 해당 건수만큼만 조회해서 화면에 보여준다.
  
ROWNUM과 ORDER BY 
SELECT SQL의 실행 순서 : FROM ==> WHERE ==> SELECT ==> ORDER BY 

SELECT ROWNUM, empno, ename
FROM emp 
ORDER BY ename ; // ROWNUM 숫자가 1부터 시작하는 것이 나오지 않음, 이름순으로 정렬되어 있음.

ROWNUM의 결과를 정렬이후에 반영하고 싶은 경우 ==> IN-LINE VIEW
VIEW : SQL - DBMS에 저장되어 있는 SQL
IN-LIVE : 직접 기술했다. 어딘가 저장을 한게 아니라 그 자리에 직접 기술 

SELECT empno, ename
FROM emp ; 

SELECT * 
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) ; 

SELECT ROWNUM, *  //SELECT절에 *만 단독으로 사용하지 않고 콤마를 통해 
다른 임의 컬럼이나 expression을 표기한 경우 * 앞에 어떤 테이블(뷰)에서 온것인지
한정자(테이블 이름 view 이름)를 붙여줘야 한다.

테이블, view 별칭 : 테이블이나 뷰에도 SELECT절의 컬럼처럼 별칭을 부여 할수 있다.
                  단 as 키워드는 사용하지 않는다.
                  ex : FROM emp 
                  FROM (SELECT empno, ename
                        FROM emp
                        ORDER BY ename) a ;

SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) ; 
      
SELECT ROWNUM, a.* 
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a ; 
      
 요구사항 : 1 페이지당 10건의 사원 리스트가 보여야된다. 
 페이지 번호, 페이지당 사이즈
 1 page : 1~10
 2 page : 11~20 
 3 page : 21~30 
 .
 .
 .
 n page : (10*n)-9 ~ n*10  
        : (n-1)*pageSizs +1 ~ n*pageSizs
        
페이징 처리 쿼리 : 1 page : 1~10 
SELECT ROWNUM, a.* 
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a  
WHERE ROWNUM BETWEEN 1 AND 10 ;       

페이징 처리 쿼리 : 2 page : 11~20 
SELECT ROWNUM, a.* 
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a  
WHERE ROWNUM BETWEEN 11 AND 20 ; // 1번부터 순차적으로 사용하는 것만 가능하기 때문에 결과 나오지 않음. 

ROWNUM의 특성으로 1번부터 읽지 않는 형태이기 때문에 정상적으로 동작하지 않는다.

ROWNUM의 값을 별칭을 통해 새로운 컬럼으로 만들고 SELECT SQL을 in-line view로
만들어 외부에서 ROWNUM에 부여한 별칭을 통해 페이징 처리를 한다.

페이징 처리 쿼리 : 2 page : 11~20 
SELECT * 
FROM (SELECT ROWNUM rn, a.* 
      FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 20 ;

SQL 바인딩 변수 : java 변수 
페이지 번호 : page
페이지 사이즈 (5, 10, 15개씩) : pageSize
SQL 바인딩 변수 표기법 ==> :변수명 ==> :page, :pageSize

바인딩 변수 적용 (:page - 1) * :pageSize +1 ~ :page * :pageSize
SELECT * 
FROM (SELECT ROWNUM rn, a.* 
      FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a)
WHERE rn BETWEEN (:page - 1) * :pageSize +1 AND :page * :pageSize;


* FUNCTION : 입력을 받아들여 특정 로직을 수행 후 결과 값을 반환하는 객체
오라클에서의 함수 구분 : 입력되는 행의 수에 따라 
1. Single row function 
  하나의 행이 입력되서 결과로 하나의 행이 나온다
2. Multi row function
  여러 개의 행이 입력되서 결과로 하나의 행이 나온다. 

dual 테이블 : 오라클의 sys 계정에 존재하는 하나의 행, 하나의 컬럼(dummuy)을 갖는 테이블
             누구나 사용할 수 있도록 권한이 개방됨

SELECT * 
FROM dual ;

dual 테이블 용도
1. 함수 실행 (테스트)
2. 시퀀스 실행
3. merge 구문
4. 테이터 복제 ***

* LENGTH 함수 테스트
SELECT LENGTH('TEST') 
FROM dual ;  

SELECT LENGTH('TEST'), emp.* 
FROM emp ;

SELECT LENGTH('TEST'), LENGTH('TEST'), emp.* 
FROM emp ; //여러번 사용도 가능 

문자열 관련 함수 : 설명은 PT 참고. 억지로 외우지는 말자

SELECT CONCAT('Hello', CONCAT(', ', 'World')) concat,
       SUBSTR ('Hello, World', 1, 5 ) substr,
       LENGTH ('Hello, World') length,
       INSTR ('Hello, World', 'o') instr,
       INSTR ('Hello, World', 'o', 6), INSTR ('Hello, World', INSTR ('Hello, World', 'o')+1) instr_1,
       LPAD ('Hello, World', 15, ' ') lpad,
       RPAD ('Hello, World', 15, ' ') rpad,
       REPLACE ('Hello, World', 'o', 'p') replace, 
       TRIM (' Hello, World ') trim,
       TRIM ( 'd' FROM 'Hello, World ') trim,
       LOWER (' Hello, World ') lower,
       UPPER ('Hello, World') upper,
       INITCAP ('hello, world') initcap 
       FROM dual ;        

함수는 WHERE절에서도 사용 가능
사원 이름이 smith인 사람
SELECT * 
FROM emp
WHERE ename = 'SMITH' ;

SELECT * 
FROM emp
WHERE ename = UPPER('smith') ; 

SELECT * 
FROM emp
WHERE LOWER(ename) = 'smith' ; // 결과는 동일하지만, emp 테이블에서 ename이 소문자로 14건 실행하고 smith를 찾음. 

위 두개의 쿼리 중에서 하지 말아야 할 형태 : 좌변을 가공하는 형태 (좌변 - 테이블 컬럼을 의미)


* 오라클 숫자 관련 함수
ROUND( 숫자, 반올림 기준자리) : 반올림 함수
TRUNC(숫자, 내림 기준자리) : 내림 함수
MOD(피제수, 제수) : 나머지 값을 구하는 함수 

SELECT ROUND(105.54, 1) round, 
       ROUND(105.55, 1) round2,
       ROUND(105.55, 0) round3,
       ROUND(105.55, -1) round4
FROM dual ; 

// 단, 두번째 인자가 음수이면 해당 자리에서 반올림

// 반올림 결과가 소수점 첫번째 자리까지 나오도록, 소수점 두번째 자리에서 반올림
SELECT TRUNC(105.54, 1) trunc, 
       TRUNC(105.55, 1) trunc2,
       TRUNC(105.55, 0) trunc3,
       TRUNC(105.55) trunc3,
       TRUNC(105.55, -1) trunc4
FROM dual ; 

sal를 1000으로 나눴을 때의 나머지 ==> mod 함수, 별도의 연산자는 없다
몫 : 
나머지 : 

SELECT ename, sal, TRUNC(sal/1000), MOD(sal, 1000) reminder
FROM emp ; 

// 몫을 구하기 위해서는 내림의 함수를 사용. 소수점을 버림. 


* 날짜 관련 함수 
SYSDATE
오라클에서 제공해주는 특수 함수 
  1. 인자가 없다. 
  2. 오라클이 설치된 서버의 현재 년, 월, 일, 시, 분, 초 정보를 반환 해주는 함수

SELECT SYSDATE 
FROM dual ; 
// 실행 할 때 마다 새로운 시간 값을 가져옴. 현재 시간을 알수 있다

SELECT * 
FROM nls_session_parameters

날짜 타입 +- 정수 : 정수를 일자 취급, 정수만큼 미래, 혹은 과거 날짜의 데이트 값을 반환
ex. 오늘 날짜에서 하루 더한 미래 날짜 값은?
SELECT SYSDATE + 1 
FROM dual ; 

ex. 현재의 날짜에서 3시간 뒤 데이트를 구하려면? 
DATE + 정수 (하루)
하루 == 24시간 
1시간 ==> 1/24 
3시간 ==> (1/24)*3 = 3/24
1분 : 1/24/60 

SELECT SYSDATE + (1/24)*3 
FROM dual ; 

현재 시간에서 30분 뒤 데이트를 구하기
SELECT SYSDATE + (1/24/60)*3 
FROM dual ; 

DATE 표현하는 방법
1. 데이트 리터럴 : NLS_SESSION_PARAMETER 설정에 따르기 때문에 
  DBMS 환경 마다 다르게 인식 될 수 있음
2.TO_DATE : 문자열을 날짜로 변경해주는 함수 

** FN1 DATE 실습 1 ] 

SELECT TO_DATE('19/12/31', 'YY/MM/DD') LASTDAY, 
       TO_DATE('19/12/31', 'YY/MM/DD')-5 LASTDAY_BEFORER5, 
       SYSDATE NOW, 
       SYSDATE - 3 NOW_BEFOER3 
FROM dual ;

문자열 ==> 데이트
    TO_DATE(날짜 문자열, 날짜 문자열의 패턴);
데이트 ==> 문자열 (보여주고 싶은 형식을 지정할 때)
    TO_CHAR(데이트 값, 표현하고 싶은 문자열 패턴) 

SYSDATE 현재 날짜를 년도4자리-월2자리-일2자리
SELECT SYSDATE, TO_CHAR(SYSDATE, 'yyyy-MM-DD'),
       TO_CHAR(SYSDATE, 'D'), TO_CHAR(SYSDATE, 'IW')
FROM dual ; 

날짜 포맷 ; PT 참고
YYYY
MM
DD
HH24
MI
SS
D, IW

SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') H1,
       TO_CHAR(hiredate +1, 'YYYY/MM/DD HH24:MI:SS') H2,
       TO_CHAR(hiredate +1/24, 'YYYY/MM/DD HH24:MI:SS') H3
FROM emp ; 

** FN2 DATE 실습 ]

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI;SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual ; 









