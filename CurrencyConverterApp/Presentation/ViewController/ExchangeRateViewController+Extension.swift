//
//  ExchangeRateViewController+Extension.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

extension ExchangeRateViewController: UITableViewDelegate {
  // 셀 선택 시 계산기 화면으로 이동
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedRate = exchangeRateViewModel.state.rates[indexPath.row]
    let calculatorVC = CalculatorViewController(viewModel: CalculatorViewModel(rateData: selectedRate))
    navigationController?.pushViewController(calculatorVC, animated: true)
  }
}

extension ExchangeRateViewController: UITableViewDataSource {
  // 섹션 내 셀 개수 반환
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return exchangeRateViewModel.state.rates.count
  }
  
  // 각 셀을 구성하고 즐겨찾기 버튼 액션 클로저 연결
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else { return UITableViewCell() }
    let rate = exchangeRateViewModel.state.rates[indexPath.row]
    cell.configureCell(rate)
    
    // 셀 내 즐겨찾기 버튼 클릭 시 처리
    cell.favoriteButtonTapped = { [weak self] in
      self?.exchangeRateViewModel.action?(.toggleFavorite(rate.currencyCode))
    }
    return cell
  }
}

extension ExchangeRateViewController: UISearchBarDelegate {
  // 텍스트가 바뀔 때마다 ViewModel에 검색 요청
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    exchangeRateViewModel.action?(.search(searchText))
  }
  
  // 검색 버튼 클릭 시 호출: 키보드 내리기
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}
