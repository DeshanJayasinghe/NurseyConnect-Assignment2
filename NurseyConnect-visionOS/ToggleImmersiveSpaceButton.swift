//
//  ToggleImmersiveSpaceButton.swift
//  NurseyConnect-visionOS
//

import SwiftUI

struct ToggleImmersiveSpaceButton: View {

    @Environment(AppModel.self) private var appModel

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    private let vPrimary   = Color(nurseryHex: "#6C6FE8")
    private let vSecondary = Color(nurseryHex: "#8B5AD4")

    private var isOpen: Bool { appModel.immersiveSpaceState == .open }

    var body: some View {
        Button {
            Task { @MainActor in
                switch appModel.immersiveSpaceState {
                case .open:
                    appModel.immersiveSpaceState = .inTransition
                    await dismissImmersiveSpace()

                case .closed:
                    appModel.immersiveSpaceState = .inTransition
                    switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
                    case .opened:
                        break
                    case .userCancelled, .error:
                        fallthrough
                    @unknown default:
                        appModel.immersiveSpaceState = .closed
                    }

                case .inTransition:
                    break
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isOpen ? "eye.slash.fill" : "eye.fill")
                    .font(.system(size: 12, weight: .semibold))
                Text(isOpen ? "Exit Spatial" : "Spatial View")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: isOpen
                        ? [Color.secondary.opacity(0.5), Color.secondary.opacity(0.35)]
                        : [vPrimary, vSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: Capsule()
            )
            .shadow(color: isOpen ? .clear : vPrimary.opacity(0.35), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
        .hoverEffect()
        .disabled(appModel.immersiveSpaceState == .inTransition)
        .animation(.easeInOut(duration: 0.2), value: isOpen)
    }
}
