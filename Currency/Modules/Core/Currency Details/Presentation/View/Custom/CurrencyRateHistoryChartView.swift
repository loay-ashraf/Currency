//
//  CurrencyRateHistoryChartView.swift
//  Currency
//
//  Created by Loay Ashraf on 29/05/2023.
//

import SwiftUI
import Charts

struct CurrencyRateHistoryChartView: View {
    // MARK: - Properties
    @ObservedObject var bindingMediator: RxBindingMediator<[CurrencyRateHistoryRecordPresentationModel]>
    var sortedOutput: [CurrencyRateHistoryRecordPresentationModel] {
        bindingMediator.output.sorted(by: { $0.date < $1.date })
    }
    var minValue: Double {
        bindingMediator.output.map({ $0.value }).min() ?? 0.0
    }
    var maxValue: Double {
        bindingMediator.output.map({ $0.value }).max() ?? 0.0
    }
    // MARK: - Body Property
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                Chart {
                    ForEach(sortedOutput, id: \.date) { item in
                        LineMark(
                            x: .value("Day", item.date),
                            y: .value("Rate", item.value)
                        )
                        PointMark(
                            x: .value("Day", item.date),
                            y: .value("Rate", item.value)
                        )
                        .annotation(position: .overlay, alignment: .bottom, spacing: 10.0) {
                            Text("\(item.value) \(item.target)")
                                .font(.system(size: 10.0))
                                .foregroundColor(.black)
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 3))
                }
                .chartYScale(domain: minValue...maxValue)
            }
        } else {
            Text("Currency Rate History Chart is only avialable on iOS 16 and above.")
        }
    }
}
