//
//  Maintabfile.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selection: Int = 0
    private var dateWrapper = DateWrapper(dateSelected: .now)
    
    var body: some View {
        TabView(selection: $selection) {
            CalendarPageView(vm: CalendarPageViewModel(dateWrapper: dateWrapper))
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(0)
            
            StudySeriesPageView(vm: SeriesListViewModel())
                .tabItem {
                    Label("Studies", systemImage: "book")
                }
                .tag(1)
        }
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    MainTabView()
}
