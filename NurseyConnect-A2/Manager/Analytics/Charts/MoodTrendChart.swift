//
//  MoodTrendChart.swift
//  NurseyConnect-A2
//

import SwiftUI
import Charts

struct MoodTrendChart: View {
    let data: [AnalyticsViewModel.MoodDataPoint]

    var body: some View {
        if data.isEmpty {
            ContentUnavailableView("No Mood Data", systemImage: "face.smiling",
                description: Text("Mood entries from the last 7 days will appear here."))
                .frame(height: 180)
        } else {
            Chart(data) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Mood", point.level)
                )
                .foregroundStyle(by: .value("Child", point.childName))
                .interpolationMethod(.catmullRom)
            }
            .chartYScale(domain: 1...5)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(values: [1, 2, 3, 4, 5]) { AxisValueLabel(); AxisGridLine() }
            }
            .chartLegend(position: .bottom, alignment: .leading)
            .frame(height: 200)
        }
    }
}
