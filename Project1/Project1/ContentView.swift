//
//  ContentView.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var activities: [StudyActivity] = []
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                // Use a ForEach inside the List to avoid unnecessary reloading of the List
                List {
                    ForEach(activities.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) { activity in
                        Text(activity.title)
                    }
                    .onDelete(perform: deleteActivity)
                }
                
                Spacer() // Push buttons to the bottom
                
                HStack {
                    NavigationLink(destination: AddActivityView(selectedDate: selectedDate, addActivity: { activity in
                        activities.append(activity)
                    })) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink(destination: ManageActivitiesView(activities: $activities)) {
                        Image(systemName: "list.bullet.rectangle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                    }
                    .padding()
                }
                .padding(.bottom, 20) // Add padding to the bottom for safe area
            }
            .navigationTitle("Study Plan")
        }
    }
    
    // Function to delete an activity
    private func deleteActivity(at offsets: IndexSet) {
        let filteredActivities = activities.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        for index in offsets {
            if let activityIndex = activities.firstIndex(where: { $0.id == filteredActivities[index].id }) {
                activities.remove(at: activityIndex)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

