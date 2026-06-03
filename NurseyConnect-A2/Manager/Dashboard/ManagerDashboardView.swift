//
//  ManagerDashboardView.swift
//  NurseyConnect-A2
//

import SwiftUI
import SwiftData

struct ManagerDashboardView: View {
    var onNavigate: ((ManagerSection) -> Void)? = nil

    @Query private var children: [Child]
    @Query private var rooms: [Room]
    @Query private var reports: [IncidentReport]
    @Query private var attendance: [AttendanceRecord]
    @Query private var entries: [DiaryEntry]

    let columns = [GridItem(.adaptive(minimum: 200), spacing: AppSpacing.md)]

    private var today: Date { Calendar.current.startOfDay(for: .now) }

    private var presentCount: Int {
        attendance.filter { $0.date == today && $0.isPresent }.count
    }

    private var pendingIncidents: Int {
        reports.filter { $0.status == .pendingReview }.count
    }

    private var ratioAlerts: Int {
        rooms.filter { !$0.ratioOK }.count
    }

    private var mealsToday: Int {
        entries.filter {
            $0.entryType == .meal &&
            Calendar.current.isDateInToday($0.timestamp)
        }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {

                // Welcome banner
                HStack(spacing: AppSpacing.md) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Good morning 👋")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                        Text("Today's Overview")
                            .font(.system(.title2, design: .rounded, weight: .black))
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                    Text(Date.now, style: .date)
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.nurseryPrimary.opacity(0.12))
                        )
                }
                .padding(.horizontal, AppSpacing.xs)

                // Stat cards grid
                LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                    Button { onNavigate?(.attendance) } label: {
                        DashboardStatCard(title: "Children Present", value: "\(presentCount)",
                            icon: "person.3.fill", color: .nurseryPrimary,
                            subtitle: "of \(children.filter { $0.isActive }.count) enrolled")
                    }
                    .buttonStyle(.plain)

                    Button { onNavigate?(.rooms) } label: {
                        DashboardStatCard(title: "Ratio Alerts", value: "\(ratioAlerts)",
                            icon: "exclamationmark.triangle.fill",
                            color: ratioAlerts > 0 ? .red : .green,
                            subtitle: ratioAlerts > 0 ? "Action required" : "All rooms compliant")
                    }
                    .buttonStyle(.plain)

                    Button { onNavigate?(.incidents) } label: {
                        DashboardStatCard(title: "Pending Incidents", value: "\(pendingIncidents)",
                            icon: "bell.badge.fill",
                            color: pendingIncidents > 0 ? .nurseryAccent : .green,
                            subtitle: pendingIncidents > 0 ? "Awaiting review" : "All reviewed")
                    }
                    .buttonStyle(.plain)

                    Button { onNavigate?(.analytics) } label: {
                        DashboardStatCard(title: "Meals Logged", value: "\(mealsToday)",
                            icon: "fork.knife", color: .nurseryTeal, subtitle: "Today")
                    }
                    .buttonStyle(.plain)
                }

                // Room ratio overview
                if !rooms.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack {
                            Text("Room Status")
                                .font(.sectionHead)
                            Spacer()
                            Button { onNavigate?(.rooms) } label: {
                                Text("View all")
                                    .font(.system(.caption, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Color.nurseryPrimary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, AppSpacing.xs)

                        VStack(spacing: AppSpacing.sm) {
                            ForEach(rooms) { room in
                                Button { onNavigate?(.rooms) } label: {
                                    HStack(spacing: AppSpacing.sm) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color(hex: room.colorHex))
                                            .frame(width: 4, height: 36)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(room.name)
                                                .font(.cardTitle)
                                                .foregroundStyle(.primary)
                                            Text(room.ageGroup.rawValue)
                                                .font(.system(.caption2, design: .rounded))
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        Text(room.ratioString)
                                            .font(.bodySmall)
                                            .foregroundStyle(.secondary)
                                        RatioBadge(room: room)
                                        Image(systemName: "chevron.right")
                                            .font(.caption2)
                                            .foregroundStyle(.tertiary)
                                    }
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, AppSpacing.sm + 2)
                                    .background(Color.nurseryCard)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .shadow(color: Color.nurseryPrimary.opacity(0.06), radius: 5, x: 0, y: 2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(AppSpacing.md)
        }
        .background(Color.nurseryBackground)
        .navigationTitle("Dashboard")
    }
}

#Preview {
    NavigationStack { ManagerDashboardView() }
        .modelContainer(SampleData.previewContainer)
}
