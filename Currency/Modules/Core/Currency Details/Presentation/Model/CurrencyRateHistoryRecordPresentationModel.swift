//
//  CurrencyRateHistoryRecordPresentationModel.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import Foundation

struct CurrencyRateHistoryRecordPresentationModel: Hashable {
    let date: String
    let base: String
    let target: String
    let value: Double
    init(form historyRecord: CurrencyRateHistoryRecord) {
        self.date = historyRecord.date
        self.base = historyRecord.base
        self.target = historyRecord.target
        self.value = historyRecord.value
    }
}
