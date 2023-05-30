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
    // MARK: - Properties
    var viewModel: CurrencyConverterViewModel?
    weak var coordinator: AppCoordinator?
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    // MARK: - UI Outlets
    @IBOutlet weak var currencyConverterStackView: UIStackView!
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    @IBOutlet weak var swapCurrencyButton: UIButton!
    @IBOutlet weak var currencyDetailsButton: UIButton!
    @IBOutlet weak var fromCurrencyPickerView: UIPickerView!
    @IBOutlet weak var toCurrencyPickerView: UIPickerView!
    @IBOutlet weak var fromCurrencyAmountTextField: UITextField!
    @IBOutlet weak var toCurrencyAmountTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupUIBindings()
        startLoading()
    }
    // MARK: - Instance Methods
    
    /// sets up UI by adding corner radius and drop shadows
    private func setupUI() {
        // Setup navigation title
        navigationItem.title = "Currency Converter"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        // Setup view styles (colors, shadows and corner radii)
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
        setupKeyboardUI()
    }
    
    /// sets up keyboard UI by adding toolbar with "Done" button
    private func setupKeyboardUI() {
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        done.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.fromCurrencyAmountTextField.resignFirstResponder()
                self?.toCurrencyAmountTextField.resignFirstResponder()
                self?.fromCurrencyAmountTextField.inputView = nil
                self?.toCurrencyAmountTextField.inputView = nil
            })
            .disposed(by: disposeBag)
        bar.items = [done]
        bar.sizeToFit()
        fromCurrencyAmountTextField.inputAccessoryView = bar
        toCurrencyAmountTextField.inputAccessoryView = bar
    }
    
    /// sets up UI reacive bindings for inputs and outputs
    private func setupUIBindings() {
        setupInputBindings()
        setupOutputBindings()
    }
    
    /// sets up UI reacive bindings for inputs
    private func setupInputBindings() {
        guard let viewModel = viewModel else { return }
        fromCurrencyButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.toCurrencyPickerView.isHidden = true
                self?.fromCurrencyPickerView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        toCurrencyButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.fromCurrencyPickerView.isHidden = true
                self?.toCurrencyPickerView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        fromCurrencyPickerView.rx.modelSelected(String.self)
            .compactMap({ $0.first })
            .bind(to: viewModel.selectedBaseCurrency)
            .disposed(by: disposeBag)
        toCurrencyPickerView.rx.modelSelected(String.self)
            .compactMap({ $0.first })
            .bind(to: viewModel.selectedTargetCurrency)
            .disposed(by: disposeBag)
        fromCurrencyAmountTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(fromCurrencyAmountTextField.rx.text.orEmpty)
            .map({ $0.isEmpty ? "0.0" : $0 })
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .compactMap({ Double($0) })
            .do(onNext: { print($0) })
            .bind(to: viewModel.baseCurrencyAmountInput)
            .disposed(by: disposeBag)
        toCurrencyAmountTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(toCurrencyAmountTextField.rx.text.orEmpty)
            .map({ $0.isEmpty ? "0.0" : $0 })
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .compactMap({ Double($0) })
            .do(onNext: { print($0) })
            .bind(to: viewModel.targetCurrencyAmountInput)
            .disposed(by: disposeBag)
        swapCurrencyButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.swapCurrenciesAction()
            })
            .disposed(by: disposeBag)
        currencyDetailsButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let baseCurrency = self?.viewModel?.selectedBaseCurrency.value,
                      let targetCurrency = self?.viewModel?.selectedTargetCurrency.value else { return }
                self?.coordinator?.trigger(.currencyDetails(baseCurrency: baseCurrency, targetCurrency: targetCurrency))
            })
            .disposed(by: disposeBag)
    }
    
    /// sets up UI reacive bindings for outputs
    private func setupOutputBindings() {
        viewModel?.viewState
            .map({ [.loading(loadType: .initial), .loading(loadType: .baseConversion), .loading(loadType: .targetConversion)].contains($0) })
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel?.error
            .drive(onNext: { [weak self] in
                self?.presentError($0)
            })
            .disposed(by: disposeBag)
        viewModel?.currencySymbols
        // After picker view is populated, we select default currency row.
            .do(afterNext: { [weak self] symbols in
                let defaultFromCurrency = Constants.defaultBaseCurrency
                guard let defaultCurrencyIndex = symbols.firstIndex(of: defaultFromCurrency) else { return }
                self?.fromCurrencyPickerView.selectRow(defaultCurrencyIndex, inComponent: 0, animated: false)
            })
            .drive(fromCurrencyPickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        viewModel?.currencySymbols
        // After picker view is populated, we select default currency row.
            .do(afterNext: { [weak self] symbols in
                let defaultToCurrency = Constants.defaultTargetCurrency
                guard let defaultCurrencyIndex = symbols.firstIndex(of: defaultToCurrency) else { return }
                self?.toCurrencyPickerView.selectRow(defaultCurrencyIndex, inComponent: 0, animated: false)
            })
            .drive(toCurrencyPickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        viewModel?.selectedBaseCurrency
            .bind(to: fromCurrencyButton.rx.title())
            .disposed(by: disposeBag)
        viewModel?.selectedTargetCurrency
            .bind(to: toCurrencyButton.rx.title())
            .disposed(by: disposeBag)
        viewModel?.baseCurrencyAmountOutput
            .map({ "\($0)" })
            .drive(fromCurrencyAmountTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel?.targetCurrencyAmountOutput
            .map({ "\($0)" })
            .drive(toCurrencyAmountTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    /// start initial loading
    private func startLoading() {
        // mutate view state to trigger loading
        viewModel?.viewState.accept(.loading(loadType: .initial))
    }
    
    /// swap currencies symbols and amounts
    private func swapCurrenciesAction() {
        guard let viewModel = viewModel else { return }
        let baseCurrency = viewModel.selectedBaseCurrency.value
        let targetCurrency = viewModel.selectedTargetCurrency.value
        let baseCurrencyIndex = fromCurrencyPickerView.selectedRow(inComponent: 0)
        let targetCurrencyIndex = toCurrencyPickerView.selectedRow(inComponent: 0)
        let baseCurrencyAmount = fromCurrencyAmountTextField.text ?? "0.0"
        let targetCurrencyAmount = toCurrencyAmountTextField.text ?? "0.0"
        // Swap view model input values
        viewModel.selectedBaseCurrency.accept(targetCurrency)
        viewModel.selectedTargetCurrency.accept(baseCurrency)
        viewModel.baseCurrencyAmountInput.accept(Double(targetCurrencyAmount) ?? 0.0)
        viewModel.targetCurrencyAmountInput.accept(Double(baseCurrencyAmount) ?? 0.0)
        // Swap UI values
        fromCurrencyButton.setTitle(targetCurrency, for: .normal)
        toCurrencyButton.setTitle(baseCurrency, for: .normal)
        fromCurrencyAmountTextField.text = targetCurrencyAmount
        toCurrencyAmountTextField.text = baseCurrencyAmount
        fromCurrencyPickerView.selectRow(targetCurrencyIndex, inComponent: 0, animated: false)
        toCurrencyPickerView.selectRow(baseCurrencyIndex, inComponent: 0, animated: false)
    }
}
