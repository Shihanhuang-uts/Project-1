//
//  ManageActivitiesView.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import SwiftUI

struct ManageActivitiesView: View {
    @Binding var activities: [StudyActivity]

    @State private var isEditing = false
    @State private var selectedActivity: StudyActivity?
    @State private var newTitle = ""
    @State private var newDate = Date()

    var body: some View {
        List {
            ForEach(activities) { activity in
                VStack(alignment: .leading) {
                    Text(activity.title)
                        .font(.headline)
                    Text(activity.date, style: .date)
                        .font(.subheadline)

                    HStack {
                        Button(action: {
                            startEditing(activity: activity)
                        }) {
                            Text("Edit")
                                .foregroundColor(.blue)
                        }

                        Button(action: {
                            deleteActivity(activity)
                        }) {
                            Text("Delete")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 5)
                }
                .contentShape(Rectangle()) // Make the entire area tappable
                .onTapGesture {
                    startEditing(activity: activity)
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditActivityView(activity: $selectedActivity, newTitle: $newTitle, newDate: $newDate, saveChanges: saveChanges)
        }
        .navigationTitle("Manage Activities")
    }

    private func startEditing(activity: StudyActivity) {
        selectedActivity = activity
        newTitle = activity.title
        newDate = activity.date
        isEditing = true
    }

    private func deleteActivity(_ activity: StudyActivity) {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities.remove(at: index)
        }
    }

    private func saveChanges() {
        if let selectedActivity = selectedActivity,
           let index = activities.firstIndex(where: { $0.id == selectedActivity.id }) {
            activities[index].title = newTitle
            activities[index].date = newDate
        }
        isEditing = false
    }
}

struct ManageActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageActivitiesView(activities: .constant([StudyActivity(date: Date(), title: "Sample Activity")]))
    }
}
