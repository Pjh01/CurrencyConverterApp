//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

class ExchangeRateViewController: UIViewController {
  
  let exchangeRateView = ExchangeRateView()
  let exchangeRateViewModel = ExchangeRateViewModel(coreDataManager: CoreDataManager())
  
  override func loadView() {
    self.view = exchangeRateView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupDelegates()
    bindViewModel()
    exchangeRateViewModel.action?(.fetch)
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    navigationItem.title = "환율 정보"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }
  
  private func setupDelegates() {
    exchangeRateView.tableView.delegate = self
    exchangeRateView.tableView.dataSource = self
    exchangeRateView.searchBar.delegate = self
  }
  
  private func bindViewModel() {
    exchangeRateViewModel.onStateChange = { [weak self] state in
      DispatchQueue.main.async {
        if let message = state.errorMessage {
          self?.showAlert(message)
        }
        
        self?.exchangeRateView.updateTableViewBackground(isEmpty: state.isEmpty)
        self?.exchangeRateView.tableView.reloadData()
      }
    }
  }
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

