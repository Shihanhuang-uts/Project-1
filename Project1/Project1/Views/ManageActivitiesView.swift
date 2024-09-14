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
    @State private var newSubtitle = ""
    @State private var newColor = Color.blue
    @State private var showAlert = false
    @State private var activityToDelete: StudyActivity?

    // State variables to control visibility of sections
    @State private var showIncompleteActivities = true
    @State private var showCompletedActivities = true

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Incomplete Activities Section
                sectionHeader(title: "Incomplete Activities", isExpanded: $showIncompleteActivities)
                
                if showIncompleteActivities {
                    LazyVStack(spacing: 10) {
                        ForEach($activities.filter { !$0.isCompleted.wrappedValue }) { $activity in
                            activityCard(activity: $activity)
                        }
                    }
                }
                
                // Completed Activities Section
                sectionHeader(title: "Completed Activities", isExpanded: $showCompletedActivities)
                
                if showCompletedActivities {
                    LazyVStack(spacing: 10) {
                        ForEach($activities.filter { $0.isCompleted.wrappedValue }) { $activity in
                            activityCard(activity: $activity)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete Activity"),
                message: Text("Are you sure you want to delete this activity?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let activityToDelete = activityToDelete {
                        deleteActivity(activityToDelete)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $isEditing) {
            EditActivityView(
                activity: $selectedActivity,
                newTitle: $newTitle,
                newSubtitle: $newSubtitle,
                newColor: $newColor,
                saveChanges: saveChanges
            )
        }
        .navigationTitle("Manage Activities")
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }

    private func sectionHeader(title: String, isExpanded: Binding<Bool>) -> some View {
        Button(action: {
            withAnimation {
                isExpanded.wrappedValue.toggle()
            }
        }) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: isExpanded.wrappedValue ? "chevron.down" : "chevron.right")
                    .foregroundColor(.blue)
                    .font(.headline)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func activityCard(activity: Binding<StudyActivity>) -> some View {
        HStack(alignment: .top) {
            Button(action: {
                activity.isCompleted.wrappedValue.toggle()
            }) {
                Image(systemName: activity.isCompleted.wrappedValue ? "checkmark.square.fill" : "square")
                    .foregroundColor(activity.isCompleted.wrappedValue ? .green : .gray)
                    .padding(.trailing, 10)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(activity.title.wrappedValue)
                    .font(.headline)
                    .foregroundColor(activity.isCompleted.wrappedValue ? .gray : .primary)
                if !activity.subtitle.wrappedValue.isEmpty {
                    Text(activity.subtitle.wrappedValue)
                        .font(.subheadline)
                        .foregroundColor(activity.isCompleted.wrappedValue ? .gray.opacity(0.7) : .secondary)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Button(action: {
                    activityToDelete = activity.wrappedValue
                    showAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                Button(action: {
                    startEditing(activity: activity.wrappedValue)
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(activity.isCompleted.wrappedValue ? Color.gray.opacity(0.2) : activity.color.wrappedValue)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }

    private func startEditing(activity: StudyActivity) {
        selectedActivity = activity
        newTitle = activity.title
        newSubtitle = activity.subtitle
        newColor = activity.color
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
            activities[index].subtitle = newSubtitle
            activities[index].color = newColor
        }
        isEditing = false
    }
}

struct ManageActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageActivitiesView(activities: .constant([
            StudyActivity(date: Date(), title: "Sample Activity", subtitle: "Sample Subtitle", color: .blue)
        ]))
    }
}
