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
    
    //MARK: - CRUD Functions
    func createDays(numberOfDays: Int, completion: @escaping (Result<[Day], MindsetError>) -> Void) {
        
        guard let challenge = ChallengeController.shared.currentChallenge else { return }
        
        let reference = CKRecord.Reference(recordID: challenge.recordID, action: .deleteSelf)
        
        var days: [Day] = []
        
        let dispatchGroup = DispatchGroup()
        
        for dayNumber in 1...numberOfDays {
            dispatchGroup.enter()
            let day = Day(dayNumber: dayNumber, challengeReference: reference)
            
            let dayRecord = CKRecord(day: day)
            
            privateDB.save(dayRecord) { (record, error) in
                if let error = error {
                    completion(.failure(.ckError(error)))
                }
                
                guard let record = record,
                      let savedDay = Day(ckrecord: record) else { return completion(.failure(.couldNotUnwrap))}
                print("Saved day successfully")
                
                days.append(savedDay)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("DispatchGroup.notify about to complete success days")
            completion(.success(days))
        }
    }
    
    func fetchAllDays(completion: @escaping (Result<[Day], MindsetError>) -> Void) {
        
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: DayStrings.recordTypeKey, predicate: fetchAllPredicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            print("Fetched Days successfully")
            
            let fetchedDays = records.compactMap({ Day(ckrecord: $0) })
            let sortedDays = fetchedDays.sorted(by: {$0.dayNumber < $1.dayNumber})
            completion(.success(sortedDays))
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
