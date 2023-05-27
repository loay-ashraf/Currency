//
//  CurrencyConverterViewController.swift
//  Currency
//
//  Created by Loay Ashraf on 27/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyConverterViewController: UIViewController {
    private let viewModel: CurrencyConverterViewModel = {
        let dataSource = DefaultCurrencyConverterRemoteDataSource(networkManager: .shared)
        let repository = DefaultCurrencyConverterRepository(dataSource: dataSource)
        let fetchSymbolsUseCase = DefaultFetchSymbolsUseCase(repository: repository)
        let fetchConversionResultUseCase = DefaultFetchConversionResultUseCase(respository: repository)
        let viewModel = CurrencyConverterViewModel(fetchSymbolsUseCase: fetchSymbolsUseCase, fetchConversionResultUseCase: fetchConversionResultUseCase)
        return viewModel
    }()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var currencyConverterStackView: UIStackView!
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    @IBOutlet weak var swapCurrencyButton: UIButton!
    @IBOutlet weak var fromCurrencyValueLabel: UILabel!
    @IBOutlet weak var toCurrencyValueLabel: UILabel!
    @IBOutlet weak var currencyDetailsButton: UIButton!
    @IBOutlet weak var fromCurrencyPickerView: UIPickerView!
    @IBOutlet weak var toCurrencyPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        viewModel.currencySymbols
            .drive(fromCurrencyPickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        viewModel.currencySymbols
            .drive(toCurrencyPickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        fromCurrencyPickerView.rx.modelSelected(String.self)
            .bind(onNext: { models in
                self.fromCurrencyButton.setTitle(models[0], for: .normal)
                self.viewModel.selectedBaseCurrency.accept(models[0])
            })
            .disposed(by: disposeBag)
        viewModel.baseCurrencyAmount
            .bind(onNext: {
                self.fromCurrencyValueLabel.text = "\($0)"
            })
            .disposed(by: disposeBag)
        viewModel.targetCurrencyAmount
            .drive(onNext: {
                self.toCurrencyValueLabel.text = "\($0)"
            })
            .disposed(by: disposeBag)
        toCurrencyPickerView.rx.modelSelected(String.self)
            .bind(onNext: { models in
                self.toCurrencyButton.setTitle(models[0], for: .normal)
                self.viewModel.selectedTargetCurrency.accept(models[0])
            })
            .disposed(by: disposeBag)
        fromCurrencyButton.rx.tap
            .bind(onNext: {
                self.toCurrencyPickerView.isHidden = true
                self.fromCurrencyPickerView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        toCurrencyButton.rx.tap
            .bind(onNext: {
                self.fromCurrencyPickerView.isHidden = true
                self.toCurrencyPickerView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        viewModel.viewState.accept(.loading(loadType: .initial))
    }
    private func setupUI() {
        currencyConverterStackView.setRadiusAndShadow()
        currencyConverterStackView.backgroundColor = .lightGray
        fromCurrencyButton.tintColor = .white
        toCurrencyButton.tintColor = .white
        swapCurrencyButton.setRadiusAndShadow()
        swapCurrencyButton.backgroundColor = .black
        swapCurrencyButton.tintColor = .white
        currencyDetailsButton.setRadiusAndShadow()
        currencyDetailsButton.backgroundColor = .black
        currencyDetailsButton.tintColor = .white
    }
}
