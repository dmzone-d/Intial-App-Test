//
//  ContentView.swift
//  InitialApp
//
//  Created by DMZone 10/03/26.
//
//  A clean day-off request selector with professional UI and dark mode support.
//

import SwiftUI

// MARK: - Data Model
// Defines the three types of day-off requests.
enum DayOffType: String, CaseIterable {
    case holiday = "Holiday"
    case sick     = "Sick Leave"
    case vacation = "Vacation"

    // A short subtitle shown beneath the main title
    var description: String {
        switch self {
        case .holiday:  return "Public or company holiday"
        case .sick:     return "Medical or personal illness"
        case .vacation: return "Planned time away"
        }
    }

    // Accent color per type — adjusted for both light and dark environments
    func accentColor(for scheme: ColorScheme) -> Color {
        switch self {
        case .holiday:
            return scheme == .dark
                ? Color(red: 0.40, green: 0.65, blue: 0.95) // Lighter steel blue
                : Color(red: 0.20, green: 0.45, blue: 0.75)
        case .sick:
            return scheme == .dark
                ? Color(red: 0.75, green: 0.55, blue: 0.90) // Lighter purple
                : Color(red: 0.55, green: 0.35, blue: 0.70)
        case .vacation:
            return scheme == .dark
                ? Color(red: 0.25, green: 0.75, blue: 0.65) // Lighter teal
                : Color(red: 0.15, green: 0.55, blue: 0.45)
        }
    }
}

// MARK: - Main View
struct ContentView: View {

    // MARK: State
    @State private var selection: DayOffType = .vacation
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date.now) ?? Date.now

    // Reads the current color scheme (light or dark) from the environment
    @Environment(\.colorScheme) var colorScheme

    // MARK: Body
    var body: some View {

        // Convenience shorthand used throughout the view
        let accent = selection.accentColor(for: colorScheme)

        NavigationStack {
            ZStack {

                // MARK: Background
                // Uses adaptive system colors so it shifts automatically in dark mode
                (colorScheme == .dark
                    ? Color(red: 0.11, green: 0.11, blue: 0.12)  // Dark: near-black
                    : Color(red: 0.97, green: 0.97, blue: 0.96)) // Light: soft off-white
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // MARK: Header Card
                    // Accent background with white text — works in both modes
                    VStack(spacing: 8) {
                        Text(selection.rawValue)
                            .font(.system(size: 36, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)

                        Text(selection.description)
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.80))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 44)
                    .background(accent)
                    .animation(.easeInOut(duration: 0.3), value: selection)
                    .animation(.easeInOut(duration: 0.3), value: colorScheme)

                    // MARK: Picker Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Request Type")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 24)
                            .padding(.top, 32)

                        Picker("Select Type", selection: $selection) {
                            ForEach(DayOffType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 24)
                        .animation(.easeInOut(duration: 0.2), value: selection)
                    }

                    // MARK: Info Card
                    // Adaptive card background — white in light, elevated dark in dark mode
                    VStack(alignment: .leading, spacing: 16) {

                        // Status + Duration row
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Status")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundStyle(.secondary)
                                Text("Draft")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                            }
                            Spacer()

                            // Live duration badge
                            let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Duration")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundStyle(.secondary)
                                Text(days == 1 ? "1 day" : "\(max(days, 1)) days")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundStyle(accent)
                            }
                        }

                        Divider()

                        // Start date picker
                        HStack {
                            Text("Start Date")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.secondary)
                            Spacer()
                            DatePicker(
                                "",
                                selection: $startDate,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            // Accent tint follows the current selection color
                            .tint(accent)
                            .onChange(of: startDate) { _, newStart in
                                if newStart >= endDate {
                                    endDate = Calendar.current.date(byAdding: .day, value: 1, to: newStart) ?? newStart
                                }
                            }
                        }

                        Divider()

                        // End date picker — locked to always be after start
                        HStack {
                            Text("End Date")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.secondary)
                            Spacer()
                            DatePicker(
                                "",
                                selection: $endDate,
                                in: Calendar.current.date(byAdding: .day, value: 1, to: startDate)!...,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .tint(accent)
                        }
                    }
                    .padding(20)
                    // Card background: white in light mode, slightly raised dark in dark mode
                    .background(
                        colorScheme == .dark
                            ? Color(red: 0.18, green: 0.18, blue: 0.20)
                            : Color.white
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(
                        // Shadow is subtle in light, near-invisible in dark (unnecessary on dark bg)
                        color: colorScheme == .dark
                            ? .clear
                            : .black.opacity(0.05),
                        radius: 8, x: 0, y: 2
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                    Spacer()

                    // MARK: Submit Button
                    Button {
                        // TODO: Hook up submission logic here
                    } label: {
                        Text("Submit Request")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(accent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .animation(.easeInOut(duration: 0.3), value: selection)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
            // MARK: Navigation
            .navigationTitle("Day-off Request")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview
// Previews both light and dark side by side in Xcode
#Preview("Light") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}
