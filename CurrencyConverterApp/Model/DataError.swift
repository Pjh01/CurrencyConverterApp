//
//  DataError.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/14/25.
//

import Foundation

// 네트워크 요청 중 발생할 수 있는 오류
enum DataError: Error, LocalizedError {
  case invalidURL
  case parsingFailed
  case requestFailed
  
  // 사용자에게 보여줄 에러 메시지
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
