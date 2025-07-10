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
    return allData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else { return UITableViewCell() }
    cell.configureCell(allData[indexPath.row])
    return cell
  }
}
