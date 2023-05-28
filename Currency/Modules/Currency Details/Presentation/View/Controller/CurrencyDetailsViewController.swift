//
//  CurrencyDetailsViewController.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyDetailsViewController: UIViewController {
//    var baseCurrency: String?
//    var targetCurrency: String?
//    private let viewModel: CurrencyDetailsViewModel = {
//        let dataSource = DefaultCurrencyDetailsRemoteDataSource(networkManager: .shared)
//        let repository = DefaultCurrencyDetailsRepository(dataSource: dataSource)
//        let fetchRateHistoryUseCase = DefaultFetchRateHistoryUseCase(repository: repository)
//        let viewModel = CurrencyConverterViewModel(baseCurrency: baseCurrency ?? "EUR", targetCurrency: targetCurrency ?? "USD", fetchRateHistoryUseCase: fetchRateHistoryUseCase)
//        return viewModel
//    }()
    var viewModel: CurrencyDetailsViewModel?
    private let disposeBag = DisposeBag()
    @IBOutlet weak var rateHistoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setupUI()
        rateHistoryTableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        setupUIBindings()
        startLoading()
    }
    private func setupUIBindings() {
        setupInputBindings()
        setupOutputBindings()
    }
    private func setupInputBindings() {
//        fromCurrencyButton.rx.tap
//            .bind(onNext: {
//                self.toCurrencyPickerView.isHidden = true
//                self.fromCurrencyPickerView.isHidden.toggle()
//            })
//            .disposed(by: disposeBag)
//        toCurrencyButton.rx.tap
//            .bind(onNext: {
//                self.fromCurrencyPickerView.isHidden = true
//                self.toCurrencyPickerView.isHidden.toggle()
//            })
//            .disposed(by: disposeBag)
//        fromCurrencyPickerView.rx.modelSelected(String.self)
//            .compactMap({ $0.first })
//            .bind(to: viewModel.selectedBaseCurrency)
//            .disposed(by: disposeBag)
//        toCurrencyPickerView.rx.modelSelected(String.self)
//            .compactMap({ $0.first })
//            .bind(to: viewModel.selectedTargetCurrency)
//            .disposed(by: disposeBag)
//        fromCurrencyAmountTextField.rx
//            .controlEvent(.editingChanged)
//            .withLatestFrom(fromCurrencyAmountTextField.rx.text.orEmpty)
//            .map({ $0.isEmpty ? "0.0" : $0 })
//            .distinctUntilChanged()
//            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
//            .compactMap({ Double($0) })
//            .do(onNext: { print($0) })
//            .bind(to: viewModel.baseCurrencyAmountInput)
//            .disposed(by: disposeBag)
//        toCurrencyAmountTextField.rx
//            .controlEvent(.editingChanged)
//            .withLatestFrom(toCurrencyAmountTextField.rx.text.orEmpty)
//            .map({ $0.isEmpty ? "0.0" : $0 })
//            .distinctUntilChanged()
//            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
//            .compactMap({ Double($0) })
//            .do(onNext: { print($0) })
//            .bind(to: viewModel.targetCurrencyAmountInput)
//            .disposed(by: disposeBag)
//        swapCurrencyButton.rx.tap
//            .bind(onNext: {
//                self.swapCurrenciesAction()
//            })
//            .disposed(by: disposeBag)
    }
    private func setupOutputBindings() {
        viewModel?.rateHistory
            .drive(rateHistoryTableView.rx.items(cellIdentifier: "Cell", cellType: TableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = item.date
                cell.detailTextLabel?.text = "1.0 \(item.base) -> \(item.value) \(item.target)"
            }
            .disposed(by: disposeBag)
    }
    private func startLoading() {
        viewModel?.viewState.accept(.loading(loadType: .initial))
    }
}

class TableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
