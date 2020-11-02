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
    
    static var tasks: [Task] {
        guard let challenge = ChallengeController.shared.currentChallenge else { return []}
        
        let reference = CKRecord.Reference(recordID: challenge.recordID , action: .none)
        
        let readTenPages = Task(name: "10 Pages of Reading ", isComplete: false, challengeReference: reference, progressPhoto: nil)
        
        let drinkOneGallon = Task(name: "Drink 1 Gallon of Water", isComplete: false, challengeReference: reference, progressPhoto: nil)
        
        let workOut = Task(name: "45 Minute Workout", isComplete: false, challengeReference: reference, progressPhoto: nil)
        
        let spiritual = Task(name: "15 minutes of Prayer/ Meditation", isComplete: false, challengeReference: reference, progressPhoto: nil)
        
        let followDiet = Task(name: "Follow a Diet/ No Cheat Meals", isComplete: false, challengeReference: reference, progressPhoto: nil)
        
        let noAlcohol = Task(name: "No Alcohol/Drugs", isComplete: false, challengeReference: reference, progressPhoto: nil)
        
        let takePhoto = Task(name: "Take Progress Pic", isComplete: false, challengeReference: reference, progressPhoto: nil)


        return [readTenPages, drinkOneGallon, workOut, spiritual, followDiet, noAlcohol, takePhoto]
    }
    
    //MARK: - Helper Functions
    func toggleComplete(task: Task) {
        task.isComplete = !task.isComplete
    }
    //completion
    func update(task: Task, progressPhoto: UIImage?) {
        task.progressPhoto = progressPhoto
    }
}//END OF CLASS
