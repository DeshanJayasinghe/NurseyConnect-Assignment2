//
//  IncidentRowView.swift
//  NurseyConnect-A2
//

import SwiftUI; import SwiftData

struct IncidentRowView: View {
    let report: IncidentReport
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Severity accent bar
            RoundedRectangle(cornerRadius: 3)
                .fill(report.severity.color)
                .frame(width: 4)
                .padding(.vertical, AppSpacing.xs)
                .padding(.trailing, AppSpacing.sm)

            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(report.severity.color.opacity(0.12))
                    .frame(width: 38, height: 38)
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(report.severity.color)
            }
            .padding(.trailing, AppSpacing.sm)

            VStack(alignment: .leading, spacing: 3) {
                Text(report.referenceNumber)
                    .font(.cardTitle)
                    .foregroundStyle(.primary)
                Text(report.category.rawValue + (report.child != nil ? " · \(report.child!.preferredName)" : ""))
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(report.incidentDate, style: .date)
                    .font(.bodySmall)
                    .foregroundStyle(.tertiary)
            }
            Spacer()
            StatusBadge(status: report.status)
        }
        .padding(.vertical, AppSpacing.xs + 2)
    }
}
