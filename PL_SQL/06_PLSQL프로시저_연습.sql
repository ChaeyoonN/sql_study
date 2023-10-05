/*
���ν����� divisor_proc
���� �ϳ��� ���޹޾� �ش� ���� ����� ������ ����ϴ� ���ν����� �����մϴ�.
*/
CREATE OR REPLACE PROCEDURE divisor_proc
    (p_num IN NUMBER)
IS
    v_count NUMBER:= 0;
BEGIN
    FOR i IN 1..p_num
    LOOP
        IF  MOD(p_num,i)=0 THEN 
            v_count := v_count +1;
        END IF;
    END LOOP;
    dbms_output.put_line(p_num||'�� ����� '||v_count||'��');
END;

EXEC divisor_proc(72);


/*
�μ���ȣ, �μ���, �۾� flag(I: insert, U:update, D:delete)�� �Ű������� �޾� 
depts ���̺� 
���� INSERT, UPDATE, DELETE �ϴ� depts_proc �� �̸��� ���ν����� ������.
�׸��� ���������� commit, ���ܶ�� �ѹ� ó���ϵ��� ó���ϼ���.
*/
CREATE OR REPLACE PROCEDURE depts_proc
    (p_id IN depts.department_id%TYPE,
    p_name IN depts.department_name%TYPE,
    p_flag IN VARCHAR2
    )
IS
    v_cnt NUMBER := 0; --id ���翩�� üũ ���� ����
BEGIN
    SELECT 
        COUNT(*)
    INTO v_cnt
    FROM depts
    WHERE department_id = p_id;
    
    
    IF p_flag = 'I' THEN
        INSERT INTO depts
        (department_id, department_name)
        VALUES(p_id, p_name);
    ELSIF p_flag = 'U' THEN
        UPDATE depts
        SET department_name = p_name
        WHERE department_id = p_id;
    ELSIF p_flag = 'D' THEN
        IF v_cnt = 0 THEN
            dbms_output.put_line('�����ϰ��� �ϴ� �μ��� �������� �ʽ��ϴ�.');
            RETURN;
        END IF;

        DELETE FROM depts
        WHERE department_id = p_id;
    ELSE
         dbms_output.put_line('�ش� flag�� ���� ������ �غ���� �ʾҽ��ϴ�.');
    END IF;
    
    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('���ܰ� �߻��߽��ϴ�.');
        dbms_output.put_line('ERROR MSG: '||SQLERRM);
        ROLLBACK;
END;

EXEC depts_proc(700, '������', 'O');
SELECT*FROM DEPTS;
/*
employee_id�� �Է¹޾� employees�� �����ϸ�,
�ټӳ���� out�ϴ� ���ν����� �ۼ��ϼ���. (�͸��Ͽ��� ���ν����� ����)
���ٸ� exceptionó���ϼ���
*/
CREATE OR REPLACE PROCEDURE year_proc
    (p_id IN employees.employee_id%TYPE,
    p_year OUT NUMBER,
    v_cnt OUT NUMBER 
    )
IS
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT 
        COUNT(*)
    INTO 
        v_cnt
    FROM employees
    WHERE employee_id = p_id;
    
    SELECT 
        hire_date
    INTO 
        v_hire_date
    FROM employees
    WHERE employee_id = p_id;
    
    
    
    -- ������ �����ϴ� �����Ͷ�� ��ȸ�� ����� ����.
    p_year := TRUNC((sysdate-v_hire_date) / 365);
        
    
    EXCEPTION WHEN OTHERS THEN
--        dbms_output.put_line(v_cnt); -- 0 ���
        IF v_cnt = 0 THEN -- ��ȸ ����� �����ٸ� 
        dbms_output.put_line(p_id||'��(��) �������� �ʴ� employee_id!');
        END IF; 
        dbms_output.put_line('SQL ERROR CODE: '||SQLCODE);
        dbms_output.put_line('SQL ERROR MSG: '||SQLERRM);
END;

DECLARE
    v_year NUMBER;
    v_cnt NUMBER;
BEGIN
    year_proc(1000, v_year, v_cnt); --17�� 176��//205 21�� //100 20��
    IF v_cnt <> 0 THEN
        dbms_output.put_line(v_year||'��');
    END IF;
    
END;

/*
���ν����� - new_emp_proc
employees ���̺��� ���� ���̺� emps�� �����մϴ�.
employee_id, last_name, email, hire_date, job_id�� �Է¹޾�
�����ϸ� �̸�, �̸���, �Ի���, ������ update, 
���ٸ� insert�ϴ� merge���� �ۼ��ϼ���

������ �� Ÿ�� ���̺� -> emps (not null���� �� ���������� ����ȉ�!!!!!!)
���ս�ų ������ -> ���ν����� ���޹��� employee_id�� dual�� select ������ ��.
���ν����� ���޹޾ƾ� �� ��: ���, last_name, email, hire_date, job_id
*/
CREATE OR REPLACE PROCEDURE new_emp_proc
    (p_id IN emps.employee_id%TYPE,
    p_last_name IN emps.last_name%TYPE,
    p_email IN emps.email%TYPE,
    p_hire_date IN emps.hire_date%TYPE,
    p_job_id IN emps.job_id%TYPE
    )
IS
    
BEGIN
    MERGE INTO emps a -- ������ �� Ÿ�� ���̺�
    USING
        (SELECT p_id AS employee_id FROM dual) b
    ON
        (a.employee_id = b.employee_id) -- ���޹��� ����� emps�� �����ϴ����� ������������ ���.
    WHEN MATCHED THEN
        UPDATE SET 
            a.last_name = p_last_name,
            a.email = p_email,
            a.hire_date = p_hire_date, 
            a.job_id = p_job_id
    WHEN NOT MATCHED THEN
        INSERT (a.employee_id, a.last_name, a.email, a.hire_date, a.job_id)
        VALUES (p_id, p_last_name, p_email, p_hire_date, p_job_id);
END;

SELECT * FROM emps;

EXEC new_emp_proc(300, 'park', 'park4321', sysdate, 'test');
EXEC new_emp_proc(100, 'kim', 'kim1234', '2023-04-24', 'test2');