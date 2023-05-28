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
        let fetchConversionResultUseCase = DefaultFetchConversionResultUseCase(repository: repository)
        let viewModel = CurrencyConverterViewModel(fetchSymbolsUseCase: fetchSymbolsUseCase, fetchConversionResultUseCase: fetchConversionResultUseCase)
        return viewModel
    }()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var currencyConverterStackView: UIStackView!
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    @IBOutlet weak var swapCurrencyButton: UIButton!
    @IBOutlet weak var currencyDetailsButton: UIButton!
    @IBOutlet weak var fromCurrencyPickerView: UIPickerView!
    @IBOutlet weak var toCurrencyPickerView: UIPickerView!
    @IBOutlet weak var fromCurrencyAmountTextField: UITextField!
    @IBOutlet weak var toCurrencyAmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        viewModel.currencySymbols
            .do(afterNext: { symbols in
                let defaultToCurrency = "EUR"
                guard let defaultCurrencyIndex = symbols.firstIndex(of: defaultToCurrency) else { return }
                self.fromCurrencyPickerView.selectRow(defaultCurrencyIndex, inComponent: 0, animated: false)
            })
            .drive(fromCurrencyPickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        viewModel.currencySymbols
            .do(afterNext: { symbols in
                let defaultToCurrency = "USD"
                guard let defaultCurrencyIndex = symbols.firstIndex(of: defaultToCurrency) else { return }
                self.toCurrencyPickerView.selectRow(defaultCurrencyIndex, inComponent: 0, animated: false)
            })
            .drive(toCurrencyPickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        viewModel.selectedBaseCurrency
            .bind(to: fromCurrencyButton.rx.title())
            .disposed(by: disposeBag)
        viewModel.selectedTargetCurrency
            .bind(to: toCurrencyButton.rx.title())
            .disposed(by: disposeBag)
        fromCurrencyPickerView.rx.modelSelected(String.self)
            .bind(onNext: { models in
                self.fromCurrencyButton.setTitle(models[0], for: .normal)
                self.viewModel.selectedBaseCurrency.accept(models[0])
            })
            .disposed(by: disposeBag)
        toCurrencyPickerView.rx.modelSelected(String.self)
            .bind(onNext: { models in
                self.toCurrencyButton.setTitle(models[0], for: .normal)
                self.viewModel.selectedTargetCurrency.accept(models[0])
            })
            .disposed(by: disposeBag)
        viewModel.baseCurrencyAmountOutput
            .map({ "\($0)" })
            .drive(fromCurrencyAmountTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel.targetCurrencyAmountOutput
            .map({ "\($0)" })
            .drive(toCurrencyAmountTextField.rx.text)
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
        fromCurrencyAmountTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(fromCurrencyAmountTextField.rx.text.orEmpty)
            .map({ $0.isEmpty ? "0.0" : $0 })
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .compactMap({ Double($0) })
            .do(onNext: { print($0) })
            .bind(to: viewModel.baseCurrencyAmountInput)
            .disposed(by: disposeBag)
        toCurrencyAmountTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(toCurrencyAmountTextField.rx.text.orEmpty)
            .map({ $0.isEmpty ? "0.0" : $0 })
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .compactMap({ Double($0) })
            .do(onNext: { print($0) })
            .bind(to: viewModel.targetCurrencyAmountInput)
            .disposed(by: disposeBag)
        swapCurrencyButton.rx.tap
                .bind(onNext: {
                    let baseCurrency = self.viewModel.selectedBaseCurrency.value
                    let targetCurrency = self.viewModel.selectedTargetCurrency.value
                    let baseCurrencyIndex = self.fromCurrencyPickerView.selectedRow(inComponent: 0)
                    let targetCurrencyIndex = self.toCurrencyPickerView.selectedRow(inComponent: 0)
                    let baseCurrencyAmount = self.fromCurrencyAmountTextField.text ?? "0.0"
                    let targetCurrencyAmount = self.toCurrencyAmountTextField.text ?? "0.0"
                    self.viewModel.selectedBaseCurrency.accept(targetCurrency)
                    self.viewModel.selectedTargetCurrency.accept(baseCurrency)
                    self.viewModel.baseCurrencyAmountInput.accept(Double(targetCurrencyAmount) ?? 0.0)
                    self.viewModel.targetCurrencyAmountInput.accept(Double(baseCurrencyAmount) ?? 0.0)
                    self.fromCurrencyButton.setTitle(targetCurrency, for: .normal)
                    self.toCurrencyButton.setTitle(baseCurrency, for: .normal)
                    self.fromCurrencyAmountTextField.text = targetCurrencyAmount
                    self.toCurrencyAmountTextField.text = baseCurrencyAmount
                    self.fromCurrencyPickerView.selectRow(targetCurrencyIndex, inComponent: 0, animated: false)
                    self.toCurrencyPickerView.selectRow(baseCurrencyIndex, inComponent: 0, animated: false)
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
        fromCurrencyAmountTextField.text = "1.0"
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        done.rx.tap
            .bind(onNext: { _ in
                self.fromCurrencyAmountTextField.resignFirstResponder()
                self.toCurrencyAmountTextField.resignFirstResponder()
                self.fromCurrencyAmountTextField.inputView = nil
                self.toCurrencyAmountTextField.inputView = nil
            })
            .disposed(by: disposeBag)
        bar.items = [done]
        bar.sizeToFit()
        fromCurrencyAmountTextField.inputAccessoryView = bar
        toCurrencyAmountTextField.inputAccessoryView = bar
    }
}
