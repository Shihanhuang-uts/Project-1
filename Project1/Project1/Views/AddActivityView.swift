//
//  AddActivityView.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import SwiftUI

struct AddActivityView: View {
    var selectedDate: Date
    @State private var activityTitle: String = ""
    var addActivity: (StudyActivity) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var isDateValid: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return selectedDate >= today
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Selected Date")
                .font(.headline)
            
            Text(selectedDate, style: .date)
                .font(.body)
            
            Text("Activity Title")
                .font(.headline)
            
            TextField("Enter activity title", text: $activityTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
            
            if isDateValid {
                Button(action: {
                    let newActivity = StudyActivity(date: selectedDate, title: activityTitle)
                    addActivity(newActivity)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Activity")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(activityTitle.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(activityTitle.isEmpty)
            } else {
                Text("You can only add activities for today or future dates.")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Add Activity")
    }
}
