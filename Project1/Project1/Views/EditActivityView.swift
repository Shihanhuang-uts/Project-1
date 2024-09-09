//
//  EditActivityView.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import SwiftUI

struct EditActivityView: View {
    @Binding var activity: StudyActivity?
    @Binding var newTitle: String
    @Binding var newDate: Date
    var saveChanges: () -> Void

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Activity Title")) {
                    TextField("Enter new title", text: $newTitle)
                }

                Section(header: Text("Edit Activity Date")) {
                    DatePicker("Select new date", selection: $newDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Activity")
            .navigationBarItems(trailing: Button("Save") {
                saveChanges()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct EditActivityView_Previews: PreviewProvider {
    static var previews: some View {
        EditActivityView(activity: .constant(nil), newTitle: .constant(""), newDate: .constant(Date()), saveChanges: {})
    }
}


