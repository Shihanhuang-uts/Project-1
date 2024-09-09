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
    @Binding var newSubtitle: String
    @Binding var newColor: Color
    var saveChanges: () -> Void

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Activity Title")) {
                    TextField("Enter new title", text: $newTitle)
                }

                Section(header: Text("Edit Activity Subtitle")) {
                    TextField("Enter new subtitle", text: $newSubtitle)
                }

                Section(header: Text("Select a Color")) {
                    ColorPicker("Pick a color", selection: $newColor)
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
        EditActivityView(
            activity: .constant(nil),
            newTitle: .constant("Sample Title"),
            newSubtitle: .constant("Sample Subtitle"),
            newColor: .constant(.blue),
            saveChanges: {}
        )
    }
}
