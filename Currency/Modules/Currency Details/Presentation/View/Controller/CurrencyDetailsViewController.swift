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
    var viewModel: CurrencyDetailsViewModel?
    private let disposeBag = DisposeBag()
    @IBOutlet weak var rateHistoryTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupUIBindings()
        startLoading()
    }
    private func setupUI() {
        rateHistoryTableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    private func setupUIBindings() {
        setupOutputBindings()
    }
    private func setupOutputBindings() {
        viewModel?.viewState
            .map({ [.loading(loadType: .initial), .loading(loadType: .baseDriven), .loading(loadType: .targetDriven)].contains($0) })
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel?.error
            .drive(onNext: {
                let alertController = UIAlertController(title: "Error", message: "An error occured.\n\($0.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(.init(title: "Ok", style: .default))
                self.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
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
        selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
