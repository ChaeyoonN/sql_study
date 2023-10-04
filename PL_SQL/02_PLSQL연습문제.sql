
-- 1. employees ���̺��� 201�� ����� �̸��� �̸��� �ּҸ� ����ϴ�
-- �͸����� ����� ����. (������ ��Ƽ� ����ϼ���.)
DECLARE
    name employees.first_name%TYPE;
    email employees.email%TYPE;
BEGIN
    SELECT
        first_name,
        email
    INTO
        name, email
    FROM employees
    WHERE employee_id = 201;
    
    DBMS_OUTPUT.put_line(name||':'||email);
END;
-- 2. employees ���̺��� �����ȣ�� ���� ū ����� ã�Ƴ� �� (MAX �Լ� ���)
-- �� ��ȣ + 1������ �Ʒ��� ����� emps ���̺�
-- employee_id, last_name, email, hire_date, job_id�� �ű� �����ϴ� �͸� ����� ���弼��.
-- SELECT�� ���Ŀ� INSERT�� ����� �����մϴ�.
/*
<�����>: steven
<�̸���>: stevenjobs
<�Ի�����>: ���ó�¥
<JOB_ID>: CEO
*/
DECLARE
    n employees.employee_id%TYPE;
BEGIN
    SELECT
       MAX(employee_id)
    INTO 
        n
    FROM employees;
    
    INSERT INTO emps
        (employee_id, last_name, email, hire_date, job_id)
    VALUES(n+1, 'steven', 'stevenjobs', sysdate, 'CEO');
END;

SELECT * FROM emps;