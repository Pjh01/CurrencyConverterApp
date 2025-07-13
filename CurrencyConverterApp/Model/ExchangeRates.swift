//
//  ExchangeRates.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

struct ExchangeRates: Codable {
  let timeLastUpdateUnix: Int64
  let rates: [String: Double]
  
  enum CodingKeys: String, CodingKey {
    case timeLastUpdateUnix = "time_last_update_unix"
    case rates
  }
}
