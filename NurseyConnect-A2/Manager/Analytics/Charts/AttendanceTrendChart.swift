//
//  AttendanceTrendChart.swift
//  NurseyConnect-A2
//

import SwiftUI
import Charts

struct AttendanceTrendChart: View {
    let data: [AnalyticsViewModel.AttendanceDayPoint]

    var body: some View {
        if data.isEmpty {
            ContentUnavailableView("No Attendance Data", systemImage: "person.badge.clock",
                description: Text("Attendance records will appear here."))
                .frame(height: 160)
        } else {
            Chart(data) { point in
                BarMark(
                    x: .value("Date", point.date, unit: .day),
                    y: .value("Present", point.count)
                )
                .foregroundStyle(Color.nurseryPrimary)
            }
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { AxisValueLabel(); AxisGridLine() }
            }
            .frame(height: 180)
        }
    }
}
