//
//  ExchangeRateViewController+Extension.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

extension ExchangeRateViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

extension ExchangeRateViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else { return UITableViewCell() }
    cell.configureCell(filteredData[indexPath.row])
    return cell
  }
}

extension ExchangeRateViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredData = searchText.isEmpty
    ? allData
    : allData.filter { $0.currencyCode.localizedCaseInsensitiveContains(searchText) || $0.country.localizedCaseInsensitiveContains(searchText)}
    
    exchangeRateView.updateTableViewBackground(isEmpty: filteredData.isEmpty)
    exchangeRateView.tableView.reloadData()
  }
  
  // 검색 버튼 클릭 시 호출: 키보드 내리기
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}
