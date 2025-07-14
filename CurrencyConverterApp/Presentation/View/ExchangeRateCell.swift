//
//  ExchangeRateCell.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit
import SnapKit

// 환율 정보를 표시하는 테이블뷰 셀
final class ExchangeRateCell: UITableViewCell {
  
  static let id = "ExchangeRateCell"  // 셀 식별자
  
  var favoriteButtonTapped: (() -> Void)?
  
  // 통화 코드
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .label
    return label
  }()
  
  // 국가명
  private let countryLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .secondaryLabel
    return label
  }()
  
  // 통화/국가 정보를 담는 수직 스택 뷰
  private let labelStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    return stackView
  }()
  
  // 환율
  private let rateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textAlignment = .right
    label.textColor = .label
    return label
  }()
  
  // 환율 변화 상태
  private let rateChangeLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 16)
      label.textAlignment = .center
      return label
  }()
  
  // 즐겨찾기 버튼
  private lazy var favoriteButton: UIButton = {
    let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
    let button = UIButton()
    button.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
    button.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .selected)
    button.tintColor = .systemYellow
    button.addTarget(self, action: #selector(favoriteButtonTap), for: .touchUpInside)
    return button
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 셀의 구분선 여백 조정
  override func layoutSubviews() {
    super.layoutSubviews()
    separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
  
  // UI 컴포넌트 설정 및 제약조건
  private func setupUI() {
    contentView.backgroundColor = .systemBackground
    [currencyLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0) }
    [labelStackView, rateLabel, rateChangeLabel, favoriteButton].forEach { contentView.addSubview($0) }
    
    labelStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
    }
    
    rateLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
      $0.width.equalTo(120)
    }
    
    rateChangeLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(20)
      $0.leading.equalTo(rateLabel.snp.trailing).offset(8)
    }
    
    favoriteButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(rateChangeLabel.snp.trailing).offset(16)
    }
  }
  
  public func configureCell(_ data: ExchangeRateData) {
    currencyLabel.text = data.currencyCode
    countryLabel.text = data.country
    rateLabel.text = data.formattedRate
    rateChangeLabel.text = data.changeStatus.icon
    favoriteButton.isSelected = data.isFavorite
  }
  
  // 즐겨찾기 버튼 클릭 이벤트 처리
  @objc private func favoriteButtonTap() {
    favoriteButtonTapped?()
  }
}
