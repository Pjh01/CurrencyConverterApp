//
//  RateChangeStatus.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/13/25.
//

import Foundation

enum RateChangeStatus: String {
  case up
  case down
  case same
  
  var icon: String {
    switch self {
    case .up: return "🔼"
    case .down: return "🔽"
    case .same: return ""
    }
  }
}
