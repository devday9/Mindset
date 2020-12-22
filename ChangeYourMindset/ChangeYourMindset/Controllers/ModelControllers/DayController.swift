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
    
    //MARK: - Helper Functions
    func createDays(numberOfDays: Int, completion: @escaping (Result<[Day], MindsetError>) -> Void) {
        
        guard let challenge = ChallengeController.shared.currentChallenge else { return }
        
        let reference = CKRecord.Reference(recordID: challenge.recordID, action: .deleteSelf)
        
        let days: [Day] = (1...numberOfDays).compactMap {Day(dayNumber: $0, challengeReference: reference)}
        let dayRecords = days.compactMap {CKRecord(day: $0)}
        completion(.success(days))
        //ASK AARON ABOUT THIS
        let operation = CKModifyRecordsOperation(recordsToSave: dayRecords, recordIDsToDelete: nil)
        operation.modifyRecordsCompletionBlock = { records, recordIDs, error in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
        }
        privateDB.add(operation)
    }
    
    //MARK: - Fetch
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
    
    //MARK: - Update
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
