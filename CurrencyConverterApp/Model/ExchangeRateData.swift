//
//  ExchangeRateData.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import Foundation

struct ExchangeRateData {
  let currencyCode: String
  let country: String
  let rate: Double
  var isFavorite: Bool = false
  var changeStatus: RateChangeStatus = .same
  
  var formattedRate: String {
    return rate.formatted(format: "%.4f")
  }
}
