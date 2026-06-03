//
//  AttendanceRowView.swift
//  NurseyConnect-A2
//

import SwiftUI

struct AttendanceRowView: View {
    let child: Child
    let record: AttendanceRecord?
    let onCheckIn: () -> Void
    let onCheckOut: () -> Void

    private var statusColor: Color {
        guard let rec = record else { return .secondary }
        return rec.isPresent ? Color.nurseryPrimary : .gray
    }

    private var statusLabel: String {
        guard let rec = record else { return "Not arrived" }
        if rec.isPresent, let t = rec.checkInTime {
            return "In since \(t.formatted(date: .omitted, time: .shortened))"
        }
        if let out = rec.checkOutTime, let inn = rec.checkInTime {
            return "Left · \(inn.formatted(date: .omitted, time: .shortened))–\(out.formatted(date: .omitted, time: .shortened))"
        }
        return "Not arrived"
    }

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(LinearGradient.nurseryAvatar)
                    .frame(width: 44, height: 44)
                    .shadow(color: Color.nurseryPrimary.opacity(0.2), radius: 4, x: 0, y: 2)
                Text(child.initials)
                    .font(.system(.callout, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(child.preferredName).font(.cardTitle)
                HStack(spacing: AppSpacing.xs) {
                    Circle().fill(statusColor).frame(width: 7, height: 7)
                    Text(statusLabel).font(.bodySmall).foregroundStyle(.secondary)
                }
            }

            Spacer()

            if record == nil {
                Button("Check In", action: onCheckIn)
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.sm + 2)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(LinearGradient.nurseryHero)
                    )
                    .buttonStyle(.plain)
            } else if record?.isPresent == true {
                Button("Check Out", action: onCheckOut)
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.nurseryAccent)
                    .padding(.horizontal, AppSpacing.sm + 2)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().strokeBorder(Color.nurseryAccent, lineWidth: 1.5)
                    )
                    .buttonStyle(.plain)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}
