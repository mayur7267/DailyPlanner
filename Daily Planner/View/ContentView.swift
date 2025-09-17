//
//  ContentView.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskManager = TaskManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        if hasSeenOnboarding {
            TabView {
                DashboardView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Dashboard")
                    }
                
                DailyPlanView()
                    .tabItem {
                        Image(systemName: "calendar.day.timeline.leading")
                        Text("Today")
                    }
                
                TodoView()
                    .tabItem {
                        Image(systemName: "checklist")
                        Text("Tasks")
                    }
                
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
            }
            .environmentObject(taskManager)
            .accentColor(.accentBlue)
            .preferredColorScheme(.dark)
        } else {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                .environmentObject(taskManager)
        }
    }
}
