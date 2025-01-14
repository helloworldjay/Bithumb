//
//  CoinListViewCell.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/20.
//

import UIKit

import SnapKit

final class CoinListViewCell: UITableViewCell {
  
  // MARK: Properties
  
  private let coinTitleLabel = UILabel()
  private let tickerLabel = UILabel()
  private let titleStackView = UIStackView()
  private let currentPriceLabel = UILabel()
  private let priceChangedRatioLabel = UILabel()
  private let priceDifferenceLabel = UILabel()
  private let changesStackView = UIStackView()
  private let transactionAmountLabel = UILabel()


  // MARK: Initializers

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.attribute()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func attribute() {
    self.coinTitleLabel.do {
      $0.font = .systemFont(ofSize: 14)
      $0.numberOfLines = 2
      $0.lineBreakMode = .byCharWrapping
    }
    
    self.tickerLabel.do {
      $0.font = .systemFont(ofSize: 10)
      $0.textColor = .darkGray
    }
    
    self.titleStackView.do {
      $0.axis = .vertical
      $0.spacing = 2
    }
    
    self.currentPriceLabel.do {
      $0.font = .systemFont(ofSize: 14)
    }
    
    self.priceChangedRatioLabel.do {
      $0.font = .systemFont(ofSize: 14)
      $0.textAlignment = .right
    }
    
    self.priceDifferenceLabel.do {
      $0.font = .systemFont(ofSize: 10)
      $0.textAlignment = .right
    }
    
    self.changesStackView.do {
      $0.axis = .vertical
      $0.spacing = 2
    }
    
    self.transactionAmountLabel.do {
      $0.font = .systemFont(ofSize: 14)
    }
  }
  
  private func layout() {
    [self.titleStackView, self.currentPriceLabel, self.changesStackView, self.transactionAmountLabel].forEach {
      self.contentView.addSubview($0)
    }
    
    [self.coinTitleLabel, self.tickerLabel].forEach {
      self.titleStackView.addArrangedSubview($0)
    }
    
    [self.priceChangedRatioLabel, self.priceDifferenceLabel].forEach {
      self.changesStackView.addArrangedSubview($0)
    }
    
    self.titleStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(12)
      $0.width.equalToSuperview().multipliedBy(0.2)
    }
    
    self.currentPriceLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.coinTitleLabel)
      $0.trailing.equalToSuperview().multipliedBy(0.5)
    }
    
    self.changesStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().multipliedBy(0.7)
    }
    
    self.transactionAmountLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.coinTitleLabel)
      $0.trailing.equalToSuperview().inset(12)
    }
  }
  
  func setData(with data: CoinListViewCellData) {
    self.transactionAmountLabel.text = self.transactionAmountText(with: data)
    self.coinTitleLabel.text = data.coinName
    self.tickerLabel.text = data.ticker
    self.currentPriceLabel.attributedText = self.currentPriceText(with: data)
    self.priceDifferenceLabel.attributedText = self.priceDifferenceText(with: data)
    self.priceChangedRatioLabel.attributedText = self.priceChangedRatioText(with: data)
  }

  func hasSameTickerName(with tickerName: String) -> Bool {
    guard let cellTickerName = self.tickerLabel.text else { return false }
    return cellTickerName == tickerName
  }
}


// MARK: - Edit PriceData Text

extension CoinListViewCell: PriceDataTextEditable {
  func transactionAmountText(with cryptocurrencyPriceData: CoinListViewCellData) -> String? {
    guard let transactionAmount = Double(cryptocurrencyPriceData.transactionAmount),
          let millionUnitText = String(Int(floor(transactionAmount / 1000000))).convertToDecimalText() else {
            return nil
          }
    return millionUnitText + "백만"
  }
}
