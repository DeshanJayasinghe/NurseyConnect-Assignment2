//
//  AttendanceView.swift
//  NurseyConnect-A2
//

import SwiftUI
import SwiftData

struct AttendanceView: View {
    @Query(sort: \Child.fullName) private var children: [Child]
    @Query private var allAttendance: [AttendanceRecord]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedDate: Date = .now
    @State private var selectedRoomID: UUID? = nil
    @Query(sort: \Room.name) private var rooms: [Room]

    private var selectedRoom: Room? { rooms.first { $0.id == selectedRoomID } }

    private var today: Date { Calendar.current.startOfDay(for: selectedDate) }

    private var activeChildren: [Child] {
        let all = children.filter { $0.isActive }
        if let room = selectedRoom { return all.filter { $0.room?.id == room.id } }
        return all
    }

    private func record(for child: Child) -> AttendanceRecord? {
        allAttendance.first { $0.child?.id == child.id && $0.date == today }
    }

    private var presentCount: Int {
        activeChildren.filter { record(for: $0)?.isPresent == true }.count
    }

    var body: some View {
        VStack(spacing: 0) {
            // Controls bar
            VStack(spacing: AppSpacing.sm) {
                HStack {
                    Label("Date", systemImage: "calendar")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color.nurseryPrimary)
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                        .tint(Color.nurseryPrimary)
                }

                // Room filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        roomChip(title: "All Rooms", isSelected: selectedRoomID == nil) {
                            selectedRoomID = nil
                        }
                        ForEach(rooms) { room in
                            roomChip(title: room.name, isSelected: selectedRoomID == room.id) {
                                selectedRoomID = room.id
                            }
                        }
                    }
                }

                // Summary pill
                HStack(spacing: AppSpacing.sm) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.nurseryPrimary)
                            .frame(width: 8, height: 8)
                        Text("\(presentCount) present")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .foregroundStyle(Color.nurseryPrimary)
                    }
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, 5)
                    .background(
                        Capsule().fill(Color.nurseryPrimary.opacity(0.12))
                    )

                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.secondary.opacity(0.5))
                            .frame(width: 8, height: 8)
                        Text("\(activeChildren.count - presentCount) absent")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, 5)
                    .background(
                        Capsule().fill(Color.secondary.opacity(0.1))
                    )

                    Spacer()
                }
            }
            .padding(AppSpacing.md)
            .background(Color.nurseryCard)

            Divider()

            if activeChildren.isEmpty {
                ContentUnavailableView("No Children", systemImage: "person.slash",
                    description: Text("No active children found."))
            } else {
                List {
                    ForEach(activeChildren) { child in
                        AttendanceRowView(
                            child: child,
                            record: record(for: child),
                            onCheckIn: { checkIn(child: child) },
                            onCheckOut: { checkOut(child: child) }
                        )
                        .listRowBackground(Color.nurseryCard)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
        }
        .background(Color.nurseryBackground)
        .navigationTitle("Attendance")
    }

    private func roomChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(.caption, design: .rounded, weight: isSelected ? .bold : .semibold))
                .foregroundStyle(isSelected ? .white : Color.nurseryPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    Capsule().fill(
                        isSelected
                            ? AnyShapeStyle(LinearGradient.nurseryHero)
                            : AnyShapeStyle(Color.nurseryPrimary.opacity(0.10))
                    )
                )
        }
        .buttonStyle(.plain)
    }

    private func checkIn(child: Child) {
        let rec = AttendanceRecord(child: child, date: selectedDate)
        rec.checkInTime  = .now
        rec.checkedInBy  = "Mrs T. Williams"
        modelContext.insert(rec)
    }

    private func checkOut(child: Child) {
        guard let rec = record(for: child) else { return }
        rec.checkOutTime = .now
        rec.checkedOutBy = "Mrs T. Williams"
    }
}

#Preview {
    NavigationStack { AttendanceView() }
        .modelContainer(SampleData.previewContainer)
}
