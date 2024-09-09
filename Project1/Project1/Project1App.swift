//
//  Project1App.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import SwiftUI
import SwiftData

@main
struct StudyPlannerApp: App {
    
    let dateWrapper = DateWrapper(dateSelected: .now)
    
    let container: ModelContainer = {
        let schema = Schema([StudySeries.self, StudySession.self])
        let config = ModelConfiguration(for: StudySeries.self, StudySession.self, isStoredInMemoryOnly: false)
        do {
            let container = try ModelContainer(for: schema, configurations: config)
            return container
        } catch {
            // Consider providing more user-friendly error handling here
            fatalError("Failed to load model container: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
            // Use the view model with the container if needed
            // CalendarPageView(vm: CalendarPageViewModel(dateWrapper: dateWrapper, modelContainer: container))
        }
    }
}
