//
//  CoinDetailViewController.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

import Charts
import RxSwift
import SnapKit
import Then

final class CoinDetailViewController: UIViewController {

  // MARK: Payload
  
  struct Payload {
    let orderCurrency: OrderCurrency
    let paymentCurrency: PaymentCurrency
  }


  // MARK: Properties
  
  let coinDetailViewModel: CoinDetailViewModel
  private let payload: Payload
  private let disposeBag: DisposeBag
  
  private let coinChartView: CoinChartView
  private let segmentedCategoryView: SegmentedCategoryView
  private let timeUnitChangeButton: UIButton

  
  // MARK: Initializers

  init(payload: Payload) {
    self.payload = payload
    let categoryItems = ["호가", "차트"]
    self.segmentedCategoryView = SegmentedCategoryView(items: categoryItems, fontSize: 14)
    self.coinDetailViewModel = CoinDetailViewModel(payload: payload)
    self.coinChartView = CoinChartView()
    self.timeUnitChangeButton = UIButton()
    self.disposeBag = DisposeBag()
    
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.layout()
    self.attribute()
    self.configure()
  }
  
  private func layout() {
    [self.coinChartView,
     self.segmentedCategoryView,
     self.timeUnitChangeButton].forEach { self.view.addSubview($0) }

    self.segmentedCategoryView.snp.makeConstraints {
      $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }
    
    self.coinChartView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.segmentedCategoryView.snp.bottom)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.timeUnitChangeButton.snp.makeConstraints {
      $0.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }
  }
  
  private func attribute() {
    self.title = payload.orderCurrency.koreanName
    
    self.timeUnitChangeButton.do {
      $0.setTitleColor(.black, for: .normal)
    }
  }
  
  private func configure() {
    self.bind()
  }

  private func bind() {
    self.coinChartView.bind(viewModel: self.coinDetailViewModel.coinChartViewModel)

    self.timeUnitChangeButton.rx.tap
      .bind(to: self.coinDetailViewModel.tapSelectTimeUnitButton)
      .disposed(by: self.disposeBag)
    
    self.coinDetailViewModel.selectedTimeUnit
      .bind {
        self.timeUnitChangeButton.setTitle($0.rawValue, for: .normal)
      }
      .disposed(by: self.disposeBag)
  }
}
