--���� �޿���?
select sal from emp where ename = 'JONES';


--���� �޿����� ���� �޴� ���
--2975   ���� ���� �޴� ���
select *
from emp
where sal>2975;

select * 
from emp
where sal>(select sal from emp where ename='JONES');

--���μ� �޿���, ����
select sum(sal) from emp where deptno = 10;

select sum(sal) from emp where deptno = 20;

select sum(sal) from emp where deptno = 30;

select sum(sal) from emp;

--10���μ��޿���, 20���μ��޿���, 30���μ��޿���, �ѱ޿����� ����Ͻÿ�
select 
 (select sum(sal) as ssal from emp where deptno=10) as �μ�10,
 (select sum(sal) as ssal from emp where deptno=20) as �μ�20,
 (select sum(sal) as ssal from emp where deptno=30) as �μ�30,
 (select sum(sal) as ssal from emp) as �޿�����
from dual;

--from ���� ���� subquery ==Inline View
select ssal
from (select sum(sal) as ssal from emp where deptno=10);


-- 7566����� �޿����� �޿��� ���� �޴� ��� ���� ���
select *
from emp
where sal > (select sal from emp where empno=7566);

select * from emp;

select sal from emp where deptno=10;
update emp set hiredate = '1987/07/13'
where ename = 'SCOTT' and sal=3000;
commit;

update emp set hiredate = '1987/07/13'
where ename = 'ADAMS';
rollback;

select empno, ename, deptno, hiredate
from emp
where (deptno, hiredate) 
IN (select deptno, min(hiredate) from emp group by deptno)
;

--EMP ���̺��� �μ� �ο��� 4���� ���� �μ��� �μ���ȣ, �ο���
--, �޿��� ���� ����Ͻÿ�.
select deptno, count(*), sum(sal)
from emp
group by deptno
having count(*)>4;


--EMP ���̺��� ���� ���� ����� �����ִ� �μ���ȣ�� ������� ����Ͻÿ�.
select deptno, count(deptno) cnt
from emp
group by deptno
having count(deptno) = 
(select max(count(deptno)) from emp group by deptno);

select max(count(*)) 
from emp
group by mgr;

--EMP ���̺��� ���� ���� ����� ���� MGR�� �����ȣ�� ����Ͻÿ�.
select mgr as empno
from emp
group by mgr
having count(*)=(
select max(count(*)) 
from emp
group by mgr);

select * from emp;


select empno, ename, hiredate, trunc((sysdate-hiredate)/365) as �ٹ����
from emp
where (sysdate-hiredate)/365>30;

--=============================
--subquery
select 
    (select count(1) as cnt from emp where deptno=10) as CNT10,
    (select count(1) as cnt from emp where deptno=30) as CNT30
from dual;


--decode
select
    sum(decode(deptno, 10, 1,0 )) as CNT10,
    sum(decode(deptno, 30,1,0 )) as CNT30
from emp;

--EMP ���̺��� �����ȣ(EMPNO)�� 7521�� ����� ����(JOB)�� ����
--�����ȣ(EMPNO)�� 7934�� ����� �޿�(SAL)���� ���� �����
--�����ȣ, �̸�, ����, �޿��� ����Ͻÿ�.
select empno, ename, job, sal
from emp
where job = (select job
from emp
where empno=7521) and sal>(select sal
from emp
where empno=7934)
;

--�������� �ּ� �޿��� �޴� ����� ������ �����ȣ, �̸�, ����, �μ�����
--����Ͻÿ�.
--����1: �������� �������� ����
select e.empno, e.ename, e.job, d.dname
from emp e, dept d
where e.deptno = d.deptno and (e.job, sal) 
in (select job, min(sal) from emp group by job)
order by e.job desc;--�̹� �ȿ��� group �������־


-- �� �μ��� ������� ����Ͻÿ�.
--����1. �μ��� ������� ������ �μ���ȣ, �μ��� ���
--����2. �μ��� ������� 0�� ��� '����' ���
--����3. �μ���ȣ �������� ����
select d.deptno, d.dname, 
    decode(count(empno), to_char(0), '����', count(empno)) as �����
from emp e, dept d
where e.deptno(+) = d.deptno
group by d.deptno, d.dname
order by d.deptno asc;

select * from emp;

-- ��� ���̺��� �� ����� �����ȣ, �����, �Ŵ�����ȣ, �Ŵ�������
-- ����Ͻÿ�.
--����1. �� ����� �޿�(SAL)�� �Ŵ��� �޿����� ���ų� ����.
select e.empno, e.ename, e.mgr, cp.ename
from emp e, emp cp
where e.mgr = cp.empno and e.sal>=cp.sal;


--17. 'Jones'�� �����ִ� �μ��� ������� �����ȣ, �̸�, �Ի���, �޿��� ����϶�
select empno, ename, hiredate, sal
from emp
where deptno = (select deptno
from emp
where ename='JONES');

--1. DALLAS���� �ٹ��ϴ� ����� �̸�, ����, �μ���ȣ, �μ��̸��� ����϶�.
select e.ename, e.job, d.deptno, d.dname
from emp e, dept d
where d.loc = 'DALLAS';

--3. ������ 'SALESMAN'�� ������� ������ �� ����̸�, �μ� �̸��� ����϶�.
select e.job, e.ename, d.dname
from emp e, dept d
where e.deptno=d.deptno and e.job = 'SALESMAN';

--13. �̸��� 'ALLEN'�� ����� �μ����� ����϶�.
select d.dname
from emp e, dept d
where e.deptno=d.deptno and e.ename = 'ALLEN';

--�����ȣ�� 7499�� ����� ����, �μ���ȣ�� ��ġ�ϴ� ����� ������ ����϶�.
select * from emp
where (job, deptno)=(select job, deptno from emp where empno=7499);

--10�� �μ��� ������ ���� ������ �޴� ������� �̸�, ����, �μ���ȣ�� ����϶�.
select ename, sal, deptno
from emp
where sal in (select sal from emp where deptno = 10);

--7. BLACK�� ���� �μ��� �ִ� ������� �̸��� ������� ����ϵ� 'BLAKE'�ڽ��� ���� ���
select ename, hiredate
from emp
where deptno = (select deptno from emp where ename='BLAKE') and ename not in (select ename from emp where ename = 'BLAKE');

--8. Ŀ�̼��� �޴� ����� �μ���ȣ, ������ ���� ����� �̸�, ����, �μ���ȣ�� ����϶�.
select ename, sal, deptno
from emp
where (deptno, sal) in (select deptno, sal from emp where nvl(comm,0)!=0);

--9. MGR�� 'KING'�� ��� ����� �̸��� �޿��� ����϶�.
select e.ename, e.sal
from emp e, emp cp
where e.mgr = cp.empno and cp.ename = 'KING';

--10. 30�� �μ� ������ ���ް� Ŀ�̼��� ���� ���� �������
--�̸�, ����, Ŀ�̼��� ����϶�
select ename, sal, comm
from emp
where (sal, comm) not in (select sal, comm from emp where deptno=30);

select * from dept;
--18. 10�� �μ��� ����� �߿��� 20�� �μ��� ����� ���� ������ �ϴ� �����
--�����ȣ, �̸�, �μ���, �Ի���, ������ ����϶�.
select e.empno, e.ename, d.dname, e.hiredate, d.loc
from emp e, dept d
where e.deptno=10 and e.job in (select job from emp where deptno=20);

--20. 10�� �μ� �߿��� 30�� �μ����ʴ� ���� �ӹ��� �ϴ� ����� �����ȣ, �̸�, �μ���, �Ի���,
--������ ����϶�.
select e.empno, e.ename, d.dname, e.hiredate, d.loc
from emp e, dept d
where e.deptno=10 and e.job not in (select job from emp where deptno=30);

--22. 'MARTIN'�̳� 'SCOTT'�� �޿��� ���� ����� �����ȣ, �̸�, �޿��� ����϶�.
select empno, ename, sal
from emp
where sal in (select sal from emp where ename='MARTIN' or ename = 'SCOTT');

--24.
select deptno, ename, round(sal/20/8,1)
from emp
order by deptno asc, sal desc;

