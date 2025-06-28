//
//  Todo.swift
//  MinimalToDo
//
//  Created by Gustavo Souto Pereira on 27/06/25.
//

import SwiftUI
import SwiftData

@Model
class Todo{
    private(set) var taskID: String = UUID().uuidString
    var task: String
    var isCompleted: Bool = false
    var priority: Priority = Priority.normal
    var lastUpdated: Date = Date.now
    
    init(task: String,  priority: Priority) {
        self.task = task
        self.priority = priority
    }
    
}

enum Priority: String, CaseIterable, Codable {
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}

