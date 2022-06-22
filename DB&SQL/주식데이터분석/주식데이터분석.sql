select d.hold_d from stock_hist h, stock_hold d
where h.act_id = d.act_id
;

select act_id, avg(hold_d)
from stock_hold
group by act_id
order by avg(hold_d) desc;

select act_id, sum(hold_d)
from stock_hold
group by act_id
order by sum(hold_d) desc;



select *
from stock_hist h, stock_hold d
where h.act_id=d.act_id
;



select act_id, sum(hold_d), avg(hold_d)
from stock_hold
group by act_id
order by sum(hold_d) desc, avg(hold_d) desc;

select count(1) from stock_hist; --243줄
select count(1) from stock_hold; -- 31줄
select count(1) from stock_info; --3079줄
select count(1) from stock_meta; --98줄
select count(1) from stock_user; --9920줄

--NH 투자증권 공개 데이터(만개의 stock_user 데이터 사용)
select distinct user_seq, user_id
from users
where user_seq not in (select distinct user_seq from oders);


--2/5   40%
select incnt||'/'totcnt as 회원수, (incnt/totcnt)*100||'%' as 휴면회원비율
from
    (select count(1) as totcnt from users) t,
    (select count(1) as incnt
    from users
    where user_seq not in (select distinct user_seq from orders)) i;
    
    
select cp.user_id as 매니저, u.user_id as 회원
from user u, user cp
where u.mgr_seq = cp.user_seq and
u.user_gubun !='a'; 



select (select sum(order_amount) from orders_goods) as AMT,
        (select sum(order_price) from orders_goods) as PRICE,
        (select count(1) from users) as UCNT,
        (select count(1) from company) as CCNT,
        (select count(1) from goods) as GCNT
    from dual;


select order_date
from orders
group by to_char(order_date, 'YYYY-MM');

select 
    sum(decode(to_char(order_date, 'YYYY-MM'), '2018-01',1,0)) as 월1,
    sum(decode(to_char(order_date, 'YYYY-MM'), '2018-02', 1, 0)) as 월2,
    sum(decode(to_char(order_date, 'YYYY-MM'), '2018-03', 1,0)) as 월3
    from orders;
    
    
select to_char(order_date, 'MM') as mm, count(1)
from orders
where to_char(order_date, 'YYYY') = '2018'
group by to_char(order_date, 'MM')
order by mm asc;

--코드별, 일자별 정렬
select * from stock_hist;
--act_id, iem cd, bse_dt
--where 7bde6

select ACT_ID
,IEM_CD
,BSE_DT
,BNC_QTY
,TOT_AET_AMT
,STK_PAR_PR
from stock_hist
where act_id = '7bde6'
order by iem_cd, bse_dt;

select 
COL
,COL_KOR
,CODE
,VAL
from stock_meta;

select *
from stock_meta
where col_kor = '고객등급';

select
COL,
COL_KOR,
CODE,
VAL
from stock_meta
where col = upper('tco_cus_grd_cd');

--자산 구간 04이거나 투자성향 02인 사람 뽑아라
select * from stock_meta
where (COL_KOR = '고객자산구간' and code = '04') or (COL_KOR = '투자성향' and code='02');


select (select val
    from stock_meta
    where (col='IVS_ICN_CD' and code='02')) as v1,
    (select val
    from stock_meta
    where (col='CUS_AET_STN_CD' and code='04')) as v2
    from dual;
    
select *
from
    (select val from stock_meta where  (col='IVS_ICN_CD' and  code='02') ) t1 ,
    (select val from stock_meta where  (col='CUS_AET_STN_CD' and  code='04') ) t2
;



select val
from stock_meta;

select * from stock_meta;




select 
    U.ACT_ID,
    U.SEX_DIT_CD,
    M.VAL AS VAL1,
    U.CUS_AGE_STN_CD,
    M2.VAL AS VAL2
FROM STOCK_USER U,STOCK_META M ,STOCK_META M2
WHERE U.SEX_DIT_CD = M.CODE AND
       U.CUS_AGE_STN_CD = M2.CODE AND
      M.COL = 'SEX_DIT_CD' AND 
      M2.COL = 'CUS_AGE_STN_CD';
;

select ACT_ID
    , SEX_DIT_CD
        , S.VAL
    , CUS_AGE_STN_CD
    , AGE.VAL
from stock_user A
      LEFT JOIN (SELECT COL, VAL, CODE  FROM STOCK_META WHERE COL = 'SEX_DIT_CD') S ON A.SEX_DIT_CD = S.CODE
      LEFT JOIN (SELECT COL, VAL, CODE FROM STOCK_META WHERE COL = 'CUS_AGE_STN_CD') AGE ON A.CUS_AGE_STN_CD = AGE.CODE;



select * from stock_meta;

select s.*, m.val
from stock_info s, stock_meta m
where m.col = 'STK_DIT_CD' and m.code = s.stk_dit_cd;



-- 함수 만들기
select s.IEM_CD,
s.IEM_KRL_NM,
s.BTP_CFC_CD, code('BTP_CFC_CD', s.BTP_CFC_CD),
s.MKT_PR_TAL_SCL_TP_CD, code('MKT_PR_TAL_SCL_TP_CD', s.MKT_PR_TAL_SCL_TP_CD),
s.STK_DIT_CD, code('STK_DIT_CD', s.STK_DIT_CD)
from stock_info s;



-- stock_info와 stock_meta 테이블을 사용해 stk_dit_cd 값을 이용해 다음과 같이 출력하시오.
select s.stk_dit_cd, code('stk_dit_cd', s.stk_dit_cd)
from stock_info s;



-- stock_user 테이블에서  연령대(cus_age_stn_cd), 성별(sex_dit_cd)을 내림차순으로 출력하시오. 
select cus_age_stn_cd, sex_dit_cd, count(1) as cnt
from stock_user
group by cus_age_stn_cd, sex_dit_cd --일반컬럼이랑 묶이면 반드시 같이 묶어라.
order by cnt desc;


select code('cus_age_stn_cd', cus_age_stn_cd), 
        code('sex_dit_cd', sex_dit_cd)
        , count(1) as cnt
from stock_user
group by cus_age_stn_cd, sex_dit_cd --일반컬럼이랑 묶이면 반드시 같이 묶어라.
order by cnt desc;

select * from stock_user;
select * from stock_hist;


select distinct u.act_id 
    ,u.sex_dit_cd ,code('sex_dit_cd', u.sex_dit_cd) as 성별
    
from stock_hist h, stock_user u
where h.act_id = u.act_id
;

select * from stock_user;
select count(1) from stock_user
where sex_dit_cd='01' and cus_age_stn_cd in ('03','04');

select count(1) from stock_user
where sex_dit_cd='02' and cus_age_stn_cd in ('03', '04');

select * from stock_user;


-- 문제--
select u.sex_dit_cd, 
       code('sex_dit_cd', sex_dit_cd) as 남녀,
       count(1) as cnt, 
       round(count(1)/t.tot * 100,1)||'%'
from stock_user u, 
     (select count(1) as tot from stock_user where CUS_AGE_STN_CD  in ('03','04') ) t
where u.CUS_AGE_STN_CD  in ('03','04')
group by u.sex_dit_cd, t.tot;'


select fcnt as 여성, mcnt as 남성, fcnt/tot*100, mcnt/tot*100
from(
select
    (select count(1) from stock_user where sex_dit_cd='02' and cus_age_stn_cd in ('03', '04')) as fcnt,
    (select count(1) from stock_user where sex_dit_cd='01' and cus_age_stn_cd in ('03', '04')) as mcnt,
    (select count(1) from stock_user where cus_age_stn_cd in ('03', '04')) as tot
    from dual
);


--
select * from stock_user;

select max(count(1)) 
from stock_user
group by ivs_icn_cd;


-- stock_user 테이블에서 가장 많은 투자성향(ivs_icn_cd)을 출력하시오.
select ivs_icn_cd,
    code('ivs_icn_cd', ivs_icn_cd)
    ,count(1) as cnt
from stock_user
group by ivs_icn_cd
having count(1) = (select max(count(1)) --서브쿼리 사용.
from stock_user
group by ivs_icn_cd)
;

select * from stock_user;
select * from stock_info;

-- user_stock 테이블에서 투자성향(ivs_icn_cd) 별 종목업종(btp_cfc_cd) 내림차순 정렬
select ivs_icn_cd, btp_cfc_cd
from stock_user u, 
group by ivs_icn_cd;

-- stock_hold, stock_hist 보유한 종목, 전량 매도한 종목 개수, 기간(start), 기간(end), 개월수

