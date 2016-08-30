library(forecast)
data <- read.csv("data/sample_sum_int.csv", header=T)
data$date <- as.Date(data$date)

data_2013_9 <- subset(data,data$date >= "2013-09-01")
data_2013_9 <- subset(data_2013_9,data_2013_9$date <= "2013-09-30")
purchase_ratio <- data_2013_9[21,2]/median(data_2013_9$total_purchase)
redeem_ratio <- data_2013_9[21,3]/median(data_2013_9$total_redeem)
data <- subset(data,data$date >= "2014-04-01")
#画purchase和redeem总体趋势图
plot(data$date,data$total_purchase,type="l")
plot(data$date,data$total_redeem,type="l")

#查看自相关图
acf <- acf(data$total_purchase,lag.max=60,plot=FALSE)
plot(acf)
#查看自相关图
pacf <- pacf(data$total_purchase,lag.max=50,plot=FALSE)
plot(pacf)

#查看purchase一次季节差分后自相关图
acf_diff <- acf(diff(data$total_purchase,7),lag.max=60,plot=FALSE)
plot(acf_diff)
#查看一次季节差分后自相关图
pacf_diff <- pacf(diff(data$total_purchase,7),lag.max=50,plot=FALSE)
plot(pacf_diff)

#查看redeem自相关图
acf_redeem <- acf(data$total_redeem,lag.max=60,plot=FALSE)
plot(acf_redeem)
#查看redeem偏自相关图
pacf_redeem <- pacf(data$total_redeem,lag.max=50,plot=FALSE)
plot(pacf_redeem)
#查看redeem一次季节差分后自相关图
acf_redeem_diff <- acf(diff(data$total_redeem,7),lag.max=60,plot=FALSE)
plot(acf_redeem_diff)
#查看redeem一次季节差分后偏自相关图
pacf_redeem_diff <- pacf(diff(data$total_redeem,7),lag.max=50,plot=FALSE)
plot(pacf_redeem_diff)

#使用ARIMA建模-purchase

library(forecast)
## Forecast with ARIMA model
forecastArima <- function(x, n.ahead=30){
  myTs <- ts(x$total_purchase, start=1, frequency=153)  #建立ts对象
  # fit.arima <- arima(myTs,order=c(15,1,3))   #使用arima拟合
  fit.arima <- arima(x$total_purchase,order=c(1,0,0),seasonal=list(order=c(1,1,1),period=7),
                     include.mean=F)
  fore <- forecast(fit.arima, h=n.ahead)     #预测
  #print(fore)
  plot(fore)
  upper <- fore$upper[,'95%']
  lower <- fore$lower[,'95%']
  trend <- as.numeric(fore$fitted)
  pred <- as.numeric(fore$mean)
  output <- data.frame(actual = c(x$total_purchase, rep(NA, n.ahead)),
                       trend = c(trend, rep(NA, n.ahead)),
                       #pred = c(trend, pred),
                       pred = c(rep(NA, nrow(x)), pred),
                       lower = c(rep(NA, nrow(x)), lower),                       
                       upper = c(rep(NA, nrow(x)), upper),                       
                       Date = c(x$date, max(x$date) + (1:n.ahead))  
  )
  return(output)
}
#result.arima
plotForecastResult <- function(x, title=NULL) {
  x <- x[order(x$Date),]
  max.val <- max(c(x$actual, x$upper), na.rm=T)
  min.val <- min(c(x$actual, x$lower), na.rm=T)
  plot(x$Date, x$actual, type="l", col="grey", main=title,
       xlab="Time", ylab="Exchange Rate",
       xlim=range(x$Date), ylim=c(min.val, max.val))
  grid()
  lines(x$Date, x$trend, col="yellowgreen")
  lines(x$Date, x$pred, col="green")
  lines(x$Date, x$lower, col="blue")
  lines(x$Date, x$upper, col="blue")
  legend("topleft", col=c("grey", "yellowgreen", "green", "blue"), lty=1,
         c("Actual", "Trend", "Forecast", "Lower/Upper Bound"))
}

#全量数据预测
pre_purchase <- forecastArima(data, n.ahead = 30)
plotForecastResult(pre_purchase, title = "Purchase forecasting with ARIMA")
write.csv(pre_purchase,file="data/620/begin_4/arima_purchase.csv")

#预测redeem

forecastArima <- function(x, n.ahead=30){
  myTs <- ts(x$total_redeem, start=1, frequency=153)  #建立ts对象
  # fit.arima <- arima(myTs,order=c(15,1,3))   #使用arima拟合
  fit.arima <- arima(x$total_redeem,order=c(1,0,0),seasonal=list(order=c(1,1,1),period=7),
                     include.mean=F)
  fore <- forecast(fit.arima, h=n.ahead)    #预测
  #print(fore)
  plot(fore)
  upper <- fore$upper[,'95%']
  lower <- fore$lower[,'95%']
  trend <- as.numeric(fore$fitted)
  pred <- as.numeric(fore$mean)
  output <- data.frame(actual = c(x$total_redeem, rep(NA, n.ahead)),
                       trend = c(trend, rep(NA, n.ahead)),
                       #pred = c(trend, pred),
                       pred = c(rep(NA, nrow(x)), pred),
                       lower = c(rep(NA, nrow(x)), lower),                       
                       upper = c(rep(NA, nrow(x)), upper),                       
                       Date = c(x$date, max(x$date) + (1:n.ahead))  
  )
  return(output)
}
#result.arima
plotForecastResult <- function(x, title=NULL) {
  x <- x[order(x$Date),]
  max.val <- max(c(x$actual, x$upper), na.rm=T)
  min.val <- min(c(x$actual, x$lower), na.rm=T)
  plot(x$Date, x$actual, type="l", col="grey", main=title,
       xlab="Time", ylab="Exchange Rate",
       xlim=range(x$Date), ylim=c(min.val, max.val))
  grid()
  lines(x$Date, x$trend, col="yellowgreen")
  lines(x$Date, x$pred, col="green")
  lines(x$Date, x$lower, col="blue")
  lines(x$Date, x$upper, col="blue")
  legend("topleft", col=c("grey", "yellowgreen", "green", "blue"), lty=1,
         c("Actual", "Trend", "Forecast", "Lower/Upper Bound"))
}
#全量数据预测

pre_redeem <- forecastArima(data, n.ahead = 30)
plotForecastResult(pre_redeem, title = "Redeem forecasting with ARIMA")
#write.csv(pre_redeem,file="data/612/begin_4/arima_redeem.csv")

pre_purchase$Date <- as.Date(pre_purchase$Date)
pre_redeem$Date <- as.Date(pre_redeem$Date)
pre_purchase <- subset(pre_purchase,pre_purchase$Date >= "2014-09-01")
pre_redeem <- subset(pre_redeem,pre_redeem$Date >= "2014-09-01")

result <- data.frame(report_date=pre_redeem$Date,purchase=pre_purchase$pred,
                     redeem=pre_redeem$pred)
result$purchase <- as.integer(result$purchase)
#转换过来
result$redeem <- as.integer(result$redeem)
result$report_date <- format(result$report_date,"%Y%m%d")
result[8,2] <- as.integer(purchase_ratio * median(result$purchase))
result[8,3] <- as.integer(redeem_ratio * median(result$redeem))

write.table(result,file="data/620/begin_4/tc_comp_predict_table.csv",quote = F,
            col.names = F,row.names = F,sep = ",")
