select * from emp;

--1981년 2월 20일부터 1981년 5월 1일 사이에 입사한 사원의 이름, 담당업무
-- 입사일을 출력하시오.
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

-- 이름에 A와 E를 모두 포함하고 있는 사원의 이름을 출력하시오.
select ename 
from emp
where ename like '%A%' and ename like '%E%';


--직급에 따라 인상된 급여를 출력하시오.
--'salesman'인 사원은 180, 'manager'인 사원은 150, 'clerk'인 사원은 100을 인상.
--decode 함수를 사용한다.
select sal, decode(job,
                    'SALESMAN', sal+180,
                    'MANAGER', sal+150,
                    'CLERK', sal+100,
                    sal) as upsal
                    from emp;
             
             
--직업별로 최대급여, 최소급여, 평균급여를 출력하시오.
--평균에 대해서는 정수로 반올림 하시오.
select job, max(sal), min(sal), round(avg(sal),0) as asal
from emp
group by job
order by asal;


--각 부서별 급여합과 급여 총합을 다음과 같이 출력하시오.
select deptno, sum(sal) as ssal
from emp
group by deptno;

select ename, sal, job
from emp;

select 
    sum(decode(deptno, 10, sal, 0)) as 부서10,
    sum(decode(deptno, 20, sal, 0)) as 부서20,
    sum(decode(deptno, 30, sal, 0)) as 부서30,
    sum(sal)
from emp;


select e.ename, e.sal, d.loc 
from emp e, dept d --1번째
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
--사원번호, 사원명, 사수번호, 사수명을 출력
select e.empno, e.ename, cp.empno, cp.ename
from emp e INNER JOIN emp cp
ON e.mgr = cp.empno;


select e.empno, e.ename, e.mgr, cp.ename
from emp e, emp cp
where e.mgr = cp.empno; --먼저 조건부터 걸어라.

select e.empno, e.ename, cp.empno, cp.ename
from emp e LEFT OUTER JOIN emp cp
on e.mgr = cp.empno;

select e.empno, e.ename, cp.empno, cp.ename
from emp e, emp cp
where e.mgr = cp.empno(+);


