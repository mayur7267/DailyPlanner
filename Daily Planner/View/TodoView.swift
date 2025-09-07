//
//  TodoView.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddTask = false
    @State private var selectedCategory: TaskCategory? = nil
    @State private var selectedPriority: Task.Priority? = nil
    @State private var showingFilters = false
    
    var filteredTasks: [Task] {
        var tasks = taskManager.tasks
        
        // Filter by category
        if let selectedCategory = selectedCategory {
            tasks = tasks.filter { $0.category == selectedCategory }
        }
        
        // Filter by priority
        if let selectedPriority = selectedPriority {
            tasks = tasks.filter { $0.priority == selectedPriority }
        }
        
        return tasks.sorted(by: { $0.date > $1.date })
    }
    
    var hasActiveFilters: Bool {
        selectedCategory != nil || selectedPriority != nil
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
                    LazyVStack(spacing: 20) {
                        
                       
                        HStack {
                            Text("Tasks")
                                .font(.system(.title, design: .rounded, weight: .bold))
                                .foregroundColor(.primary)
                                .dynamicTypeSize(.xLarge)
                            
                            Spacer()
                            
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showingFilters.toggle()
                                }
                            }) {
                                Image(systemName: hasActiveFilters ? "slider.horizontal.3" : "slider.horizontal.3")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(hasActiveFilters ? .white : .purple)
                                    .frame(width: 34, height: 34)
                                    .background(
                                        Circle()
                                            .fill(hasActiveFilters ? Color.purple : Color.clear)
//
                                    )
                            }
                            .accessibilityLabel("Toggle filters")
                            
                          
                            Button(action: { showingAddTask = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 34, height: 34)
                                    .background(
                                        Circle()
                                            .fill(Color.purple)
                                            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                                    )
                            }
                            .accessibilityLabel("Add new task")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                       
                        if showingFilters {
                            VStack(spacing: 16) {
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Filter by Category")
                                        .font(.system(.caption, design: .rounded, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            
                                            Button(action: { selectedCategory = nil }) {
                                                Text("All")
                                                    .font(.system(.caption, design: .rounded, weight: .medium))
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .fill(selectedCategory == nil ? Color.purple : Color(white: 0.15))
                                                    )
                                                    .foregroundColor(selectedCategory == nil ? .white : .primary)
                                            }
                                            
                                            ForEach(TaskCategory.allCases, id: \.self) { category in
                                                Button(action: {
                                                    selectedCategory = selectedCategory == category ? nil : category
                                                }) {
                                                    HStack(spacing: 4) {
                                                        Image(systemName: category.icon)
                                                            .font(.system(size: 10))
                                                        Text(category.rawValue)
                                                            .font(.system(.caption, design: .rounded, weight: .medium))
                                                    }
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .fill(selectedCategory == category ? category.color : Color(white: 0.15))
                                                    )
                                                    .foregroundColor(selectedCategory == category ? .white : category.color)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                                
                               
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Filter by Priority")
                                        .font(.system(.caption, design: .rounded, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                    
                                    HStack(spacing: 8) {
                                      
                                        Button(action: { selectedPriority = nil }) {
                                            Text("All")
                                                .font(.system(.caption, design: .rounded, weight: .medium))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(selectedPriority == nil ? Color.purple : Color(white: 0.15))
                                                )
                                                .foregroundColor(selectedPriority == nil ? .white : .primary)
                                        }
                                        
                                        ForEach(Task.Priority.allCases, id: \.self) { priority in
                                            Button(action: {
                                                selectedPriority = selectedPriority == priority ? nil : priority
                                            }) {
                                                Text(priority.rawValue)
                                                    .font(.system(.caption, design: .rounded, weight: .medium))
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .fill(selectedPriority == priority ? priority.color : Color(white: 0.15))
                                                    )
                                                    .foregroundColor(selectedPriority == priority ? .white : priority.color)
                                            }
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                }
                                
                                // Clear filters button
                                if hasActiveFilters {
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            selectedCategory = nil
                                            selectedPriority = nil
                                        }
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 12))
                                            Text("Clear Filters")
                                                .font(.system(.caption, design: .rounded, weight: .medium))
                                        }
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(white: 0.1))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(white: 0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.secondary.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        
                        
                        if filteredTasks.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: hasActiveFilters ? "magnifyingglass" : "checklist")
                                    .font(.system(size: 60, weight: .light))
                                    .foregroundColor(.secondary.opacity(0.5))
                                
                                VStack(spacing: 8) {
                                    Text(hasActiveFilters ? "No matching tasks" : "No tasks yet")
                                        .font(.system(.title3, design: .rounded, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .dynamicTypeSize(.xLarge)
                                    
                                    Text(hasActiveFilters ? "Try adjusting your filters" : "Create your first task to get organized")
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(.secondary)
                                        .dynamicTypeSize(.large)
                                }
                                
                                if hasActiveFilters {
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            selectedCategory = nil
                                            selectedPriority = nil
                                        }
                                    }) {
                                        Text("Clear Filters")
                                            .font(.system(.callout, design: .rounded, weight: .medium))
                                            .foregroundColor(.purple)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.purple, lineWidth: 1)
                                            )
                                    }
                                }
                            }
                            .padding(.top, 80)
                        } else {
                           
                            if hasActiveFilters {
                                HStack {
                                    Text("\(filteredTasks.count) task\(filteredTasks.count == 1 ? "" : "s") found")
                                        .font(.system(.caption, design: .rounded, weight: .medium))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            ForEach(filteredTasks) { task in
                                TaskCard(task: task)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        }
    }
}
