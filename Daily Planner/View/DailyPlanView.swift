//
//  DailyPlanView.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//
import SwiftUI

struct DailyPlanView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddTask = false
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    
       @State private var reflectionText = ""
    @State private var showReflectionEditor = false
    
    private let quotes = [

        "Small steps every day lead to big results.",
        "Stay consistent, success will follow.",
        "Focus on progress, not perfection.",
        "Your only limit is your mind.",
        "Productivity is never an accident."
    ]
    
    private var randomQuote: String {
        quotes.randomElement() ?? "Stay motivated!"
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    colors: [.backgroundPrimary, .backgroundSecondary],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 10) {
                                        Text("Today")
                                            .font(.system(.title, design: .rounded, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        Button(action: {
                                            showingDatePicker.toggle()
                                        }) {
                                            Image(systemName: "calendar")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(.gray)
                                        }
                                        .sheet(isPresented: $showingDatePicker) {
                                            VStack {
                                                DatePicker(
                                                    "Select Date",
                                                    selection: $selectedDate,
                                                    displayedComponents: [.date]
                                                )
                                                .datePickerStyle(.graphical)
                                                .padding()
                                                
                                                Button("Done") {
                                                    showingDatePicker = false
                                                    loadReflection(for: selectedDate)
                                                }
                                                .font(.headline)
                                                .padding()
                                            }
                                        }
                                    }
                                    
                                    Text(DateFormatter.dayFormatter.string(from: selectedDate))
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: { showingAddTask = true }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 34, height: 34)
                                        .background(
                                            Circle()
                                                .fill(Color.blue)
                                                .shadow(color: .accentBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                                        )
                                }
                                .accessibilityLabel("Add new task")
                            }
                            
                            ProgressView(value: taskManager.progress(for: selectedDate))
                                .progressViewStyle(LinearProgressViewStyle(tint: .accentGreen))
                                .frame(height: 10)
                                .padding(.vertical, 8)
                            
                            Text("💡 \(randomQuote)")
                                .font(.system(.callout, design: .rounded))
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        
                        let selectedTasks = taskManager.tasksForDate(selectedDate)
                        if selectedTasks.isEmpty {
                            EmptyStateView()
                        } else {
                            TimelineView(tasks: selectedTasks)
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 120)
                    }
                }
                
               
                Button(action: {
                    showReflectionEditor = true
                }) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("Reflection")
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.9))
                    )
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                }
                .padding(.bottom, 10)
                .sheet(isPresented: $showReflectionEditor) {
                    ReflectionEditor(
                        date: selectedDate,
                        reflectionText: $reflectionText,
                        onSave: { text in
                            saveReflection(for: selectedDate, text: text)
                        }
                    )
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
            .onAppear {
                loadReflection(for: selectedDate)
            }
        }
    }
    
   
    private func saveReflection(for date: Date, text: String) {
        let key = reflectionKey(for: date)
        UserDefaults.standard.set(text, forKey: key)
    }
    
    private func loadReflection(for date: Date) {
        let key = reflectionKey(for: date)
        reflectionText = UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    private func reflectionKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "reflection-\(formatter.string(from: date))"
    }
}

struct ReflectionEditor: View {
    let date: Date
    @Binding var reflectionText: String
    var onSave: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Daily Reflection")
                    .font(.title2.bold())
                Text("What went well today?")
                    .font(.caption)
                
                
                
                
                Text(DateFormatter.dayFormatter.string(from: date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $reflectionText)
                    .padding()
                    .frame(minHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Spacer()
            }
            .padding()
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    onSave(reflectionText)
                    dismiss()
                }
                .bold()
            )
        }
    }
}
