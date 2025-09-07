//
//  TaskManager.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//

import Foundation
import UserNotifications

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    @Published private(set) var completedToday: Int = 0
    
    init() {
        loadTasks()
        requestNotificationPermission()
        restoreCompletedToday()
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
        scheduleNotification(for: task)
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
            scheduleNotification(for: task)
        }
    }
    
    func deleteTask(_ task: Task) {
       
        tasks.removeAll { $0.id == task.id }
        saveTasks()
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [task.id.uuidString]
        )
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            
            if tasks[index].isCompleted {
                completedToday += 1
            } else {
                completedToday = max(0, completedToday - 1)
            }
            
            saveTasks()
            saveCompletedToday()
        }
    }
    
    func todaysTasks() -> [Task] {
        let calendar = Calendar.current
        let today = Date()
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: today) }
            .sorted { (task1, task2) in
              
                if task1.priority != task2.priority {
                    return task1.priority.rawValue > task2.priority.rawValue
                }
                guard let time1 = task1.time, let time2 = task2.time else {
                    return task1.time != nil
                }
                return time1 < time2
            }
    }
    
    func todaysProgress() -> Double {
        let todayTasks = todaysTasks()
        guard !todayTasks.isEmpty else { return 0 }
        let completed = todayTasks.filter { $0.isCompleted }.count
        return Double(completed) / Double(todayTasks.count)
    }
    
    func tasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { (task1, task2) in
                if task1.priority != task2.priority {
                    return task1.priority.rawValue > task2.priority.rawValue
                }
                guard let time1 = task1.time, let time2 = task2.time else {
                    return task1.time != nil
                }
                return time1 < time2
            }
    }

    func progress(for date: Date) -> Double {
        let dayTasks = tasksForDate(date)
        guard !dayTasks.isEmpty else { return 0 }
        let completed = dayTasks.filter { $0.isCompleted }.count
        return Double(completed) / Double(dayTasks.count)
    }


    
   
    
    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: "savedTasks")
        }
    }
    
    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: "savedTasks"),
              let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) else {
            return
        }
        tasks = decodedTasks
    }
    
    private func saveCompletedToday() {
        UserDefaults.standard.set(completedToday, forKey: "completedToday")
    }
    
    private func restoreCompletedToday() {
        completedToday = UserDefaults.standard.integer(forKey: "completedToday")
    }
    
  
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    private func scheduleNotification(for task: Task) {
        guard let time = task.time else { return }
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.description.isEmpty ? "Time to complete this task!" : task.description
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
