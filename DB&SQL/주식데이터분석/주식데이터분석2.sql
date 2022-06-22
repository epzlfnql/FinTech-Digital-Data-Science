-- stock_hist ���̺��� ������ �ŷ�Ƚ���� ����Ͻÿ�.
--����: IEM_CD, BSE_DT �������� ����
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


-- stock_meta ���̺��� 'tco_cus_grd_cd'�� '04'���� ����Ͻÿ�.

select val from stock_meta
where col = upper('tco_cus_grd_cd') and code='04';

select * from stock_meta;

-- ���1) ������ ���
select col, val
from stock_meta
where (col='IVS_ICN_CD' and code='02') or
        (col='CUS_AET_STN_CD' and code='04');


--���2) select�� ��������
select --select ���Ľ����� ���� ���η� �޿� �����ȴ�.
    (select val from stock_meta where (col='IVS_ICN_CD' and code='02')) as v1,
    (select val from stock_meta where (col='CUS_AET_STN_CD' and code ='04')) as v2
    from dual;


--���3) from�� ��������(inline view)
select * 
from
    (select val from stock_meta where (col='IVS_ICN_CD' and code = '02')) t1,
    (select val from stock_meta where (col='CUS_AET_STN_CD' and code='04')) t2;

select val from stock_meta where col='CUS_AET_STN_CD' and code='04';

select code('CUS_AET_STN_CD','04') from dual;

----------------------------------------------
--3. stock_hist, stock_info, stock_meta ���̺��� ����� �Ʒ��� ���� ����Ͻÿ�.
--act_id  SEX_DIT_CD  val1     CUS_AGE_STN_CD   val2  
-------   ----------  -----    --------------  ---------------------
--fa1da	01          01:����   04              04: 35��~40���̸�
--76fa2	01          01:����   06              06: 45��~50���̸�
--7bde6	02          02:����   07              07: 50��~55���̸�
-- ~~~~
select * from stock_hist;
select * from stock_meta;
select * from stock_info;

-- ���1) �������� īƼ�ǰ� �� ���� �˻�(���귮 ����..)
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
      

-- ���2) from �������� ���̺� ����� �� -->inline view ����
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


--��) stock_info�� stock_meta ���̺��� ����� stk_dit_cd ���� �̿��� ������ ���� ����Ͻÿ�.
--stk_dit_cd   val
--------------  --------------
--99	        99: ��Ÿ
--01	        01: �ڽ���200
--02	        02: �ڽ���150

select stk_dit_cd, code('stk_dit_cd', stk_dit_cd) as val
from stock_info;


-- ��) user_stock ���̺��� ���ڼ���(IVS_ICN_CD) �� �������(BTP_CFC_CD) �������� ����
-- �ؼ� : stock_hist�� �� ���̺�� ������ִ�.
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

-- ��) stock_hold stock_hist ���̺��� ����� ���������� , �����ŵ������� , �Ⱓ(���ڱⰣ start, end )
--hold���� �ִ볯¥�� ������¥
select * from stock_hold;



select max(byn_dt), min(byn_dt), max(byn_dt)-min(byn_dt)
from stock_hold
group by act_id
having act_id = 'c737a';

--����ں� �ŵ� ���� Ȯ��
select act_id, count(1), min(byn_dt), max(byn_dt),
avg(hold_d) ahold,
to_date(max(byn_dt), 'YYYY-MM-DD') - to_date(min(byn_dt),'YYYY-MM-DD') as dd,
(to_date(max(byn_dt), 'YYYY-MM-DD') - to_date(min(byn_dt),'YYYY-MM-DD'))/365 as YY
from stock_hold
group by act_id;


select iem_cd, max(bse_dt) --������ �����ִ� ���񿡼� max��¥(�ֱٳ�¥�� ���� ��)
from stock_hist
where act_id='085a7'
group by iem_cd
order by iem_cd;


select iem_cd, max(bse_dt) --������ �����ִ� ���񿡼� max��¥(�ֱٳ�¥�� ���� ��)
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


-- ���� �ŵ� ����
select distinct hi.iem_cd, hi.bse_dt
from stock_hist hi, stock_hold ho
where hi.iem_cd = ho.iem_cd and hi.bse_dt=ho.byn_dt
and hi.act_id='085a7';


create table test_1 
as  --�Ʒ� ���� ���ó�� �������
(select * from emp
where deptno = 10);


--������ �״�� ��������
create table test_3
as
(select * from emp where 1=0);

--���̺��� ��������� ����� ���� �� �ִ�.
--alter table emp modify ename varchar(15);

create table test_2
as --as�ڿ��� �Ϻ��� sql��(��������)�� ��Ÿ���� �Ѵ�.
(select * from emp where 1=0); --�̿� ���� ���ó�� �����޶�.


insert into test_2(empno, ename, deptno)
values(9999, 'ZZZZ', 30);

update test_2 
set ename = 'zzzz', deptno=10
where ename = 'zxzz';
select * from test_2;

update test_2222
set deptno =''--null�� update�Ҷ��� =null�� ���
where empno = 9999;

select * from test_2;
delete from test_2
where ename='zzzz';


insert into test_2(empno, ename, deptno)
(select empno, ename, deptno from emp where deptno=10);
savepoint ty1; --���̺�����Ʈ ����


savepoint ty2;


commit to ty1; --ty1 savepoint �������� ����

