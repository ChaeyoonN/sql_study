-- 오라클의 한 줄 주석입니다.

/*
여러 줄 주석입니다.
호호호~
*/

-- SELECT [컬럼명(여러 개 가능)] FROM  [테이블 이름]
SELECT
    *
FROM
    employees;
-- 대소문자 가리지 않지만 키워드는 대문자로 적는 것이 관례. 
-- CTRL+F7: 문장 정리. (공백 영향X, 문장 끝에;있으면 됌.)
-- 실행은 문장단위
SELECT
    employee_id,
    first_name,
    last_name
FROM
    employees;

SELECT
    email,
    phone_number,
    hire_date
FROM
    employees;

-- 컬럼을 조회하는 위치에서 * / + - 연산이 가능합니다. 
-- 존재하지 않는 컬럼 만들어 조회 가능
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    salary + salary * 0.1 AS 성과금
FROM
    employees;
    
-- NULL 값의 확인 (숫자 0이나 공백이랑은 다른 존재입니다.)
SELECT
    department_id,
    commission_pct
FROM
    employees;

-- alias (컬럼명, 테이블명의 이름을 변경해서 조회합니다.)
SELECT
    first_name AS 이름,
    last_name AS 성,
    salary AS 급여
FROM
    employees;
    
/*
 오라클은 홑따옴표로 문자를 표현하고, 문자열 안에 홑따옴표를
 표현하고 싶다면 ''를 두 번 연속으로 쓰시면 됩니다.
 문장을 연결하고 싶다면 ||를 사용합니다.
*/

SELECT 
    first_name || ' ' || last_name || '''s salary is $' || salary
    AS 급여내역
FROM employees;

-- DISTINCT (중복 행의 제거)
SELECT department_id FROM employees;
SELECT DISTINCT department_id FROM employees ;

-- ROWNUM, ROWID
-- (**로우넘: 쿼리에 의해 반환되는 행 번호를 출력)
-- (로우아이디: 데이터베이스 내의 행의 주소를 반환)
SELECT ROWNUM, ROWID, employee_id
FROM employees;