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
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    var tasks: [Task] {
        //        guard let challenge = ChallengeController.shared.currentChallenge else { return []}
        
        //        let reference = CKRecord.Reference(recordID: challenge.recordID , action: .none)
           
           let readTenPages = Task(name: "10 Pages of Reading ", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
           
           let drinkOneGallon = Task(name: "Drink 1 Gallon of Water", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
           
           let workOut = Task(name: "45 Minute Workout", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
           
           let spiritual = Task(name: "15 Minutes of Prayer or Meditation", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
           
           let followDiet = Task(name: "Follow a Diet & No Cheat Meals", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
           
           let noAlcohol = Task(name: "No Alcohol/Drugs", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
           
           let takePhoto = Task(name: "Take Progress Pic", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
           
           
           return [readTenPages, drinkOneGallon, workOut, spiritual, followDiet, noAlcohol, takePhoto]
    }
        
    
    //MARK: - Helper Functions
//    func createTasks() -> [Task] {
//
//        let readTenPages = Task(name: "10 Pages of Reading ", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let drinkOneGallon = Task(name: "Drink 1 Gallon of Water", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let workOut = Task(name: "45 Minute Workout", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let spiritual = Task(name: "15 minutes of Prayer/ Meditation", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let followDiet = Task(name: "Follow a Diet/ No Cheat Meals", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let noAlcohol = Task(name: "No Alcohol/Drugs", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//        let takePhoto = Task(name: "Take Progress Pic", isComplete: false, dayReference: nil, challengeReference: nil, progressPhoto: nil)
//
//
//        return [readTenPages, drinkOneGallon, workOut, spiritual, followDiet, noAlcohol, takePhoto]
//
//    }
    
    func toggleComplete(task: Task) {
        task.isComplete = !task.isComplete
    }
    
    func save(task: Task, completion: @escaping (Result<Task, MindsetError>) -> Void) {
        
        let taskRecord = CKRecord(task: task)
        privateDB.save(taskRecord) { (record, error) in
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
