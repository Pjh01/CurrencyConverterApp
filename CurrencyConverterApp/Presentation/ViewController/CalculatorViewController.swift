//
//  CalculatorViewController.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

// 환율 계산기 화면의 ViewController
class CalculatorViewController: UIViewController {
  
  private var calculatorView = CalculatorView()
  private let calculatorViewModel: CalculatorViewModel
  
  // ViewModel을 외부에서 주입받는 방식
  init(viewModel: CalculatorViewModel) {
    self.calculatorViewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // loadView 단계에서 커스텀 View 설정
  override func loadView() {
    view = calculatorView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()
    setupAction()
  }
  
  // 화면이 나타날 때마다 마지막 방문 화면 저장 요청
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    calculatorViewModel.action?(.saveLastVisitedScreen)
  }
  
  // UI 스타일 설정 및 초기 데이터 구성
  private func setupUI() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "환율 계산기"
    calculatorView.configure(data: calculatorViewModel.rateData)
  }
  
  // ViewModel이 상태 변경을 알리면 UI 업데이트
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
  
  // 버튼 액션과 ViewModel의 액션을 연결
  private func setupAction() {
    calculatorView.convertButtonTapped = { [weak self] input in
      self?.calculatorViewModel.action?(.convert(input))
    }
  }
  
  // 에러 메시지를 UIAlert으로 표시
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

