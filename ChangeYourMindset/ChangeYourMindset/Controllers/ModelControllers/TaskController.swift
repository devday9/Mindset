//
//  TaskController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/30/20.
//

import UIKit
import CloudKit

class TaskController {
    
    //MARK: - Properties
    static let shared = TaskController()
    let publicDB = CKContainer.default().publicCloudDatabase
    var currentTask: Task?
    
//    func createTasksForDay { // figure out how to save tasks for a day to CK
//
//        let readTenPages = Task(name: "10 Pages of Reading", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let drinkOneGallon = Task(name: "Drink 1 Gallon of Water", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let workOut = Task(name: "45 Minute Workout", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let spiritual = Task(name: "15 Minutes of Prayer or Meditation", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let followDiet = Task(name: "Follow a Diet & No Cheat Meals", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let noAlcohol = Task(name: "No Alcohol/Drugs", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let takePhoto = Task(name: "Take Progress Pic", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//    }
    
    func toggleComplete(task: Task) {
        task.isComplete = !task.isComplete
    }
    
    func save(task: Task, completion: @escaping (Result<Task, MindsetError>) -> Void) {
        let taskRecord = CKRecord(task: task)
        publicDB.save(taskRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                  let savedTask = Task(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            print("Saved task successfully")
            completion(.success(savedTask))
        }
    }
    
    func update(task: Task, progressPhoto: UIImage?,
                completion: @escaping (Result<Task, MindsetError>) -> Void) {
        
        task.progressPhoto = progressPhoto
    }
}//END OF CLASS
