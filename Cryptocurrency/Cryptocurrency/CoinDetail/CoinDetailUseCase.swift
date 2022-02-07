//
//  CoinDetailUseCase.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation

import RxSwift

protocol CoinDetailUseCaseLogic {
  func fetchTicker(orderCurrency: OrderCurrency,
                   paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>>
  func tickerResponse(result: Result<AllTickerResponse,
                      APINetworkError>) -> AllTickerResponse?
  func tickerData(response: AllTickerResponse?) -> CoinDetailData?
  func fetchCandleStick(orderCurrency: OrderCurrency,
                        paymentCurrency: PaymentCurrency,
                        timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>>
  func candleStickResponse(result: Result<CandleStickResponse,
                           APINetworkError>) -> CandleStickResponse?
  func chartData(response: CandleStickResponse?) -> [ChartData]
}

final class CoinDetailUseCase: CoinDetailUseCaseLogic {
  
  // MARK: Properties
  
  let network: NetworkManagerLogic
  
  
  // MARK: Initializer
  
  init(network: NetworkManagerLogic = NetworkManager()) {
    self.network = network
  }
  
  
  // MARK: Network Logic
  
  func fetchTicker(orderCurrency: OrderCurrency,
                   paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>> {
    return network.fetchTickerData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
  }
  
  func tickerResponse(result: Result<AllTickerResponse,
                      APINetworkError>) -> AllTickerResponse? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func tickerData(response: AllTickerResponse?) -> CoinDetailData? {
    guard let data = response?.data.first else {
      return nil
    }
    return CoinDetailData(
      currentPrice: data.value.closingPrice,
      priceChangedRatio: data.value.fluctateRate24H,
      priceDifference: data.value.fluctate24H
    )
  }
  
  func fetchCandleStick(orderCurrency: OrderCurrency,
                        paymentCurrency: PaymentCurrency,
                        timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>> {
    return network.fetchCandleStickData(orderCurrency: orderCurrency,
                                        paymentCurrency: paymentCurrency,
                                        timeUnit: timeUnit)
  }

  func candleStickResponse(result: Result<CandleStickResponse,
                           APINetworkError>) -> CandleStickResponse? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func chartData(response: CandleStickResponse?) -> [ChartData] {
    guard let response = response else {
      return []
    }
    return response.chartData
  }
}