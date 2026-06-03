//
//  MealAmountChart.swift
//  NurseyConnect-A2
//

import SwiftUI
import Charts

struct MealAmountChart: View {
    let data: [AnalyticsViewModel.MealAmountPoint]

    var body: some View {
        if data.isEmpty {
            ContentUnavailableView("No Meal Data", systemImage: "fork.knife",
                description: Text("Meal entries will appear here."))
                .frame(height: 120)
        } else {
            Chart(data) { item in
                SectorMark(
                    angle: .value("Count", item.count),
                    innerRadius: .ratio(0.55),
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Amount", item.amount))
            }
            .chartLegend(position: .bottom, alignment: .center, spacing: 8)
            .frame(height: 180)
        }
    }
}
