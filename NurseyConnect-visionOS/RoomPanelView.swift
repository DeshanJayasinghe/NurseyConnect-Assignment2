//
//  RoomPanelView.swift
//  NurseyConnect-visionOS
//

import SwiftUI

struct RoomPanelView: View {
    let room: VisionRoom
    @Environment(\.openWindow) private var openWindow

    private let vPrimary   = Color(nurseryHex: "#6C6FE8")
    private let vSecondary = Color(nurseryHex: "#8B5AD4")

    var body: some View {
        VStack(spacing: 0) {

            // ── Coloured header with gradient overlay ────────────────
            VStack(spacing: 6) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(room.name)
                            .font(.system(.title3, design: .rounded, weight: .black))
                            .foregroundStyle(.white)
                        Text(room.ageGroup)
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(.white.opacity(0.82))
                    }
                    Spacer()
                    // Ratio status bubble
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.18))
                            .frame(width: 42, height: 42)
                        Image(systemName: room.ratioOK ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                            .symbolEffect(.pulse, isActive: !room.ratioOK)
                    }
                }
            }
            .padding(.horizontal, 18).padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [room.color, room.color.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            // ── Stats row ─────────────────────────────────────────────
            HStack(spacing: 0) {
                panelStat(icon: "figure.child",  value: "\(room.activeChildrenCount)", label: "Children")
                Divider().frame(height: 46)
                panelStat(icon: "person.2.fill", value: "\(room.presentStaffCount)",   label: "Staff")
                Divider().frame(height: 46)
                VStack(spacing: 5) {
                    ZStack {
                        Circle()
                            .fill(room.ratioOK ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                            .frame(width: 32, height: 32)
                        Image(systemName: room.ratioOK ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(room.ratioOK ? .green : .red)
                    }
                    Text(room.ratioOK ? "OK" : "Alert")
                        .font(.system(.caption2, design: .rounded, weight: .bold))
                        .foregroundStyle(room.ratioOK ? .green : .red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 10)

            Divider()

            // Ratio string
            Text(room.ratioString)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)

            Divider()

            // ── CTA Button ────────────────────────────────────────────
            Button {
                openWindow(id: "roomDetail", value: room.id)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 13, weight: .semibold))
                    Text("View Children")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(
                    LinearGradient(
                        colors: [vPrimary, vSecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 12)
                )
            }
            .buttonStyle(.plain)
            .hoverEffect()
            .padding([.horizontal, .bottom], 14)
            .padding(.top, 8)
        }
        .frame(width: 290)
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 22))
        .hoverEffect(.highlight)
        .shadow(color: room.color.opacity(0.25), radius: 22, x: 0, y: 10)
    }

    private func panelStat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .black))
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}
