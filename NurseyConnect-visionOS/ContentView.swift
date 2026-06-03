//
//  ContentView.swift
//  NurseyConnect-visionOS
//

import SwiftUI

struct ContentView: View {
    @Environment(AppModel.self) private var appModel

    private let rooms = VisionSampleData.rooms
    private let vPrimary   = Color(nurseryHex: "#6C6FE8")
    private let vSecondary = Color(nurseryHex: "#8B5AD4")
    private let vAmber     = Color(nurseryHex: "#F5A31A")

    @State private var expandedRoomID: UUID? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Header ──────────────────────────────────────────────
                HStack(spacing: 16) {
                    // Brand icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [vPrimary, vSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)
                            .shadow(color: vPrimary.opacity(0.35), radius: 8, x: 0, y: 4)
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 10) {
                            Text("NurseyConnect")
                                .font(.system(.title2, design: .rounded, weight: .black))
                                .foregroundStyle(vPrimary)

                            let allOK = VisionSampleData.ratioAlerts == 0
                            HStack(spacing: 5) {
                                Image(systemName: allOK ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                                    .font(.system(.caption2, weight: .bold))
                                Text(allOK ? "Ratios OK" : "\(VisionSampleData.ratioAlerts) Alert")
                                    .font(.system(.caption, design: .rounded, weight: .bold))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(allOK ? Color.green : Color.red, in: Capsule())
                            .symbolEffect(.pulse, isActive: !allOK)
                        }
                        Text("Setting Manager  ·  Spatial Dashboard")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                    ToggleImmersiveSpaceButton()
                }
                .padding(.horizontal, 24).padding(.vertical, 18)

                Divider()

                // ── Stats bar ────────────────────────────────────────────
                HStack(spacing: 0) {
                    statTile("Present",      "\(VisionSampleData.presentCount)", "person.3.fill",               vPrimary)
                    Divider().frame(height: 52)
                    statTile("Rooms",        "\(rooms.count)",                   "door.left.hand.open",          vSecondary)
                    Divider().frame(height: 52)
                    statTile("Ratio Alerts", "\(VisionSampleData.ratioAlerts)",  "exclamationmark.triangle.fill",
                             VisionSampleData.ratioAlerts > 0 ? .red : .green)
                    Divider().frame(height: 52)
                    statTile("Incidents",    "1",                                "bell.badge.fill",               vAmber)
                }
                .padding(.vertical, 6)
                .background(.thinMaterial)

                Divider()

                // ── Room list ─────────────────────────────────────────────
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(rooms) { room in
                            VStack(spacing: 0) {
                                // Room header row — tap to expand
                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        expandedRoomID = expandedRoomID == room.id ? nil : room.id
                                    }
                                } label: {
                                    HStack(spacing: 14) {
                                        // Color accent pill
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(room.color)
                                            .frame(width: 5, height: 48)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(room.name)
                                                .font(.system(.headline, design: .rounded, weight: .bold))
                                            Text(room.ageGroup)
                                                .font(.subheadline).foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("\(room.activeChildrenCount) children")
                                                .font(.subheadline).foregroundStyle(.secondary)
                                            Text(room.ratioString)
                                                .font(.caption).foregroundStyle(.secondary)
                                        }

                                        // Ratio status icon
                                        ZStack {
                                            Circle()
                                                .fill(room.ratioOK ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                                                .frame(width: 32, height: 32)
                                            Image(systemName: room.ratioOK ? "checkmark.shield.fill" : "exclamationmark.triangle.fill")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundStyle(room.ratioOK ? .green : .red)
                                        }

                                        Image(systemName: expandedRoomID == room.id ? "chevron.up" : "chevron.down")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.horizontal, 18).padding(.vertical, 12)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .hoverEffect()

                                // Expanded children list
                                if expandedRoomID == room.id {
                                    Divider().padding(.horizontal, 18)
                                    VStack(spacing: 0) {
                                        ForEach(room.children.filter { $0.isActive }) { child in
                                            HStack(spacing: 14) {
                                                // Avatar
                                                ZStack {
                                                    Circle()
                                                        .fill(
                                                            LinearGradient(
                                                                colors: [vPrimary, vSecondary],
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            )
                                                        )
                                                        .frame(width: 40, height: 40)
                                                        .shadow(color: vPrimary.opacity(0.25), radius: 4, x: 0, y: 2)
                                                    Text(child.initials)
                                                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                                                        .foregroundStyle(.white)
                                                }

                                                VStack(alignment: .leading, spacing: 3) {
                                                    Text(child.preferredName)
                                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                                    if !child.allergies.isEmpty {
                                                        Label(child.allergies.joined(separator: ", "), systemImage: "allergens")
                                                            .font(.caption)
                                                            .foregroundStyle(vAmber)
                                                    }
                                                }

                                                Spacer()

                                                Text(child.age)
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)

                                                // Presence badge
                                                HStack(spacing: 4) {
                                                    Circle()
                                                        .fill(child.isPresent ? Color.green : Color.secondary.opacity(0.5))
                                                        .frame(width: 6, height: 6)
                                                    Text(child.isPresent ? "Present" : "Absent")
                                                        .font(.system(.caption, design: .rounded, weight: .semibold))
                                                        .foregroundStyle(child.isPresent ? .green : .secondary)
                                                }
                                                .padding(.horizontal, 8).padding(.vertical, 4)
                                                .background(
                                                    Capsule().fill(child.isPresent ? Color.green.opacity(0.12) : Color.secondary.opacity(0.1))
                                                )
                                            }
                                            .padding(.horizontal, 22).padding(.vertical, 10)

                                            if child.id != room.children.filter({ $0.isActive }).last?.id {
                                                Divider().padding(.leading, 76)
                                            }
                                        }
                                    }
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(vPrimary.opacity(0.08), lineWidth: 1)
                            )
                        }
                    }
                    .padding(18)
                }
            }
        }
    }

    private func statTile(_ title: String, _ value: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(.title3, design: .rounded, weight: .black))
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

// MARK: - Window Ornament

struct RatioOrnamentView: View {
    private let rooms = VisionSampleData.rooms
    private let vPrimary = Color(nurseryHex: "#6C6FE8")

    private var alertCount: Int { rooms.filter { !$0.ratioOK }.count }
    private var allOK: Bool { alertCount == 0 }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(allOK ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: allOK ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(allOK ? .green : .red)
                    .symbolEffect(.pulse, isActive: !allOK)
            }

            Text(allOK ? "Ratios OK" : "\(alertCount) Alert\(alertCount > 1 ? "s" : "")")
                .font(.system(.caption2, design: .rounded, weight: .bold))
                .foregroundStyle(allOK ? .green : .red)

            Text("EYFS")
                .font(.system(size: 9, design: .rounded, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview(windowStyle: .automatic) {
    ContentView().environment(AppModel())
}
