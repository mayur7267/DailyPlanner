//
//  AddTaskView.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    let editingTask: Task?
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedDate = Date()
    @State private var hasTime = false
    @State private var selectedTime = Date()
    @State private var selectedCategory = TaskCategory.personal
    @State private var selectedPriority = Task.Priority.normal
    
    init(editingTask: Task? = nil) {
        self.editingTask = editingTask
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
                    VStack(spacing: 20) {
                        
                        
                        InputSection(title: "Task Title") {
                            TextField("What do you need to do?", text: $title)
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.15)))
                        }
                        
                        
                        InputSection(title: "Description (Optional)") {
                            TextField("Add more details...", text: $description, axis: .vertical)
                                .padding(12)
                                .frame(minHeight: 80, alignment: .top)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.15)))
                        }
                        
                        
                        InputSection(title: "Category") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(TaskCategory.allCases, id: \.self) { category in
                                    Button {
                                        selectedCategory = category
                                    } label: {
                                        HStack(spacing: 6) {
                                            Image(systemName: category.icon)
                                            Text(category.rawValue)
                                        }
                                        .font(.system(.caption, design: .rounded))
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedCategory == category ? category.color : .cardBackground)
                                        )
                                        .foregroundColor(selectedCategory == category ? .white : category.color)
                                    }
                                }
                            }
                        }
                        
                       
                        InputSection(title: "Priority") {
                            HStack(spacing: 12) {
                                ForEach(Task.Priority.allCases, id: \.self) { priority in
                                    Button {
                                        selectedPriority = priority
                                    } label: {
                                        Text(priority.rawValue)
                                            .font(.system(.caption, design: .rounded))
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(selectedPriority == priority ? priority.color : .cardBackground)
                                            )
                                            .foregroundColor(selectedPriority == priority ? .white : priority.color)
                                    }
                                }
                            }
                        }
                        
                        
                        InputSection(title: "Date") {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.15)))
                        }
                        
                        
                        InputSection {
                            Toggle("Set specific time", isOn: $hasTime)
                                .toggleStyle(SwitchToggleStyle(tint: selectedCategory.color))
                        }
                        
                        if hasTime {
                            DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.15)))
                                .transition(.opacity)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingTask == nil ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.purple)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(editingTask == nil ? "Add" : "Update") {
                        saveTask()
                    }
                    .foregroundColor(.purple)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let task = Task(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            date: selectedDate,
            time: hasTime ? selectedTime : nil,
            category: selectedCategory,
            priority: selectedPriority
        )
        
        if let editingTask = editingTask {
            var updatedTask = task
            updatedTask = Task(
                title: task.title,
                description: task.description,
                date: task.date,
                time: task.time,
                isCompleted: editingTask.isCompleted,
                category: task.category,
                priority: task.priority
            )
            taskManager.updateTask(updatedTask)
        } else {
            taskManager.addTask(task)
        }
        
        dismiss()
    }
}


struct InputSection<Content: View>: View {
    var title: String?
    @ViewBuilder var content: Content
    
    init(title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundColor(.primary)
            }
            content
        }
    }
}



extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
}

import SwiftUI



import SwiftUI

extension Color {
    // Primary theme colors - Enhanced dark theme
    static let accentBlue = Color(red: 0.4, green: 0.7, blue: 1.0)        // #66B3FF
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)      // #9966FF
    static let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.4)       // #4DCC66
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)      // #FF9933
    
    // Background colors for deep dark theme
    static let backgroundPrimary = Color(red: 0.05, green: 0.05, blue: 0.05)     // #0D0D0D
    static let backgroundSecondary = Color(red: 0.08, green: 0.08, blue: 0.1)    // #141419
    static let cardBackground = Color(red: 0.1, green: 0.1, blue: 0.12)          // #1A1A1F
    
    // Text and UI colors
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.7)
    static let border = Color(white: 0.15)
    
    // Priority colors
    static let priorityHigh = Color(red: 1.0, green: 0.3, blue: 0.3)      // #FF4D4D
    static let priorityMedium = Color(red: 1.0, green: 0.8, blue: 0.2)    // #FFCC33
    static let priorityLow = Color(white: 0.6)                            // #999999
    
    // Color name initializer for backward compatibility
    init(_ name: String) {
        switch name {
        case "AccentBlue":
            self = .accentBlue
        case "AccentPurple":
            self = .accentPurple
        case "AccentGreen":
            self = .accentGreen
        case "AccentOrange":
            self = .accentOrange
        case "BackgroundPrimary":
            self = .backgroundPrimary
        case "BackgroundSecondary":
            self = .backgroundSecondary
        case "CardBackground":
            self = .cardBackground
        default:
            self = .gray
        }
    }
}
