//
//  ExchangeRateCell.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit
import SnapKit

final class ExchangeRateCell: UITableViewCell {
  
  static let id = "ExchangeRateCell"
  
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .label
    return label
  }()
  
  private let countryLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private let labelStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    return stackView
  }()
  
  private let rateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textAlignment = .right
    label.textColor = .label //.black
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
  
  private func setupUI() {
    contentView.backgroundColor = .systemBackground
    [currencyLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0) }
    [labelStackView, rateLabel].forEach { contentView.addSubview($0) }
    
    labelStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
    }
    
    rateLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
      $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
      $0.width.equalTo(120)
    }
  }
  
  public func configureCell(_ data: ExchangeRateData) {
    currencyLabel.text = data.currencyCode
    countryLabel.text = data.country
    rateLabel.text = data.formattedRate
  }
}
