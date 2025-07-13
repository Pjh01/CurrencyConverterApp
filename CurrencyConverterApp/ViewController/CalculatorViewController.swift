//
//  CalculatorViewController.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

class CalculatorViewController: UIViewController {
  
  private var calculatorView = CalculatorView()
  private let calculatorViewModel: CalculatorViewModel
  
  init(viewModel: CalculatorViewModel) {
    self.calculatorViewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = calculatorView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()
    setupAction()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "환율 계산기"
    calculatorView.configure(data: calculatorViewModel.rateData)
  }
  
  private func bindViewModel() {
    calculatorViewModel.onStateChange = { [weak self] state in
      DispatchQueue.main.async {
        if let message = state.errorMessage {
          self?.showAlert(message)
        } else {
          self?.calculatorView.resultLabel.text = state.resultText
        }
      }
    }
  }
  
  private func setupAction() {
    calculatorView.convertButtonTapped = { [weak self] input in
      self?.calculatorViewModel.action?(.convert(input))
    }
  }
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

