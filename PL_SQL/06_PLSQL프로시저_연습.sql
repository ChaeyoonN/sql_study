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
CREATE PROCEDURE year_proc
    (p_id IN employees.employee_id%TYPE,
    p_year OUT employees.employee_id%TYPE
    )
IS
    v_cnt NUMBER := 0;
BEGIN
    SELECT 
        COUNT(*)
    INTO 
        v_cnt
    FROM employees
    WHERE employee_id = p_id;
    
    IF v_cnt = 0 THEN -- ��ȸ ����� �����ٸ� INSERT
        INSERT INTO jobs
        VALUES (p_job_id , p_job_title , p_min_sal , p_max_sal);
    ELSE -- ������ �����ϴ� �����Ͷ�� ��ȸ�� ����� ����.
        SELECT 
            p_job_id||'�� �ִ� ����: '||max_salary||', �ּ� ����: '||min_salary
        INTO 
            v_result -- ��ȸ ����� ������ ����
        FROM jobs
        WHERE job_id = p_job_id;
    END IF;
    
    -- OUT �Ű������� ��ȸ ����� �Ҵ�.
    p_result := v_result;
    
    COMMIT;
END;

/*
���ν����� - new_emp_proc
employees ���̺��� ���� ���̺� emps�� �����մϴ�.
employee_id, last_name, email, hire_date, job_id�� �Է¹޾�
�����ϸ� �̸�, �̸���, �Ի���, ������ update, 
���ٸ� insert�ϴ� merge���� �ۼ��ϼ���

������ �� Ÿ�� ���̺� -> emps
���ս�ų ������ -> ���ν����� ���޹��� employee_id�� dual�� select ������ ��.
���ν����� ���޹޾ƾ� �� ��: ���, last_name, email, hire_date, job_id
*/