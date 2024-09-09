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
                CustomCalendarView(selectedDate: $selectedDate, activities: activities)
                    .padding()

                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(activities.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) { activity in
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(activity.title)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    if !activity.subtitle.isEmpty {
                                        Text(activity.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .background(activity.color)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
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
                .padding(.bottom, 20)
            }
            .navigationTitle("Study Plan")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
