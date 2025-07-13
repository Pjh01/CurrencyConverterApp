//
//  RateChangeStatus.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/13/25.
//

import Foundation

// 환율 변화 상태를 나타내는 열거형
enum RateChangeStatus: String {
  case up
  case down
  case same
  
  // 상태에 따라 아이콘 반환
  var icon: String {
    switch self {
    case .up: return "🔼"
    case .down: return "🔽"
    case .same: return ""
    }
  }
}
