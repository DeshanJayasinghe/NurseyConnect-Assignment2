//
//  DiaryEntryRow.swift
//  NurseyConnect-A2
//

import SwiftUI

struct DiaryEntryRow: View {
    let entry: DiaryEntry

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: 11)
                    .fill(
                        LinearGradient(
                            colors: [entry.entryType.color, entry.entryType.color.opacity(0.65)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)
                    .shadow(color: entry.entryType.color.opacity(0.25), radius: 4, x: 0, y: 2)

                Image(systemName: entry.entryType.systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.headline)
                    .font(.cardTitle)
                    .foregroundStyle(.primary)
                if !entry.subtitle.isEmpty {
                    Text(entry.subtitle)
                        .font(.bodySmall)
                        .foregroundStyle(entry.entryType.color.opacity(0.9))
                        .lineLimit(1)
                }
                HStack(spacing: AppSpacing.xs) {
                    Text(entry.timestamp, style: .time)
                        .font(.bodySmall)
                        .foregroundStyle(.secondary)
                    if !entry.notes.isEmpty {
                        Text("·").foregroundStyle(.secondary)
                        Text(entry.notes)
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            Spacer()
        }
        .padding(.vertical, AppSpacing.xs + 1)
    }
}
