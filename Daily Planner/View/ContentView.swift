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
            }
            .environmentObject(taskManager)
            .accentColor(Color("AccentBlue"))
        } else {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                .environmentObject(taskManager)
        }
    }
}
