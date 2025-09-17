//
//  DashboardView.swift
//  Daily Planner
//
//  Created by Mayur on 16/09/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddTask = false
    
    private var todaysTasks: [Task] {
        taskManager.todaysTasks()
    }
    
    private var totalTasks: Int {
        taskManager.tasks.count
    }
    
    private var completedToday: Int {
        todaysTasks.filter { $0.isCompleted }.count
    }
    
    private var pendingTasks: Int {
        todaysTasks.filter { !$0.isCompleted }.count
    }
    
    private var overdueTasks: [Task] {
        let calendar = Calendar.current
        let today = Date()
        return taskManager.tasks.filter { task in
            !task.isCompleted && calendar.compare(task.date, to: today, toGranularity: .day) == .orderedAscending
        }
    }
    
    private var upcomingTasks: [Task] {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        
        return taskManager.tasks.filter { task in
            !task.isCompleted &&
            calendar.compare(task.date, to: tomorrow, toGranularity: .day) != .orderedAscending &&
            calendar.compare(task.date, to: nextWeek, toGranularity: .day) != .orderedDescending
        }.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.backgroundPrimary, .backgroundSecondary],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Daily Planner")
                                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text("Organize your tasks and boost your productivity")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: { showingAddTask = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(red: 0.4, green: 0.7, blue: 1.0))
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Navigation Tabs
                        HStack(spacing: 12) {
                            NavigationTab(title: "Dashboard", isSelected: true)
//                            NavigationTab(title: "Tasks", isSelected: false)
//                            NavigationTab(title: "Calendar", isSelected: false)
                        }
                        .padding(.horizontal, 20)
                        
                        // Metrics Cards
                        HStack(spacing: 16) {
                            MetricCard(
                                title: "Total Tasks",
                                value: "\(totalTasks)",
                                icon: "list.bullet.clipboard",
                                color: .accentBlue
                            )
                            
                            MetricCard(
                                title: "Completed Today",
                                value: "\(completedToday)",
                                icon: "checkmark.circle.fill",
                                color: .accentGreen
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 16) {
                            MetricCard(
                                title: "Pending",
                                value: "\(pendingTasks)",
                                icon: "clock.fill",
                                color: .accentOrange
                            )
                            
                            MetricCard(
                                title: "Overdue",
                                value: "\(overdueTasks.count)",
                                icon: "exclamationmark.triangle.fill",
                                color: .red
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Today's Progress
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.accentGreen)
                                Text("Today's Progress")
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(completedToday)/\(todaysTasks.count)")
                                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Completed")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.secondary)
                                
                                ProgressView(value: taskManager.todaysProgress())
                                    .progressViewStyle(LinearProgressViewStyle(tint: .accentGreen))
                                    .frame(height: 8)
                                    .background(Color(white: 0.1))
                                    .cornerRadius(4)
                            }
                            
                            // Recent completed tasks
                            if !todaysTasks.filter({ $0.isCompleted }).isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(todaysTasks.filter { $0.isCompleted }.prefix(2)) { task in
                                        HStack(spacing: 8) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.accentGreen)
                                                .font(.system(size: 12))
                                            
                                            Text(task.title)
                                                .font(.system(.caption, design: .rounded))
                                                .foregroundColor(.secondary)
                                                .strikethrough()
                                            
                                            Spacer()
                                            
                                            Text(task.priority.rawValue.lowercased())
                                                .font(.system(.caption2, design: .rounded, weight: .medium))
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 2)
                                                .background(Capsule().fill(task.priority.color.opacity(0.2)))
                                                .foregroundColor(task.priority.color)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(white: 0.08))
                                .stroke(Color(white: 0.15), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        // Upcoming Tasks
                        if !upcomingTasks.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.accentBlue)
                                    Text("Upcoming Tasks")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                
                                ForEach(upcomingTasks.prefix(3)) { task in
                                    UpcomingTaskRow(task: task)
                                }
                                
                                if upcomingTasks.count > 3 {
                                    Button("View All") {
                                        // Navigate to tasks view
                                    }
                                    .font(.system(.caption, design: .rounded, weight: .medium))
                                    .foregroundColor(.accentBlue)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(white: 0.08))
                                    .stroke(Color(white: 0.15), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        // Overdue Tasks
                        if !overdueTasks.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text("Overdue Tasks")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                
                                ForEach(overdueTasks.prefix(3)) { task in
                                    OverdueTaskRow(task: task)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.red.opacity(0.1))
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        }
    }
}

struct NavigationTab: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(.subheadline, design: .rounded, weight: .medium))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .accentBlue : Color(white: 0.1))
            )
            .foregroundColor(isSelected ? .white : .secondary)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.08))
                .stroke(Color(white: 0.15), lineWidth: 1)
        )
    }
}

struct UpcomingTaskRow: View {
    let task: Task
    
    var body: some View {
        HStack(spacing: 12) {
            Text(task.title)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer()
            
            Text(DateFormatter.shortDateFormatter.string(from: task.date))
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            
            Text(task.priority.rawValue.lowercased())
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Capsule().fill(task.priority.color.opacity(0.2)))
                .foregroundColor(task.priority.color)
        }
        .padding(.vertical, 4)
    }
}

struct OverdueTaskRow: View {
    let task: Task
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                taskManager.toggleTaskCompletion(task)
            }) {
                Image(systemName: "circle")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("Due: \(DateFormatter.shortDateFormatter.string(from: task.date))")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            Text(task.priority.rawValue.lowercased())
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Capsule().fill(Color.red.opacity(0.2)))
                .foregroundColor(.red)
        }
        .padding(.vertical, 4)
    }
}
