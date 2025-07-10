//
//  DataService.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import Foundation

enum DataError: Error, LocalizedError {
  case invalidURL
  case parsingFailed
  case requestFailed
  
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "URL 주소가 잘못되었습니다."
    case .parsingFailed:
      return "데이터를 불러올 수 없습니다."
    case .requestFailed:
      return "데이터 요청에 실패했습니다."
    }
  }
}

class DataService {
  
  func fetchCurrencyData() async throws -> [ExchangeRateData] {
    let urlString = "https://open.er-api.com/v6/latest/USD"
    guard let url = URL(string: urlString) else {
      throw DataError.invalidURL
    }
    
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      // 상태코드 확인 (200 OK 아니면 에러 처리)
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        throw DataError.parsingFailed
      }
      
      // 디코딩
      let currencyData = try JSONDecoder().decode(ExchangeRates.self, from: data)
      
      let rates = currencyData.rates.map { currencyCode, rate in
        ExchangeRateData(
          currencyCode: currencyCode,
          country: CountryData[currencyCode] ?? "Unknown",
          rate: rate,
        )
      }
      
      return rates.sorted { $0.currencyCode < $1.currencyCode }
      
    } catch {
      throw DataError.requestFailed
    }
  }
}
