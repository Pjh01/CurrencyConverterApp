//
//  ExchangeRateData.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

struct ExchangeRateData {
  let currencyCode: String
  let country: String
  let rate: Double
  
  var formattedRate: String {
    return rate.formatted(format: "%.4f")
  }
}
