//
//  TaskController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/30/20.
//

import Foundation

class TaskController {
    static let shared = TaskController()
    
    func toggleComplete(task: Task) {
        task.isComplete = !task.isComplete
    }
}
