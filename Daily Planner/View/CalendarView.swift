//
//  CalendarView.swift
//  Daily Planner
//
//  Created by Mayur on 16/09/25.
//
import SwiftUI

// MARK: - Calendar Extension
extension Calendar {
    func isDate(_ date1: Date, inSameYearMonthAs date2: Date) -> Bool {
        return isDate(date1, equalTo: date2, toGranularity: .year) &&
               isDate(date1, equalTo: date2, toGranularity: .month)
    }
}

// MARK: - CalendarView
struct CalendarView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var monthString: String {
        dateFormatter.string(from: currentMonth)
    }
    
    private var daysOfWeek: [String] {
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let daysFromPreviousMonth = firstWeekday - 1
        
        guard let firstDisplayDate = calendar.date(byAdding: .day, value: -daysFromPreviousMonth, to: monthStart) else {
            return []
        }
        
        var dates: [Date] = []
        var currentDate = firstDisplayDate
        
        // Generate 42 days (6 weeks)
        for _ in 0..<42 {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        return dates
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
                    VStack(spacing: 24) {
                        
                       
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
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Navigation Tabs
                        HStack(spacing: 12) {
//                            NavigationTab(title: "Dashboard", isSelected: false)
//                            NavigationTab(title: "Tasks", isSelected: false)
                            NavigationTab(title: "Calendar", isSelected: true)
                        }
                        .padding(.horizontal, 20)
                        
                        // Calendar View Header
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.accentBlue)
                                Text("Calendar View")
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            
                            // Month Navigation
                            HStack {
                                Button(action: { changeMonth(-1) }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.accentBlue)
                                }
                                
                                Spacer()
                                
                                Text(monthString)
                                    .font(.system(.title2, design: .rounded, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Button(action: { changeMonth(1) }) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.accentBlue)
                                }
                            }
                            
                            // Days of week
                            HStack {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    Text(day)
                                        .font(.system(.caption, design: .rounded, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            // Calendar Grid
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 1) {
                                ForEach(daysInMonth, id: \.self) { date in
                                    CalendarDayView(
                                        date: date,
                                        currentMonth: currentMonth,
                                        tasks: taskManager.tasksForDate(date),
                                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
                                    )
                                    .onTapGesture {
                                        selectedDate = date
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
                        
                        // Priority Legend and Stats
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Priority Legend")
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(.red)
                                            .frame(width: 12, height: 12)
                                        Text("High Priority")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundColor(.primary)
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color.orange)
                                            .frame(width: 12, height: 12)
                                        Text("Medium Priority")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("This Month")
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Text("Total Tasks")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundColor(.secondary)
                                        Text("\(tasksThisMonth().count)")
                                            .font(.system(.caption, design: .rounded, weight: .semibold))
                                            .foregroundColor(.primary)
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Text("Completed")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundColor(.secondary)
                                        Text("\(completedThisMonth())")
                                            .font(.system(.caption, design: .rounded, weight: .semibold))
                                            .foregroundColor(.accentGreen)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(white: 0.05))
                                .stroke(Color(white: 0.1), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        // Quick Actions
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Actions")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 12) {
                                QuickActionButton(
                                    title: "Go to Today",
                                    icon: "calendar.circle.fill",
                                    color: .accentGreen
                                ) {
                                    currentMonth = Date()
                                    selectedDate = Date()
                                }
                                
                                QuickActionButton(
                                    title: "Next Month",
                                    icon: "arrow.right.circle.fill",
                                    color: .accentBlue
                                ) {
                                    changeMonth(1)
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
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func changeMonth(_ direction: Int) {
        withAnimation(.easeInOut) {
            currentMonth = calendar.date(byAdding: .month, value: direction, to: currentMonth) ?? currentMonth
        }
    }
    
    private func tasksThisMonth() -> [Task] {
        return taskManager.tasks.filter { task in
            calendar.isDate(task.date, inSameYearMonthAs: currentMonth)
        }
    }
    
    private func completedThisMonth() -> Int {
        return tasksThisMonth().filter { $0.isCompleted }.count
    }
}

// MARK: - CalendarDayView
struct CalendarDayView: View {
    let date: Date
    let currentMonth: Date
    let tasks: [Task]
    let isSelected: Bool
    
    private let calendar = Calendar.current
    private var isCurrentMonth: Bool {
        calendar.isDate(date, inSameYearMonthAs: currentMonth)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    private var dayNumber: String {
        "\(calendar.component(.day, from: date))"
    }
    
    private var hasHighPriorityTasks: Bool {
        tasks.contains { $0.priority == .high && !$0.isCompleted }
    }
    
    private var hasMediumPriorityTasks: Bool {
        tasks.contains { $0.priority == .normal && !$0.isCompleted }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayNumber)
                .font(.system(.caption, design: .rounded, weight: isToday ? .bold : .medium))
                .foregroundColor(
                    isToday ? .white :
                    isCurrentMonth ? .primary : .secondary.opacity(0.5)
                )
            
            HStack(spacing: 2) {
                if hasHighPriorityTasks {
                    Circle()
                        .fill(.red)
                        .frame(width: 4, height: 4)
                }
                
                if hasMediumPriorityTasks {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 4, height: 4)
                }
                
                if tasks.filter({ $0.isCompleted }).count > 0 {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(height: 8)
        }
        .frame(width: 40, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    isToday ? .accentBlue :
                    isSelected ? Color(white: 0.2) :
                    Color.clear
                )
        )
    }
}

// MARK: - QuickActionButton
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.1))
            )
        }
    }
}
