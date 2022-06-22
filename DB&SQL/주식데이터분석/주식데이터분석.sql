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

select count(1) from stock_hist; --243��
select count(1) from stock_hold; -- 31��
select count(1) from stock_info; --3079��
select count(1) from stock_meta; --98��
select count(1) from stock_user; --9920��

--NH �������� ���� ������(������ stock_user ������ ���)
select distinct user_seq, user_id
from users
where user_seq not in (select distinct user_seq from oders);


--2/5   40%
select incnt||'/'totcnt as ȸ����, (incnt/totcnt)*100||'%' as �޸�ȸ������
from
    (select count(1) as totcnt from users) t,
    (select count(1) as incnt
    from users
    where user_seq not in (select distinct user_seq from orders)) i;
    
    
select cp.user_id as �Ŵ���, u.user_id as ȸ��
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
    sum(decode(to_char(order_date, 'YYYY-MM'), '2018-01',1,0)) as ��1,
    sum(decode(to_char(order_date, 'YYYY-MM'), '2018-02', 1, 0)) as ��2,
    sum(decode(to_char(order_date, 'YYYY-MM'), '2018-03', 1,0)) as ��3
    from orders;
    
    
select to_char(order_date, 'MM') as mm, count(1)
from orders
where to_char(order_date, 'YYYY') = '2018'
group by to_char(order_date, 'MM')
order by mm asc;

--�ڵ庰, ���ں� ����
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
where col_kor = '�����';

select
COL,
COL_KOR,
CODE,
VAL
from stock_meta
where col = upper('tco_cus_grd_cd');

--�ڻ� ���� 04�̰ų� ���ڼ��� 02�� ��� �̾ƶ�
select * from stock_meta
where (COL_KOR = '���ڻ걸��' and code = '04') or (COL_KOR = '���ڼ���' and code='02');


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



-- �Լ� �����
select s.IEM_CD,
s.IEM_KRL_NM,
s.BTP_CFC_CD, code('BTP_CFC_CD', s.BTP_CFC_CD),
s.MKT_PR_TAL_SCL_TP_CD, code('MKT_PR_TAL_SCL_TP_CD', s.MKT_PR_TAL_SCL_TP_CD),
s.STK_DIT_CD, code('STK_DIT_CD', s.STK_DIT_CD)
from stock_info s;



-- stock_info�� stock_meta ���̺��� ����� stk_dit_cd ���� �̿��� ������ ���� ����Ͻÿ�.
select s.stk_dit_cd, code('stk_dit_cd', s.stk_dit_cd)
from stock_info s;



-- stock_user ���̺���  ���ɴ�(cus_age_stn_cd), ����(sex_dit_cd)�� ������������ ����Ͻÿ�. 
select cus_age_stn_cd, sex_dit_cd, count(1) as cnt
from stock_user
group by cus_age_stn_cd, sex_dit_cd --�Ϲ��÷��̶� ���̸� �ݵ�� ���� �����.
order by cnt desc;


select code('cus_age_stn_cd', cus_age_stn_cd), 
        code('sex_dit_cd', sex_dit_cd)
        , count(1) as cnt
from stock_user
group by cus_age_stn_cd, sex_dit_cd --�Ϲ��÷��̶� ���̸� �ݵ�� ���� �����.
order by cnt desc;

select * from stock_user;
select * from stock_hist;


select distinct u.act_id 
    ,u.sex_dit_cd ,code('sex_dit_cd', u.sex_dit_cd) as ����
    
from stock_hist h, stock_user u
where h.act_id = u.act_id
;

select * from stock_user;
select count(1) from stock_user
where sex_dit_cd='01' and cus_age_stn_cd in ('03','04');

select count(1) from stock_user
where sex_dit_cd='02' and cus_age_stn_cd in ('03', '04');

select * from stock_user;


-- ����--
select u.sex_dit_cd, 
       code('sex_dit_cd', sex_dit_cd) as ����,
       count(1) as cnt, 
       round(count(1)/t.tot * 100,1)||'%'
from stock_user u, 
     (select count(1) as tot from stock_user where CUS_AGE_STN_CD  in ('03','04') ) t
where u.CUS_AGE_STN_CD  in ('03','04')
group by u.sex_dit_cd, t.tot;'


select fcnt as ����, mcnt as ����, fcnt/tot*100, mcnt/tot*100
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


-- stock_user ���̺��� ���� ���� ���ڼ���(ivs_icn_cd)�� ����Ͻÿ�.
select ivs_icn_cd,
    code('ivs_icn_cd', ivs_icn_cd)
    ,count(1) as cnt
from stock_user
group by ivs_icn_cd
having count(1) = (select max(count(1)) --�������� ���.
from stock_user
group by ivs_icn_cd)
;

select * from stock_user;
select * from stock_info;

-- user_stock ���̺��� ���ڼ���(ivs_icn_cd) �� �������(btp_cfc_cd) �������� ����
select ivs_icn_cd, btp_cfc_cd
from stock_user u, 
group by ivs_icn_cd;

-- stock_hold, stock_hist ������ ����, ���� �ŵ��� ���� ����, �Ⱓ(start), �Ⱓ(end), ������

