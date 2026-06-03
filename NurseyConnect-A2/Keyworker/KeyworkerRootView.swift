//
//  KeyworkerRootView.swift
//  NurseyConnect-A2
//

import SwiftUI
import SwiftData

struct KeyworkerRootView: View {
    var onChangeRole: (() -> Void)? = nil

    var body: some View {
        TabView {
            Tab("Daily Diary", systemImage: "book.pages.fill") {
                NavigationStack {
                    DiaryDashboardView()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    onChangeRole?()
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 11, weight: .semibold))
                                        Text("Home")
                                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    }
                                    .foregroundStyle(Color.nurseryPrimary)
                                }
                            }
                        }
                }
            }
            Tab("Incidents", systemImage: "shield.lefthalf.filled.trianglebadge.exclamationmark") {
                NavigationStack { IncidentListView() }
            }
        }
        .tint(Color.nurseryPrimary)
    }
}

#Preview {
    KeyworkerRootView()
        .modelContainer(SampleData.previewContainer)
}
