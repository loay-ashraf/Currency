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

    private let items = Observable.of(["EUR", "USD", "GBP", "EGP", "SAR"])
    private let disposeBag: DisposeBag = .init()
    
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
        items
            .asDriver(onErrorJustReturn: [])
            .drive(fromCurrencyPickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        items
            .asDriver(onErrorJustReturn: [])
            .drive(toCurrencyPickerView.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: disposeBag)
        fromCurrencyPickerView.rx.modelSelected(String.self)
            .bind(onNext: { models in
                self.fromCurrencyButton.setTitle(models[0], for: .normal)
            })
            .disposed(by: disposeBag)
        toCurrencyPickerView.rx.modelSelected(String.self)
            .bind(onNext: { models in
                self.toCurrencyButton.setTitle(models[0], for: .normal)
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
