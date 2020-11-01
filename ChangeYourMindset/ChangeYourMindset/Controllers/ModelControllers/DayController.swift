//
//  DayController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/30/20.
//

import Foundation
import CloudKit

class DayController {
    
    //MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    static let shared = DayController()
    var days: [Day] = []
    
    init() {
        createDays(numberOfDays: 75)
    }
    
    //MARK: - Helper Functions
    func createDays(numberOfDays: Int) {
        
        guard let user = UserController.shared.currentUser else { return }
        
        let reference = CKRecord.Reference(recordID: user.recordID, action: .none)
        
        for day in 1...numberOfDays {
            let day = Day(dayNumber: day, dailyJournal: "", allTasksAreComplete: false, tasks: [], challengeReference: reference, userReference: reference, dailyProgressPhoto: nil)
            days.append(day)
        }
    }
    
    func fetchAllDays(completion: @escaping (Result<[Day]?, MindsetError>) -> Void) {
        
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: DayStrings.recordTypeKey, predicate: fetchAllPredicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            print("Fetched Days successfully")
            
            let fetchedDays = records.compactMap({ Day(ckrecord: $0) })
            completion(.success(fetchedDays))
        }
    }
    
    func update(_ day: Day, completion: @escaping (Result<Day, MindsetError>) -> Void) {
        
        let recordToUpdate = CKRecord(day: day)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = records?.first,
                  let updatedDay = Day(ckrecord: record) else { return completion(.failure(.couldNotUnwrap))}
            completion(.success(updatedDay))
        }
        privateDB.add(operation)
    }
}//END OF CLASS
