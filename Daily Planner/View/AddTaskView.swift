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
    static let accentBlue = Color.blue
    static let accentPurple = Color.purple
    static let accentGreen = Color.green
    static let accentOrange = Color.orange
    static let backgroundPrimary = Color.black
    static let backgroundSecondary = Color(white: 0.1)
    static let cardBackground = Color(white: 0.15)

    
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
