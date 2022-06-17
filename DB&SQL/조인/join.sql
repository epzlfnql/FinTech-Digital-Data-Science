select * from emp;

--1981�� 2�� 20�Ϻ��� 1981�� 5�� 1�� ���̿� �Ի��� ����� �̸�, ������
-- �Ի����� ����Ͻÿ�.
select ename, job, hiredate
from emp
where hiredate between to_date('1981/02/20', 'yyyy-mm-dd') 
and to_date('1981/05/01', 'yyyy-mm-dd')
;

select * from emp;
select sum(sal)
from emp
group by job;

--(nvl(sal,0)*12 + nvl(comm,0) < 30000 and deptno=10 and job!='CLERK'

-- �̸��� A�� E�� ��� �����ϰ� �ִ� ����� �̸��� ����Ͻÿ�.
select ename 
from emp
where ename like '%A%' and ename like '%E%';


--���޿� ���� �λ�� �޿��� ����Ͻÿ�.
--'salesman'�� ����� 180, 'manager'�� ����� 150, 'clerk'�� ����� 100�� �λ�.
--decode �Լ��� ����Ѵ�.
select sal, decode(job,
                    'SALESMAN', sal+180,
                    'MANAGER', sal+150,
                    'CLERK', sal+100,
                    sal) as upsal
                    from emp;
             
             
--�������� �ִ�޿�, �ּұ޿�, ��ձ޿��� ����Ͻÿ�.
--��տ� ���ؼ��� ������ �ݿø� �Ͻÿ�.
select job, max(sal), min(sal), round(avg(sal),0) as asal
from emp
group by job
order by asal;


--�� �μ��� �޿��հ� �޿� ������ ������ ���� ����Ͻÿ�.
select deptno, sum(sal) as ssal
from emp
group by deptno;

select ename, sal, job
from emp;

select 
    sum(decode(deptno, 10, sal, 0)) as �μ�10,
    sum(decode(deptno, 20, sal, 0)) as �μ�20,
    sum(decode(deptno, 30, sal, 0)) as �μ�30,
    sum(sal)
from emp;


select e.ename, e.sal, d.loc 
from emp e, dept d --1��°
where e.deptno = d.deptno;


select e.ename, e.sal, d.loc, d.deptno
from emp e INNER JOIN dept d
ON e.deptno = d.deptno;


select e.ename, e.sal, d.loc, d.deptno
from emp e, dept d
where d.deptno = d.deptno and
    d.deptno = 20;
    
select distinct deptno
from emp;

select e.deptno, d.deptno
from emp e, dept d
where e.deptno(+) = d.deptno;

select e.ename, e.sal, d.loc, e.deptno
from emp e, dept d
where e.deptno(+) = d.deptno;


select e.ename, e.sal, d.loc, d.deptno
from emp e RIGHT OUTER JOIN dept d
where e.deptno(+) = d.deptno;

select e.ename, e.sal, d.loc, d.deptno
--from emp e RIGHT OUTER JOIN dept d
from emp e RIGHT OUTER JOIN dept d
ON e.deptno = d.deptno;

select e.ename, e.sal, d.loc, d.deptno
--from emp e RIGHT OUTER JOIN dept d
from emp e LEFT OUTER JOIN dept d
ON e.deptno = d.deptno;

insert into emp(empno, ename, deptno)
values(9999, 'AAA', 99);


select e.ename, e.sal, d.loc, d.deptno
from dept d FULL OUTER JOIN emp e
ON e.deptno = d.deptno;


--===================================================
--�����ȣ, �����, �����ȣ, ������� ���
select e.empno, e.ename, cp.empno, cp.ename
from emp e INNER JOIN emp cp
ON e.mgr = cp.empno;


select e.empno, e.ename, e.mgr, cp.ename
from emp e, emp cp
where e.mgr = cp.empno; --���� ���Ǻ��� �ɾ��.

select e.empno, e.ename, cp.empno, cp.ename
from emp e LEFT OUTER JOIN emp cp
on e.mgr = cp.empno;

select e.empno, e.ename, cp.empno, cp.ename
from emp e, emp cp
where e.mgr = cp.empno(+);


