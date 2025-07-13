//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

// 환율 리스트 화면을 구성하는 ViewController
class ExchangeRateViewController: UIViewController {
  
  let exchangeRateView = ExchangeRateView()
  let exchangeRateViewModel = ExchangeRateViewModel()
  
  // 커스텀 뷰 지정
  override func loadView() {
    self.view = exchangeRateView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupDelegates()
    bindViewModel()
    exchangeRateViewModel.action?(.fetch)   // 초기 환율 데이터 가져오기
  }
  
  // 화면에 다시 진입했을 때 마지막 방문 정보 저장
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    exchangeRateViewModel.action?(.saveLastVisitedScreen)
  }
  
  // UI 설정
  private func setupUI() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }
  
  // delegate 연결
  private func setupDelegates() {
    exchangeRateView.tableView.delegate = self
    exchangeRateView.tableView.dataSource = self
    exchangeRateView.searchBar.delegate = self
  }
  
  // ViewModel 바인딩
  private func bindViewModel() {
    exchangeRateViewModel.onStateChange = { [weak self] state in
      DispatchQueue.main.async {
        if let message = state.errorMessage {
          self?.showAlert(message)
        }
        
        // 검색 결과 없을 때 배경 처리
        self?.exchangeRateView.updateTableViewBackground(isEmpty: state.isEmpty)
        
        // 테이블 갱신
        self?.exchangeRateView.tableView.reloadData()
      }
    }
  }
  
  // 사용자에게 오류 표시
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    present(alert, animated: true)
  }
}

