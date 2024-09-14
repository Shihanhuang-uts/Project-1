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
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                // Centered "Study Plan" Text
                Text("Study Plan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                CustomCalendarView(selectedDate: $selectedDate, activities: activities)
                    .padding()

                ScrollView {
                    LazyVStack(spacing: 10) {
                        let filteredActivities = activities.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }

                        let incompleteActivities = filteredActivities.filter { !$0.isCompleted }

                        VStack {
                            if incompleteActivities.isEmpty {
                                Text("You've done everything today, Good Job!")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach($activities.filter { Calendar.current.isDate($0.date.wrappedValue, inSameDayAs: selectedDate) }) { $activity in
                                        HStack {
                                            Button(action: {
                                                activity.isCompleted.toggle()
                                                saveActivities() // Auto-save activities when completed status changes
                                            }) {
                                                Image(systemName: activity.isCompleted ? "checkmark.square.fill" : "square")
                                                    .foregroundColor(activity.isCompleted ? .green : .gray)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(activity.title)
                                                    .font(.headline)
                                                    .foregroundColor(activity.isCompleted ? .gray : .black)
                                                if !activity.subtitle.isEmpty {
                                                    Text(activity.subtitle)
                                                        .font(.subheadline)
                                                        .foregroundColor(activity.isCompleted ? .gray.opacity(0.7) : .black.opacity(0.7))
                                                }
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(activity.isCompleted ? Color.gray.opacity(0.2) : activity.color)
                                        .cornerRadius(10)
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
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: AddActivityView(selectedDate: selectedDate, addActivity: { activity in
                        activities.append(activity)
                        saveActivities() // Save the activity after adding it
                    })) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .padding()

                    Spacer()

                    NavigationLink(destination: DaySummaryView(selectedDate: $selectedDate, activities: $activities)) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.purple)
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
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)  // Hide the default navigation bar title
        }
        .onAppear(perform: loadActivities) // Load activities when the view appears
    }

    // MARK: - Functions
    private func saveActivities() {
        do {
            let data = try JSONEncoder().encode(activities)
            UserDefaults.standard.set(data, forKey: "savedActivities")
        } catch {
            print("Failed to save activities: \(error)")
        }
    }

    private func loadActivities() {
        if let data = UserDefaults.standard.data(forKey: "savedActivities") {
            do {
                activities = try JSONDecoder().decode([StudyActivity].self, from: data)
            } catch {
                print("Failed to load activities: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

