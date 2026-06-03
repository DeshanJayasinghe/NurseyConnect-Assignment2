//
//  ImmersiveView.swift
//  NurseyConnect-visionOS
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    private let rooms = VisionSampleData.rooms
    @State private var showIncidentDetail = false

    // Tight arc facing the user
    private func panelPosition(index: Int) -> SIMD3<Float> {
        let x: [Float] = [-1.0, 0.0, 1.0]
        let z: [Float] = [-1.6, -1.8, -1.6]
        return SIMD3<Float>(x[safe: index] ?? 0, 1.4, z[safe: index] ?? -1.8)
    }

    private func panelRotation(index: Int) -> simd_quatf {
        let angles: [Float] = [-0.2, 0.0, 0.2]
        return simd_quatf(angle: angles[safe: index] ?? 0, axis: [0, 1, 0])
    }

    var body: some View {
        RealityView { content, attachments in
            let anchor = AnchorEntity(world: .zero)
            content.add(anchor)

            for (index, room) in rooms.enumerated() {
                guard let panel = attachments.entity(for: room.id) else { continue }
                panel.position = panelPosition(index: index)
                panel.orientation = panelRotation(index: index)
                anchor.addChild(panel)
            }

            if let card = attachments.entity(for: "incidentCard") {
                card.position = SIMD3<Float>(0, 2.1, -1.8)
                anchor.addChild(card)
            }

        } attachments: {
            ForEach(rooms) { room in
                Attachment(id: room.id) {
                    RoomPanelView(room: room)
                }
            }

            Attachment(id: "incidentCard") {
                IncidentAlertCard(
                    isExpanded: $showIncidentDetail,
                    onToggle: { withAnimation { showIncidentDetail.toggle() } }
                )
            }
        }
    }
}

// MARK: - Incident Alert Card

private struct IncidentAlertCard: View {
    @Binding var isExpanded: Bool
    let onToggle: () -> Void

    private let vPrimary = Color(nurseryHex: "#6C6FE8")
    private let vAmber   = Color(nurseryHex: "#F5A31A")

    var body: some View {
        VStack(alignment: .center, spacing: 10) {

            // Compact pulse badge
            Button(action: onToggle) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 24, height: 24)
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Text("1 Pending Incident")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(.caption2, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .padding(.horizontal, 16).padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [vAmber, vAmber.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: Capsule()
                )
                .shadow(color: vAmber.opacity(0.45), radius: 10)
            }
            .buttonStyle(.plain)
            .hoverEffect()
            .symbolEffect(.pulse)

            // Expanded detail card
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {

                    // Header row inside card
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(vAmber.opacity(0.15))
                                .frame(width: 36, height: 36)
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(vAmber)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("INC-20260529-001")
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                            Text("Pending Review")
                                .font(.system(.caption2, design: .rounded, weight: .semibold))
                                .foregroundStyle(vAmber)
                        }
                    }

                    Divider()

                    VStack(spacing: 8) {
                        detailRow("Child",     "Oliver Davies")
                        detailRow("Type",      "Fall — Minor")
                        detailRow("Location",  "Sunshine Room")
                        detailRow("Reported",  "Sarah Mitchell")
                    }

                    Divider()

                    Text("Child comforted. No visible injury. Alert and responsive.")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(18)
                .frame(width: 320)
                .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(vAmber.opacity(0.2), lineWidth: 1)
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
                .padding(.top, 6)
            }
        }
    }

    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(width: 72, alignment: .leading)
            Text(value)
                .font(.system(.caption, design: .rounded, weight: .semibold))
        }
    }
}

// MARK: - Safe array subscript

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView().environment(AppModel())
}
