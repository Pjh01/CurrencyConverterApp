//
//  DataService.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import Foundation

class DataService {
  
  func fetchData() async throws -> ExchangeRateResponse {
    let urlString = "https://open.er-api.com/v6/latest/USD"
    
    // URL 유효성 확인
    guard let url = URL(string: urlString) else {
      throw DataError.invalidURL
    }
    
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      // HTTP 상태코드가 정상(200~299)인지 확인
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        throw DataError.parsingFailed
      }
      
      // JSON -> 모델 파싱
      let exchangeRateData = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
      
      return exchangeRateData
      
    } catch {
      throw DataError.requestFailed
    }
  }
}
