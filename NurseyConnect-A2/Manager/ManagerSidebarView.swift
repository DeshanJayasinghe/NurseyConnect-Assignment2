//
//  ManagerSidebarView.swift
//  NurseyConnect-A2
//

import SwiftUI
import SwiftData

struct ManagerSidebarView: View {
    @Binding var selection: ManagerSection?

    @Query private var reports: [IncidentReport]
    @State private var showingKeyworker = false

    private var pendingCount: Int {
        reports.filter { $0.status == .pendingReview }.count
    }

    var body: some View {
        List(selection: $selection) {
            // App brand header inside the list
            Section {
                HStack(spacing: AppSpacing.sm) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient.nurseryHero)
                            .frame(width: 36, height: 36)
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 1) {
                        Text("NurseyConnect")
                            .font(.system(.subheadline, design: .rounded, weight: .black))
                            .foregroundStyle(Color.nurseryPrimary)
                        Text("Manager Portal")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, AppSpacing.xs)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }

            Section("Navigation") {
                ForEach(ManagerSection.allCases) { section in
                    Label(section.rawValue, systemImage: section.systemImage)
                        .badge(section == .incidents && pendingCount > 0 ? pendingCount : 0)
                        .tag(section)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingKeyworker = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                        Text("Keyworker")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, 5)
                    .background(
                        Capsule().fill(LinearGradient.nurseryHero)
                    )
                }
                .buttonStyle(.plain)
                .help("Switch to Keyworker View")
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: AppSpacing.sm) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient.nurseryAvatar)
                            .frame(width: 34, height: 34)
                        Text("LS")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Little Stars Nursery")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                        Text("Setting Manager")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(AppSpacing.md)
            }
        }
        .fullScreenCover(isPresented: $showingKeyworker) {
            KeyworkerRootView(onChangeRole: { showingKeyworker = false })
        }
    }
}
