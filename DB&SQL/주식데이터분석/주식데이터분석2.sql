-- stock_hist 테이블에서 유저별 거래횟수롤 출력하시오.
--조건: IEM_CD, BSE_DT 오름차순 정렬
select count(1)
from stock_hist
group by act_id;

select
act_id,
iem_cd,
bse_dt,
bnc_qty,
tot_aet_amt,
stk_par_pr
from stock_hist
where act_id = '7bde6'
order by iem_cd, bse_dt;


-- stock_meta 테이블에서 'tco_cus_grd_cd'의 '04'값을 출력하시오.

select val from stock_meta
where col = upper('tco_cus_grd_cd') and code='04';

select * from stock_meta;

-- 방법1) 세로형 출력
select col, val
from stock_meta
where (col='IVS_ICN_CD' and code='02') or
        (col='CUS_AET_STN_CD' and code='04');


--방법2) select절 서브쿼리
select --select 병렬식으로 쓰면 가로로 쭈욱 나열된다.
    (select val from stock_meta where (col='IVS_ICN_CD' and code='02')) as v1,
    (select val from stock_meta where (col='CUS_AET_STN_CD' and code ='04')) as v2
    from dual;


--방법3) from절 서브쿼리(inline view)
select * 
from
    (select val from stock_meta where (col='IVS_ICN_CD' and code = '02')) t1,
    (select val from stock_meta where (col='CUS_AET_STN_CD' and code='04')) t2;

select val from stock_meta where col='CUS_AET_STN_CD' and code='04';

select code('CUS_AET_STN_CD','04') from dual;

----------------------------------------------
--3. stock_hist, stock_info, stock_meta 테이블을 사용해 아래와 같이 출력하시오.
--act_id  SEX_DIT_CD  val1     CUS_AGE_STN_CD   val2  
-------   ----------  -----    --------------  ---------------------
--fa1da	01          01:남성   04              04: 35세~40세미만
--76fa2	01          01:남성   06              06: 45세~50세미만
--7bde6	02          02:여성   07              07: 50세~55세미만
-- ~~~~
select * from stock_hist;
select * from stock_meta;
select * from stock_info;

-- 방법1) 조인으로 카티션곱 후 조건 검색(연산량 오버..)
select m.val, s.stk_dit_cd
from stock_info s, stock_meta m
where m.col = 'STK_DIT_CD' and m.code = s.stk_dit_cd;

select 
    U.ACT_ID,
    U.SEX_DIT_CD,
    M.VAL AS VAL1,
    U.CUS_AGE_STN_CD,
    M2.VAL AS VAL2
FROM STOCK_USER U,  STOCK_META M ,STOCK_META M2
WHERE U.SEX_DIT_CD = M.CODE      AND
      U.CUS_AGE_STN_CD = M2.CODE AND
      M.COL = 'SEX_DIT_CD' AND 
      M2.COL = 'CUS_AGE_STN_CD';
      

-- 방법2) from 조건으로 테이블 축약한 후 -->inline view 조인
select ACT_ID
    , SEX_DIT_CD
    , S.VAL
    , CUS_AGE_STN_CD
    , AGE.VAL    
from stock_user A
      LEFT JOIN (SELECT COL, VAL, CODE  FROM STOCK_META WHERE COL = 'SEX_DIT_CD') S ON A.SEX_DIT_CD = S.CODE
      LEFT JOIN (SELECT COL, VAL, CODE FROM STOCK_META WHERE COL = 'CUS_AGE_STN_CD') AGE ON A.CUS_AGE_STN_CD = AGE.CODE;


select code('BTP_CFC_CD', '08') FROM dual;

select  s.IEM_CD,
        s.IEM_KRL_NM,
        s.BTP_CFC_CD           , code('BTP_CFC_CD', s.BTP_CFC_CD) ,
        s.MKT_PR_TAL_SCL_TP_CD , code('MKT_PR_TAL_SCL_TP_CD', s.MKT_PR_TAL_SCL_TP_CD) ,
        s.STK_DIT_CD           , code('STK_DIT_CD', s.STK_DIT_CD) 
from stock_info s;        


--문) stock_info와 stock_meta 테이블을 사용해 stk_dit_cd 값을 이용해 다음과 같이 출력하시오.
--stk_dit_cd   val
--------------  --------------
--99	        99: 기타
--01	        01: 코스피200
--02	        02: 코스닥150

select stk_dit_cd, code('stk_dit_cd', stk_dit_cd) as val
from stock_info;


-- 문) user_stock 테이블에서 투자성향(IVS_ICN_CD) 별 종목업종(BTP_CFC_CD) 내림차순 정렬
-- 해설 : stock_hist가 두 테이블과 연결돼있다.
select IVS_ICN_CD, BTP_CFC_CD, 
 code('IVS_ICN_CD', IVS_ICN_CD) as val1,
 code('BTP_CFC_CD', BTP_CFC_CD) as val2,
 count(1) as cnt
from stock_info i, stock_hist h, stock_user u
where i.iem_cd= h.iem_cd and
h.act_id = u.act_id
group by IVS_ICN_CD, BTP_CFC_CD
order by cnt desc;

select count(1) from stock_hist;

-- 문) stock_hold stock_hist 테이블을 사용해 보유한종목 , 전량매도한종목 , 기간(투자기간 start, end )
--hold에서 최대날짜와 최저날짜
select * from stock_hold;



select max(byn_dt), min(byn_dt), max(byn_dt)-min(byn_dt)
from stock_hold
group by act_id
having act_id = 'c737a';

--사용자별 매도 종목 확인
select act_id, count(1), min(byn_dt), max(byn_dt),
avg(hold_d) ahold,
to_date(max(byn_dt), 'YYYY-MM-DD') - to_date(min(byn_dt),'YYYY-MM-DD') as dd,
(to_date(max(byn_dt), 'YYYY-MM-DD') - to_date(min(byn_dt),'YYYY-MM-DD'))/365 as YY
from stock_hold
group by act_id;


select iem_cd, max(bse_dt) --유저가 갖고있는 종목에서 max날짜(최근날짜만 들고온 것)
from stock_hist
where act_id='085a7'
group by iem_cd
order by iem_cd;


select iem_cd, max(bse_dt) --유저가 갖고있는 종목에서 max날짜(최근날짜만 들고온 것)
from stock_hist
where act_id='8daf2'
group by iem_cd
order by iem_cd;


select t1.iem_cd, t1.bse_dt, t2.bnc_qty
from
    (select iem_cd, max(bse_dt) as bse_dt
from stock_hist
--where act_id = '085a7'
group by act_id, iem_cd
order by iem_cd) t1,
(select act_id, iem_cd, bse_dt, bnc_qty
from stock_hist
where act_id = '085a7'
order by iem_cd, bse_dt) t2

where t1.iem_cd = t2.iem_cd and
t1.bse_dt = t2.bse_dt and
t2.bnc_qty >0;


-- 전량 매도 종목
select distinct hi.iem_cd, hi.bse_dt
from stock_hist hi, stock_hold ho
where hi.iem_cd = ho.iem_cd and hi.bse_dt=ho.byn_dt
and hi.act_id='085a7';


create table test_1 
as  --아래 같은 모양처럼 만들어줘
(select * from emp
where deptno = 10);


--구조만 그대로 가져오기
create table test_3
as
(select * from emp where 1=0);

--테이블이 비어있으면 사이즈를 줄일 수 있다.
--alter table emp modify ename varchar(15);

create table test_2
as --as뒤에는 완벽한 sql문(서브쿼리)가 나타나야 한다.
(select * from emp where 1=0); --이와 같은 결과처럼 만들어달라.


insert into test_2(empno, ename, deptno)
values(9999, 'ZZZZ', 30);

update test_2 
set ename = 'zzzz', deptno=10
where ename = 'zxzz';
select * from test_2;

update test_2222
set deptno =''--null을 update할때는 =null도 허용
where empno = 9999;

select * from test_2;
delete from test_2
where ename='zzzz';


insert into test_2(empno, ename, deptno)
(select empno, ename, deptno from emp where deptno=10);
savepoint ty1; --세이브포인트 결정


savepoint ty2;


commit to ty1; --ty1 savepoint 전까지만 저장

