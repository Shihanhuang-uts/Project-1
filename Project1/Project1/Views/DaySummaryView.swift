//
//  DaySummaryView.swift
//  Project1
//
//  Created by Manyue on 14/9/2024.
//

import SwiftUI

struct DaySummaryView: View {
    @Binding var selectedDate: Date
    @Binding var activities: [StudyActivity]
    
    // State variable to store the summary text
    @State private var dailySummary: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Summary of the Day
            daySummary()
                .padding(.horizontal)

            // Daily Summary Input
            VStack(alignment: .leading, spacing: 10) {
                Text("Daily Summary")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                TextEditor(text: $dailySummary)
                    .frame(height: 150)
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .foregroundColor(.primary)
                    .font(.body)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .onChange(of: dailySummary) {
                        saveDailySummary()  // Auto-save when the summary text changes
                    }
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Day Summary")
        .padding(.top, 20)
        .onAppear(perform: loadDailySummary) // Load the summary when the view appears
    }

    @ViewBuilder
    private func daySummary() -> some View {
        // Calculate summary data
        let totalActivities = activities.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }.count
        let completedActivities = activities.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) && $0.isCompleted }.count
        let remainingActivities = totalActivities - completedActivities

        VStack(spacing: 10) {
            Text("Summary of the Day")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Total Activities:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("\(totalActivities)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 5) {
                    Text("Completed:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("\(completedActivities)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 5) {
                    Text("Remaining:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("\(remainingActivities)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            )
        }
    }
    
    private func saveDailySummary() {
        let dateKey = dateToString(selectedDate)
        UserDefaults.standard.set(dailySummary, forKey: dateKey)
        print("Daily Summary Auto-Saved for \(dateKey): \(dailySummary)")
    }
    
    private func loadDailySummary() {
        let dateKey = dateToString(selectedDate)
        dailySummary = UserDefaults.standard.string(forKey: dateKey) ?? ""
        print("Daily Summary Loaded for \(dateKey): \(dailySummary)")
    }
    
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct DaySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DaySummaryView(selectedDate: .constant(Date()), activities: .constant([]))
    }
}

