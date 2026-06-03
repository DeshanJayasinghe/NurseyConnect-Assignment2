//
//  DashboardStatCard.swift
//  NurseyConnect-A2
//

import SwiftUI

struct DashboardStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var subtitle: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.65)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)

                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Text(value)
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Text(title)
                .font(.sectionHead)
                .foregroundStyle(.primary)

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(AppSpacing.md)
        .nurseryCard()
    }
}

#Preview {
    HStack {
        DashboardStatCard(title: "Children Present", value: "12", icon: "person.3.fill", color: .nurseryPrimary, subtitle: "of 18 enrolled")
        DashboardStatCard(title: "Ratio Alerts", value: "1", icon: "exclamationmark.triangle.fill", color: .red)
    }
    .padding()
}
