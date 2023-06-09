//
//  CurrencyDetailsViewController.swift
//  Currency
//
//  Created by Loay Ashraf on 28/05/2023.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class CurrencyDetailsViewController: UIViewController {
    // MARK: - Properties
    var viewModel: CurrencyDetailsViewModel?
    weak var coordinator: AppCoordinator?
    // MARK: - Private Properties
    private var chartViewBindingMediator = RxBindingMediator<[CurrencyRateHistoryRecordPresentationModel]>(input: .init(value: []), output: [])
    private let disposeBag = DisposeBag()
    // MARK: - UI Outlets
    @IBOutlet weak var rateHistorychartView: UIView!
    @IBOutlet weak var rateHistoryTableView: UITableView!
    @IBOutlet weak var ratesTableView: UITableView!
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
    
    /// sets up UI by registering cells for table views and adding border and corner radius
    private func setupUI() {
        // Setup navigation title
        navigationItem.title = "Currency Details"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        // Register cells fot table views
        rateHistoryTableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        ratesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Setup table view styles (colors, shadows and corner radii)
        rateHistoryTableView.layer.masksToBounds = true
        rateHistoryTableView.layer.borderColor = UIColor.lightGray.cgColor
        rateHistoryTableView.layer.borderWidth = 2.0
        rateHistoryTableView.layer.cornerCurve = .continuous
        rateHistoryTableView.layer.cornerRadius = 10.0
        ratesTableView.layer.masksToBounds = true
        ratesTableView.layer.borderColor = UIColor.lightGray.cgColor
        ratesTableView.layer.borderWidth = 2.0
        ratesTableView.layer.cornerCurve = .continuous
        ratesTableView.layer.cornerRadius = 10.0
        // Setup chart view (inject binding mediator and activate required constraints)
        let chartView = CurrencyRateHistoryChartView(bindingMediator: chartViewBindingMediator)
        let chartHostingController = UIHostingController(rootView: chartView)
        addChild(chartHostingController)
        rateHistorychartView.addSubview(chartHostingController.view)
        chartHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([chartHostingController.view.topAnchor.constraint(equalTo: rateHistorychartView.topAnchor),
                                     chartHostingController.view.bottomAnchor.constraint(equalTo: rateHistorychartView.bottomAnchor),
                                     chartHostingController.view.leadingAnchor.constraint(equalTo: rateHistorychartView.leadingAnchor),
                                     chartHostingController.view.trailingAnchor.constraint(equalTo: rateHistorychartView.trailingAnchor)])
    }
    
    /// sets up UI reacive bindings for inputs and outputs
    private func setupUIBindings() {
        setupOutputBindings()
    }
    
    /// sets up UI reacive bindings for outputs
    private func setupOutputBindings() {
        viewModel?.viewState
            .map({ [.loading(loadType: .initial)].contains($0) })
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel?.error
            .drive(onNext: { [weak self] in
                self?.presentError($0)
            })
            .disposed(by: disposeBag)
        viewModel?.rateHistory
            .drive(onNext: { [weak self] in
                let mappedData = $0.map {
                    CurrencyRateHistoryRecordPresentationModel(form: $0)
                }
                self?.chartViewBindingMediator.input.accept(mappedData)
            })
            .disposed(by: disposeBag)
        viewModel?.rateHistory
            .drive(rateHistoryTableView.rx.items(cellIdentifier: "Cell", cellType: TableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = item.date
                cell.detailTextLabel?.text = "1.0 \(item.base) -> \(item.value) \(item.target)"
            }
            .disposed(by: disposeBag)
        viewModel?.rates
            .drive(ratesTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = "\(item.target) -> \(item.value)"
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
    }
    
    /// start initial loading
    private func startLoading() {
        viewModel?.viewState.accept(.loading(loadType: .initial))
    }
}
