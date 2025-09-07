//
//  Task.swift
//  Daily Planner
//
//  Created by Mayur on 05/09/25.
//

import Foundation
import SwiftUICore
import UserNotifications

// MARK: - Task Model Update
struct Task: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var date: Date
    var time: Date?
    var isCompleted: Bool = false
    var category: TaskCategory = .personal
    var priority: Priority = .normal
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case normal = "Normal"
        case high = "High"
        
        var color: Color {
            switch self {
            case .low: return .gray
            case .normal: return .accentBlue 
            case .high: return .red
            }
        }
    }
    
    var displayTime: String {
        guard let time = time else { return "No time set" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

enum TaskCategory: String, CaseIterable, Codable {
    case work = "Work"
    case personal = "Personal"
    case health = "Health"
    case shopping = "Shopping"
    
    var color: Color {
        switch self {
        case .work: return .accentBlue
        case .personal: return .accentPurple
        case .health: return .accentGreen
        case .shopping: return .accentOrange
        }
    }
    
    var icon: String {
        switch self {
        case .work: return "briefcase.fill"
        case .personal: return "person.fill"
        case .health: return "heart.fill"
        case .shopping: return "cart.fill"
        }
    }
}
