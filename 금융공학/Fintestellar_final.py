import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import warnings
warnings.filterwarnings(action='ignore')

#-------------------- 차트 관련 속성 (한글처리, 그리드) -----------
#plt.rc('font', family='NanumGothicOTF') # For MacOS
plt.rcParams['font.family']= 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False
sns.set()

#-------------------- 주피터 , 출력결과 넓이 늘리기 ---------------
from IPython.core.display import display, HTML
display(HTML("<style>.container{width:100% !important;}</style>"))
pd.set_option('display.max_rows', 100)
pd.set_option('display.max_columns', 100)
pd.set_option('max_colwidth', None)


# -- 국내(?)
from pykrx import stock
from pykrx import bond
import sqlalchemy
from sqlalchemy.types import Integer, String
#--- TODO
from pandas_datareader.quandl import QuandlReader

from pandas_datareader import data as pdr
import yfinance as yf
yf.pdr_override()  # <== that's all it takes :-)
import talib
from talib.abstract import *


import plotly.graph_objects as go
import plotly.io as pio
import chart_studio

import cufflinks as cf
pd.options.plotting.backend = "plotly"


# -------------- plotly driver 이용시 아래 코드 활성화 ------------------
# chart_studio.tools.set_credentials_file(username='opencv.korea', api_key='YKVa3qq0Uq9Xf2JiIX22')
# fig = go.Figure(go.Scatter(x=[1, 2, 3, 4], y=[4, 3, 2, 1]))
# fig.update_layout(title_text='hello world')
# pio.write_html(fig, file='./lec00_hello_world222.html', auto_open=False)


# ===============================================================
# !pip install ./TA_Lib-0.4.24-cp38-cp38-win_amd64.whl
# !pip install talib-binary
# ! pip install pandas
# ! pip install SQLAlchemy
# ! pip install yfinance
# ===============================================================

engine = sqlalchemy.create_engine('oracle://ai:0000@localhost:1521/xe')
conn = engine.connect()

def get_ohlcv_국내(SDATE = "2020-01-01",EDATE = "2020-01-31") :
	ohlcv_list = []
	# KOSPI      , KOSDAQ, KONEX
	# tickers = stock.get_market_ticker_list("202201", market="KOSPI")   # 2021-01 해당 일자 코스피 상장된 ticker
	# print(tickers[:5])
	tickers = ['095570', '006840', '027410', '282330', '138930']
	for ticker in tickers:
		try:
			ticker_name = stock.get_market_ticker_name(ticker)
			df = stock.get_market_ohlcv(SDATE, EDATE, tickers)
			# 시가  고가  저가     종가  거래량
			df.columns = ['Open', 'High', 'Low', 'Close', 'Volume']
			df.insert(0, "Ticker", ticker)
			df.insert(1, "TickerName", ticker_name)
			ohlcv_list.append(df)
		except :
			continue
			print("error:", ticker_name)
	dfcp = pd.DataFrame()
	dfcp = pd.concat(ohlcv_list)
	#print(dfcp.head())
	dfcp.to_sql("tbl_ohlcv1", conn
				, if_exists='fail'  # ---append, replace
				, index=True
				, index_label='Date'
				, dtype={
						"Date": sqlalchemy.DateTime
						,"TickerName": String(40), "Ticker": String(10)
						,"Open": Integer()
						, "High": Integer()
						, "Low": Integer()
						, "Close": Integer()
						, "Volume": Integer()
					 }
				)

def get_ohlcv_국외(SDATE = "2020-01-01",EDATE = "2021-01-31") :
	# -- 국외
	# Ticker  TickerName  Open High   Low  Close  Adj Close    Volume
	df = pdr.get_data_yahoo("GOOG", start=SDATE, end=EDATE)
	df.insert(0, "Ticker", "GOOG")
	df.insert(1, "TickerName", "Google")
	#print(df.head())
	dfcp = df.copy() #pd.DataFrame()
	dfcp.to_sql("tbl_ohlcv2", conn
				, if_exists='fail'  # ---append, replace
				, index=True
				, index_label='Date'
				, dtype={
						"Date": sqlalchemy.DateTime
						,"TickerName": String(40), "Ticker": String(10)
						, "Open": Integer()
						, "High": Integer()
						, "Low": Integer()
						, "Close": Integer()
						, "Adj Close": Integer()
						, "Volume": Integer()
						 }
				)

def get_ohlcv(SDATE = "2020-01-01",EDATE = "2021-01-31", type=None) :  #type = "국내","국외"
	try :
		if type == "국내" :
			get_ohlcv_국내(SDATE, EDATE)
		elif type == "국외" :
			get_ohlcv_국외(SDATE, EDATE)
		else :
			get_ohlcv_국내(SDATE, EDATE)
			get_ohlcv_국외(SDATE, EDATE)
	except :
		print("error occured")
		#pass

# ========================== DB 적재 ==================================
# get_ohlcv()  #(type="국내")


# ========================== Data Load ===============================
sql = """select * from tbl_ohlcv1"""
df = pd.read_sql(sql, conn)
df = df.set_index('Date')
# print(df.head())

# """----------------------------------------------------------------
# # 연(Yearly) : Y, A , M
# # 월(Monthly) : M
# # 월(Daily) : D
# # 시(Hour) : H
# # 분(Minute) : T(min)
# # 초(Second) : S
# # 영업일 (Business) : B (주말만 제외되고 공휴일은 제외되지 않음)
# # 주(Weekly) : W
# # 분기(Quarterly) : Q
# #----------------------------------------------------------------"""
# # print( df[df['Ticker']=="095570"]['Close'].resample(rule='MS').first() )  	#매월 초 가격
# # print( df[df['Ticker']=="095570"]['Close'].resample(rule='M').last() )    	#매월 말 가격
# # print( df[df['Ticker']=="095570"]['Close'].resample(rule='Y').first() )   	#매년
# # print( df[df['Ticker']=="095570"]['Close'].resample(rule='12T').first() )   	#12시간간격
# # print( df[df['Ticker']=="095570"]['Close'].resample(rule='5min').first() )   	#5분간격
# # print( df[df['Ticker']=="095570"]['Close'].resample(rule='Q').first() )   	#분기간격
#
#

def get_chart(type="bol", df=df, backend=True):
	if type == "bol":
		qf = cf.QuantFig(df)
		qf.add_bollinger_bands()
		qf.iplot()
		plt.show()
	else :
		if bool(backend) :
			fig = df.plot()
			fig.show()
		else :
			df.plot()
			plt.show()

get_chart("bol", df)
# get_chart("matplot", df['Close'], backend=True)

# # https://mrjbq7.github.io/ta-lib/
def get_talib_idx(type="bol", df=df, tp=5) :
	if type=="rsi" :
		#real = RSI(close, timeperiod=14)
		return  talib.RSI(df['Close'], timeperiod=tp)
	elif type == "obv":
		#real = OBV(close, volume)
		return talib.OBV(df['Close'], df['Volume'])
	elif type == "wma":
		# real = WMA(close, timeperiod=30)
		return talib.WMA(df['Close'], timeperiod=tp)
	elif type == "ma":
		#real = MA(close, timeperiod=30, matype=0)
		return  talib.MA(df['Close'], timeperiod=tp, matype=0)
	elif type == "macd":
		# macd, macdsignal, macdhist = MACD(close,     fastperiod=12, slowperiod=26, signalperiod=9)
		return talib.MACD(df['Close'],                 fastperiod=12,slowperiod=26, signalperiod=9)
	elif type == "mom":
		# real = MOM(close, timeperiod=10)
		return talib.MOM(df['Close'], timeperiod=tp)
	elif type == "sto":
		# fastk, fastd = STOCHF(high, low, close,       fastk_period=5, fastd_period=3, fastd_matype=0)
		return talib.STOCHF(df['High'], df['Low'], df['Close'],           fastk_period=5, fastd_period=3, fastd_matype=0)
	elif type == "bol":
		#upperband, middleband, lowerband = BBANDS(close, timeperiod=5,  nbdevup=2, nbdevdn=2, matype=0)
		return talib.BBANDS(df['Close'], timeperiod=tp,                  nbdevup=2, nbdevdn=2, matype=0)

# res 	= get_talib_idx("rsi", df, tp=5)
# res 	= get_talib_idx("obv", df, tp=5)
# res 	= get_talib_idx("wma", df, tp=5)
# res 	= get_talib_idx("ma" , df, tp=5)
# macd, signal, hist = get_talib_idx("macd", df)
# res 	= get_talib_idx("mom", df, tp=5)
# k, d 	= get_talib_idx("sto", df)
# up, price, lower = get_talib_idx("bol", df, tp=5)




