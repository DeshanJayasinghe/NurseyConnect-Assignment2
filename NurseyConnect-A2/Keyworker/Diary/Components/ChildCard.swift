//
//  ChildCard.swift
//  NurseyConnect-A2
//

import SwiftUI
import SwiftData

struct ChildCard: View {
    let child: Child
    let date: Date
    var index: Int = 0
    @State private var visible = false

    private var entriesForDate: [DiaryEntry] { child.diaryEntries(for: date) }
    private func count(for type: DiaryEntryType) -> Int {
        entriesForDate.filter { $0.entryType == type }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(alignment: .top) {
                // Avatar with gradient ring
                ZStack {
                    Circle()
                        .stroke(LinearGradient.nurseryAvatar, lineWidth: 2.5)
                        .frame(width: 52, height: 52)
                    Circle()
                        .fill(LinearGradient.nurseryAvatar)
                        .frame(width: 44, height: 44)
                    Text(child.initials)
                        .font(.system(.callout, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                }

                Spacer()

                if !child.allergies.isEmpty {
                    HStack(spacing: 3) {
                        Image(systemName: "allergens")
                            .font(.system(size: 9, weight: .bold))
                        Text("Allergy")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Color.nurseryAccent)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(Color.nurseryAccent.opacity(0.15))
                    )
                }
            }

            Text(child.preferredName)
                .font(.cardTitle)
                .foregroundStyle(.primary)
                .lineLimit(1)

            HStack(spacing: 4) {
                Text(child.age)
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                Text("·")
                    .font(.bodySmall)
                    .foregroundStyle(.tertiary)
                Text(child.roomName)
                    .font(.bodySmall)
                    .foregroundStyle(Color.nurseryPrimary.opacity(0.8))
                    .lineLimit(1)
            }

            Divider()
                .padding(.vertical, 2)

            // Entry type mini indicators
            HStack(spacing: AppSpacing.xs) {
                ForEach(DiaryEntryType.allCases) { type in
                    let n = count(for: type)
                    VStack(spacing: 3) {
                        ZStack {
                            Circle()
                                .fill(n > 0 ? type.color.opacity(0.15) : Color.secondary.opacity(0.07))
                                .frame(width: 28, height: 28)
                            Image(systemName: type.systemImage)
                                .font(.system(size: 11, weight: n > 0 ? .semibold : .regular))
                                .foregroundStyle(n > 0 ? type.color : Color.secondary.opacity(0.35))
                        }
                        Text(n > 0 ? "\(n)" : "–")
                            .font(.system(size: 9, weight: n > 0 ? .bold : .regular, design: .rounded))
                            .foregroundStyle(n > 0 ? type.color : Color.secondary.opacity(0.35))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(AppSpacing.md)
        .nurseryCard()
        .opacity(visible ? 1 : 0)
        .offset(y: visible ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.78).delay(Double(index) * 0.06)) {
                visible = true
            }
        }
    }
}
