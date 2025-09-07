//
//  TaskTimelineCard.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//

import SwiftUI


struct TimelineView: View {
    let tasks: [Task]
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        ZStack(alignment: .leading) {
           
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 4)
                .padding(.leading, 66)
            
            VStack(spacing: 20) {
                ForEach(tasks) { task in
                    TaskTimelineCard(task: task)
                }
            }
        }
        .padding(.vertical, 20)
    }
}


struct TaskTimelineCard: View {
    let task: Task
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
          
            VStack {
                Text(task.displayTime)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundColor(.secondary)
                    .dynamicTypeSize(.medium)
                
                Circle()
                    .fill(task.priority.color)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(task.category.color, lineWidth: 2)
                    )
                    .shadow(color: task.priority.color.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .frame(width: 60)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Task time: \(task.displayTime)")
            
            // Task Card
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        taskManager.toggleTaskCompletion(task)
                    }
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(task.isCompleted ? .accentGreen : .secondary)
                }
                .accessibilityLabel(task.isCompleted ? "Mark task as incomplete" : "Mark task as complete")
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                        .strikethrough(task.isCompleted)
                        .dynamicTypeSize(.large)
                    
                    if !task.description.isEmpty {
                        Text(task.description)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .dynamicTypeSize(.medium)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: task.category.icon)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(task.category.color)
                        
                        Text(task.category.rawValue)
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(task.category.color)
                            .dynamicTypeSize(.small)
                        
                        if task.priority != .normal {
                            Text("•")
                                .foregroundColor(.secondary.opacity(0.5))
                            
                            Text(task.priority.rawValue)
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(task.priority.color)
                                .dynamicTypeSize(.small)
                        }
                    }
                }
                
                Spacer()
                
               
                if task.isCompleted {
                    Button {
                        withAnimation {
                            taskManager.deleteTask(task)
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(8)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(white: 0.15))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .shadow(color: .white.opacity(0.1), radius: 8, x: 0, y: -4)
            )
        }
        .animation(.easeInOut, value: task.isCompleted)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(task.title), \(task.category.rawValue) task, priority \(task.priority.rawValue), \(task.isCompleted ? "completed" : "not completed")")
    }
}

struct EmptyStateView: View {
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.day.timeline.leading")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.secondary.opacity(0.5))
                .scaleEffect(animate ? 1.0 : 0.9)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)
            
            VStack(spacing: 8) {
                Text("Your day is clear!")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundColor(.primary)
                    .dynamicTypeSize(.xLarge)
                
                Text("Add some tasks to get started")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .dynamicTypeSize(.large)
            }
            
            .accessibilityLabel("Add a new task")
        }
        .padding(.top, 80)
        .onAppear {
            animate = true
        }
    }
}
