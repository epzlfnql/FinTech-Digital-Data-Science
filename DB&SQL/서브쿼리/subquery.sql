--존의 급여는?
select sal from emp where ename = 'JONES';


--존의 급여보다 많이 받는 사원
--2975   보다 많이 받는 사원
select *
from emp
where sal>2975;

select * 
from emp
where sal>(select sal from emp where ename='JONES');

--각부서 급여합, 총합
select sum(sal) from emp where deptno = 10;

select sum(sal) from emp where deptno = 20;

select sum(sal) from emp where deptno = 30;

select sum(sal) from emp;

--10번부서급여합, 20번부서급여합, 30번부서급여합, 총급여합을 출력하시오
select 
 (select sum(sal) as ssal from emp where deptno=10) as 부서10,
 (select sum(sal) as ssal from emp where deptno=20) as 부서20,
 (select sum(sal) as ssal from emp where deptno=30) as 부서30,
 (select sum(sal) as ssal from emp) as 급여총합
from dual;

--from 절에 놓인 subquery ==Inline View
select ssal
from (select sum(sal) as ssal from emp where deptno=10);


-- 7566사원의 급여보다 급여를 많이 받는 사원 정보 출력
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

--EMP 테이블에서 부서 인원이 4명보다 많은 부서의 부서번호, 인원수
--, 급여의 합을 출력하시오.
select deptno, count(*), sum(sal)
from emp
group by deptno
having count(*)>4;


--EMP 테이블에서 가장 많은 사원이 속해있는 부서번호와 사원수를 출력하시오.
select deptno, count(deptno) cnt
from emp
group by deptno
having count(deptno) = 
(select max(count(deptno)) from emp group by deptno);

select max(count(*)) 
from emp
group by mgr;

--EMP 테이블에서 가장 많은 사원을 갖는 MGR의 사원번호를 출력하시오.
select mgr as empno
from emp
group by mgr
having count(*)=(
select max(count(*)) 
from emp
group by mgr);

select * from emp;


select empno, ename, hiredate, trunc((sysdate-hiredate)/365) as 근무년수
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

--EMP 테이블에서 사원번호(EMPNO)가 7521인 사원의 직업(JOB)과 같고
--사원번호(EMPNO)가 7934인 사원의 급여(SAL)보다 많은 사원의
--사원번호, 이름, 직업, 급여를 출력하시오.
select empno, ename, job, sal
from emp
where job = (select job
from emp
where empno=7521) and sal>(select sal
from emp
where empno=7934)
;

--직업별로 최소 급여를 받는 사원의 정보를 사원번호, 이름, 업무, 부서명을
--출력하시오.
--조건1: 직업별로 내림차순 정렬
select e.empno, e.ename, e.job, d.dname
from emp e, dept d
where e.deptno = d.deptno and (e.job, sal) 
in (select job, min(sal) from emp group by job)
order by e.job desc;--이미 안에서 group 지어져있어서


-- 각 부서별 사원수를 출력하시오.
--조건1. 부서별 사원수가 없더라도 부서번호, 부서명 출력
--조건2. 부서별 사원수가 0인 경우 '없음' 출력
--조건3. 부서번호 오름차순 정렬
select d.deptno, d.dname, 
    decode(count(empno), to_char(0), '없음', count(empno)) as 사원수
from emp e, dept d
where e.deptno(+) = d.deptno
group by d.deptno, d.dname
order by d.deptno asc;

select * from emp;

-- 사원 테이블에서 각 사원의 사원번호, 사원명, 매니저번호, 매니저명을
-- 출력하시오.
--조건1. 각 사원의 급여(SAL)는 매니저 급여보다 많거나 같다.
select e.empno, e.ename, e.mgr, cp.ename
from emp e, emp cp
where e.mgr = cp.empno and e.sal>=cp.sal;


--17. 'Jones'가 속해있는 부서의 모든사람의 사원번호, 이름, 입사일, 급여를 출력하라
select empno, ename, hiredate, sal
from emp
where deptno = (select deptno
from emp
where ename='JONES');

--1. DALLAS에서 근무하는 사원의 이름, 직업, 부서번호, 부서이름을 출력하라.
select e.ename, e.job, d.deptno, d.dname
from emp e, dept d
where d.loc = 'DALLAS';

--3. 직업이 'SALESMAN'인 사원들의 직업과 그 사원이름, 부서 이름을 출력하라.
select e.job, e.ename, d.dname
from emp e, dept d
where e.deptno=d.deptno and e.job = 'SALESMAN';

--13. 이름이 'ALLEN'인 사원의 부서명을 출력하라.
select d.dname
from emp e, dept d
where e.deptno=d.deptno and e.ename = 'ALLEN';

--사원번호가 7499인 사원의 직업, 부서번호와 일치하는 사원의 정보를 출력하라.
select * from emp
where (job, deptno)=(select job, deptno from emp where empno=7499);

--10번 부서의 사원들과 같은 월급을 받는 사원들의 이름, 월급, 부서번호를 출력하라.
select ename, sal, deptno
from emp
where sal in (select sal from emp where deptno = 10);

--7. BLACK와 같은 부서에 있는 사원들의 이름과 고용일을 출력하되 'BLAKE'자신은 빼고 출력
select ename, hiredate
from emp
where deptno = (select deptno from emp where ename='BLAKE') and ename not in (select ename from emp where ename = 'BLAKE');

--8. 커미션을 받는 사원과 부서번호, 월급이 같은 사원의 이름, 월급, 부서번호를 출력하라.
select ename, sal, deptno
from emp
where (deptno, sal) in (select deptno, sal from emp where nvl(comm,0)!=0);

--9. MGR가 'KING'인 모든 사원의 이름과 급여를 출력하라.
select e.ename, e.sal
from emp e, emp cp
where e.mgr = cp.empno and cp.ename = 'KING';

--10. 30번 부서 사원들과 월급과 커미션이 같지 않은 사원들의
--이름, 월급, 커미션을 출력하라
select ename, sal, comm
from emp
where (sal, comm) not in (select sal, comm from emp where deptno=30);

select * from dept;
--18. 10번 부서의 사람들 중에서 20번 부서의 사원과 같은 업무를 하는 사원의
--사원번호, 이름, 부서명, 입사일, 지역을 출력하라.
select e.empno, e.ename, d.dname, e.hiredate, d.loc
from emp e, dept d
where e.deptno=10 and e.job in (select job from emp where deptno=20);

--20. 10번 부서 중에서 30번 부서에너느 없는 임무를 하는 사원의 사원번호, 이름, 부서명, 입사일,
--지역을 출력하라.
select e.empno, e.ename, d.dname, e.hiredate, d.loc
from emp e, dept d
where e.deptno=10 and e.job not in (select job from emp where deptno=30);

--22. 'MARTIN'이나 'SCOTT'의 급여와 같은 사원의 사원번호, 이름, 급여를 출력하라.
select empno, ename, sal
from emp
where sal in (select sal from emp where ename='MARTIN' or ename = 'SCOTT');

--24.
select deptno, ename, round(sal/20/8,1)
from emp
order by deptno asc, sal desc;

