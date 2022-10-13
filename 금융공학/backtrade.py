from datetime import datetime
import backtrader as bt

import pandas_datareader as pdr
import FinanceDataReader as fdr


class SmaCross(bt.SignalStrategy):
    def __init__(self):

        # 여기에 기능을 더 넣을 수 있다.
        # rsi나 등등
        sma1, sma2 = bt.ind.SMA(period=10), bt.ind.SMA(period=30)
        crossover = bt.ind.CrossOver(sma1, sma2)
        self.signal_add(bt.SIGNAL_LONG, crossover)

cerebro = bt.Cerebro()
cerebro.addstrategy(SmaCross)

# data0 = bt.feeds.YahooFinanceData(dataname='MSFT', fromdate=datetime(2011, 1, 1),todate=datetime(2012, 12, 31))

data0 = pdr.get_data_yahoo('AAPL',start='2020-01-01', end='2020-12-31')
feed = bt.feeds.PandasData(dataname=data0)
cerebro.adddata(feed)

# data0.to_csv('data2.csv',index =True)

cerebro.run()
cerebro.plot()
