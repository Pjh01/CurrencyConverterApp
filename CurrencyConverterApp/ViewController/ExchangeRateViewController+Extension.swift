//
//  ExchangeRateViewController+Extension.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

extension ExchangeRateViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedRate = exchangeRateViewModel.state.rates[indexPath.row]
    let calculatorVC = CalculatorViewController(viewModel: CalculatorViewModel(rateData: selectedRate))
    navigationController?.pushViewController(calculatorVC, animated: true)
  }
}

extension ExchangeRateViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return exchangeRateViewModel.state.rates.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else { return UITableViewCell() }
    cell.configureCell(exchangeRateViewModel.state.rates[indexPath.row])
    return cell
  }
}

extension ExchangeRateViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    exchangeRateViewModel.action?(.search(searchText))
  }
  
  // 검색 버튼 클릭 시 호출: 키보드 내리기
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}
