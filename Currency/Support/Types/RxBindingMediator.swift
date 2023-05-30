//
//  RxBindingMediator.swift
//  Currency
//
//  Created by Loay Ashraf on 30/05/2023.
//

import SwiftUI
import RxSwift
import RxCocoa

/// This Class mediates and links Rx bindings to SwiftUI bindings
class RxBindingMediator<T>: ObservableObject {
    // MARK: - Properties
    var input: BehaviorRelay<T>
    @Published var output: T
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    // MARK: - Initializer
    init(input: BehaviorRelay<T>, output: T) {
        self.input = input
        self.output = output
        setupInOutBinding()
    }
    // MARK: - Instance Methods
    private func setupInOutBinding() {
        input
            .subscribe(onNext: { [weak self] in
                self?.output = $0
            })
            .disposed(by: disposeBag)
    }
}
