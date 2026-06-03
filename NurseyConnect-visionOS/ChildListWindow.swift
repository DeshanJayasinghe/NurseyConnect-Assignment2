//
//  ChildListWindow.swift
//  NurseyConnect-visionOS
//

import SwiftUI

struct ChildListWindow: View {
    let roomID: UUID
    @Environment(\.dismissWindow) private var dismissWindow

    private let vPrimary   = Color(nurseryHex: "#6C6FE8")
    private let vSecondary = Color(nurseryHex: "#8B5AD4")
    private let vAmber     = Color(nurseryHex: "#F5A31A")

    private var room: VisionRoom? {
        VisionSampleData.rooms.first { $0.id == roomID }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let room = room {

                    // ── Room header ──────────────────────────────────
                    HStack(spacing: 14) {
                        // Color accent bar
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [room.color, room.color.opacity(0.6)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 5, height: 48)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(room.name)
                                .font(.system(.title3, design: .rounded, weight: .black))
                            Text(room.ageGroup)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text(room.ratioString)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                            HStack(spacing: 4) {
                                Image(systemName: room.ratioOK ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                    .font(.system(size: 12, weight: .semibold))
                                Text(room.ratioOK ? "Compliant" : "Alert")
                                    .font(.system(.caption, design: .rounded, weight: .bold))
                            }
                            .foregroundStyle(room.ratioOK ? .green : .red)
                        }
                    }
                    .padding(.horizontal, 22).padding(.vertical, 16)
                    .background(.thinMaterial)

                    Divider()

                    // ── Children list ─────────────────────────────────
                    let active = room.children.filter { $0.isActive }
                    if active.isEmpty {
                        Spacer()
                        ContentUnavailableView("No Children", systemImage: "figure.child")
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(active) { child in
                                    HStack(spacing: 16) {

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
                                                .frame(width: 54, height: 54)
                                                .shadow(color: vPrimary.opacity(0.25), radius: 6, x: 0, y: 3)
                                            Text(child.initials)
                                                .font(.system(.headline, design: .rounded, weight: .bold))
                                                .foregroundStyle(.white)
                                        }

                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(child.preferredName)
                                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                            Text("Age: \(child.age)")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                            if !child.allergies.isEmpty {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "allergens")
                                                        .font(.system(size: 10, weight: .semibold))
                                                    Text(child.allergies.joined(separator: ", "))
                                                        .font(.caption)
                                                }
                                                .foregroundStyle(vAmber)
                                                .padding(.horizontal, 7).padding(.vertical, 3)
                                                .background(Capsule().fill(vAmber.opacity(0.13)))
                                            }
                                        }

                                        Spacer()

                                        // Presence badge
                                        VStack(spacing: 5) {
                                            ZStack {
                                                Circle()
                                                    .fill(child.isPresent ? Color.green.opacity(0.14) : Color.secondary.opacity(0.1))
                                                    .frame(width: 38, height: 38)
                                                Image(systemName: child.isPresent ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                    .font(.system(size: 20, weight: .medium))
                                                    .foregroundStyle(child.isPresent ? .green : .secondary)
                                            }
                                            Text(child.isPresent ? "Present" : "Absent")
                                                .font(.system(.caption2, design: .rounded, weight: .bold))
                                                .foregroundStyle(child.isPresent ? .green : .secondary)
                                        }
                                    }
                                    .padding(18)
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(vPrimary.opacity(0.07), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(18)
                        }
                    }
                } else {
                    ContentUnavailableView("Room Not Found", systemImage: "door.left.hand.open")
                }
            }
            .navigationTitle(room?.name ?? "Room Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismissWindow()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark")
                                .font(.system(size: 10, weight: .bold))
                            Text("Close")
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                        }
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Capsule().fill(Color.secondary.opacity(0.12)))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
