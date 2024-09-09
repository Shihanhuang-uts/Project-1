//
//  calendarview.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import SwiftUI

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    var activities: [StudyActivity]

    private var daysInMonth: [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: selectedDate) else { return [] }
        let startOfMonth = monthInterval.start
        let daysRange = Calendar.current.range(of: .day, in: .month, for: selectedDate)!
        return daysRange.compactMap { Calendar.current.date(byAdding: .day, value: $0 - 1, to: startOfMonth) }
    }

    private var weekDayNames: [String] {
        let formatter = DateFormatter()
        return formatter.shortWeekdaySymbols
    }

    var body: some View {
        VStack {
            // Weekday Header
            HStack {
                ForEach(weekDayNames, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }

            let days = daysInMonth
            let columns = Array(repeating: GridItem(.flexible()), count: 7)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(days, id: \.self) { day in
                    ZStack {
                        // Day Number
                        VStack {
                            Text("\(Calendar.current.component(.day, from: day))")
                                .font(.headline)
                                .fontWeight(Calendar.current.isDate(day, inSameDayAs: selectedDate) ? .bold : .regular)
                                .foregroundColor(Calendar.current.isDate(day, inSameDayAs: selectedDate) ? .blue : .primary)
                                .onTapGesture {
                                    selectedDate = day
                                }
                            Spacer() // Space to push dots down
                        }
                        VStack {
                            Spacer()
                            HStack(spacing: 3) {
                                // Display up to 3 dots
                                ForEach(getDotsForDay(day), id: \.self) { color in
                                    Circle()
                                        .fill(color)
                                        .frame(width: 6, height: 6)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    .background(
                        Calendar.current.isDate(day, inSameDayAs: selectedDate) ? Color.blue.opacity(0.2) : Color.clear
                    )
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }

    private func getDotsForDay(_ day: Date) -> [Color] {
        let dayActivities = activities.filter { Calendar.current.isDate($0.date, inSameDayAs: day) }
        return Array(dayActivities.prefix(3).map { $0.color })
    }
}
