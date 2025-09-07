//
//  TaskCard.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//

import SwiftUI
struct TaskCard: View {
    let task: Task
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingEditTask = false
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                taskManager.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(task.isCompleted ? Color("AccentGreen") : .secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                    .strikethrough(task.isCompleted)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: task.category.icon)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(task.category.color)
                        
                        Text(task.category.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(task.category.color)
                    }
                    
                    Text("•")
                        .foregroundColor(.secondary.opacity(0.5))
                    
                    Text(DateFormatter.shortDateFormatter.string(from: task.date))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    if task.time != nil {
                        Text("•")
                            .foregroundColor(.secondary.opacity(0.5))
                        
                        Text(task.displayTime)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Menu {
                Button("Edit") {
                    showingEditTask = true
                }
                
                Button("Delete", role: .destructive) {
                    taskManager.deleteTask(task)
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 32, height: 32)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                .shadow(color: Color.white.opacity(0.1), radius: 8, x: 0, y: -4)
        )
        .sheet(isPresented: $showingEditTask) {
            AddTaskView(editingTask: task)
        }
    }
}
