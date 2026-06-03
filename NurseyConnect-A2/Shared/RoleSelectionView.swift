//
//  RoleSelectionView.swift
//  NurseyConnect-A2
//

import SwiftUI

enum AppRole: String {
    case keyworker = "Keyworker"
    case manager   = "Setting Manager"
}

struct RoleSelectionView: View {
    @State private var activeRole: AppRole? = nil

    var body: some View {
        if activeRole == .keyworker {
            KeyworkerRootView(onChangeRole: { activeRole = nil })
        } else if activeRole == .manager {
            ManagerRootView()
        } else {
            selectionScreen
        }
    }

    private var selectionScreen: some View {
        ZStack {
            // Background canvas
            Color.nurseryBackground.ignoresSafeArea()

            // Decorative blobs
            GeometryReader { geo in
                Circle()
                    .fill(Color.nurseryPrimary.opacity(0.12))
                    .frame(width: geo.size.width * 0.7)
                    .offset(x: -geo.size.width * 0.2, y: -geo.size.height * 0.05)
                    .blur(radius: 60)

                Circle()
                    .fill(Color.nurseryTeal.opacity(0.10))
                    .frame(width: geo.size.width * 0.6)
                    .offset(x: geo.size.width * 0.5, y: geo.size.height * 0.55)
                    .blur(radius: 55)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Hero banner
                VStack(spacing: AppSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient.nurseryHero)
                            .frame(width: 90, height: 90)
                            .shadow(color: Color.nurseryPrimary.opacity(0.35), radius: 16, x: 0, y: 6)

                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 6) {
                        Text("NurseyConnect")
                            .font(.system(.largeTitle, design: .rounded, weight: .black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.nurseryPrimary, Color.nurseryTeal],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Little Stars Nursery & Daycare")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, AppSpacing.xl + AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)

                // Divider label
                HStack(spacing: AppSpacing.sm) {
                    Rectangle().fill(Color.secondary.opacity(0.2)).frame(height: 1)
                    Text("Who are you?")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize()
                    Rectangle().fill(Color.secondary.opacity(0.2)).frame(height: 1)
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.lg)

                // Role cards
                VStack(spacing: AppSpacing.md) {
                    RoleCard(
                        role: .keyworker,
                        icon: "person.text.rectangle.fill",
                        subtitle: "Record daily diaries & incident reports",
                        gradient: LinearGradient(
                            colors: [Color.nurseryPrimary, Color.nurseryPrimary.opacity(0.75)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    ) { activeRole = .keyworker }

                    RoleCard(
                        role: .manager,
                        icon: "building.columns.fill",
                        subtitle: "Room oversight, analytics & reports",
                        gradient: LinearGradient(
                            colors: [Color.nurseryTeal, Color.nurseryTeal.opacity(0.75)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    ) { activeRole = .manager }
                }
                .padding(.horizontal, AppSpacing.lg)

                Spacer()

                Text("v2.0  ·  SE4020 Assignment")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.tertiary)
                    .padding(.bottom, AppSpacing.lg)
            }
        }
    }
}

// MARK: - Role Card Component

private struct RoleCard: View {
    let role: AppRole
    let icon: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                // Gradient icon pill
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(gradient)
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(role.rawValue)
                        .font(.displayName)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.bodySmall)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.nurseryPrimary.opacity(0.6), Color.nurseryTeal.opacity(0.6)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(AppSpacing.md)
            .nurseryCard()
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.25), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }
}

#Preview {
    RoleSelectionView()
}
