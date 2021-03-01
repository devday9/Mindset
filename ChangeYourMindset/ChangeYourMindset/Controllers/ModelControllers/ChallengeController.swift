//
//  ChallengeController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/29/20.
//

import UIKit
import CloudKit

class ChallengeController {
    
    //MARK: - Properties
    let publicDB = CKContainer.default().publicCloudDatabase
    
    static let shared = ChallengeController()
    
    var currentChallenge: Challenge?
    
    //MARK: - CRUD
    func createChallenge(completion: @escaping (Result <Challenge, MindsetError>) -> Void) {
        guard let user = UserController.shared.currentUser else { return completion(.failure(.couldNotUnwrap))}
        
        let reference = CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
        
        let newChallenge = Challenge(userReference: reference)
        let challengeRecord = CKRecord(challenge: newChallenge)
        publicDB.save(challengeRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                  let savedChallenge = Challenge(ckRecord: record) else { return
                    completion(.failure(.couldNotUnwrap))}
            
            print("Saved Challenge successfully")
            
            self.currentChallenge = savedChallenge
            DayController.shared.createDays(numberOfDays: 75) { (result) in
                switch result {
                case .success(let days):
                    self.currentChallenge?.days = days
                    
                case .failure(let error):
                    print(error.errorDescription)
                    return completion(.failure(.ckError(error)))
                }
            }
            completion(.success(savedChallenge))
        }
    }
    
    //MARK: - Fetch
    func fetchChallengesForUser(completion: @escaping (Result<Challenge, MindsetError>) -> Void) {
        guard let user = UserController.shared.currentUser else {
            return completion(.failure(.couldNotUnwrap))}
        
        let fetchAllPredicate = NSPredicate(format: "%K == %@", argumentArray: [ChallengeStrings.userReferenceKey, user.recordID])
        let query = CKQuery(recordType: ChallengeStrings.recordTypeKey, predicate: fetchAllPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first,
                  let fetchedChallenge = Challenge(ckRecord: record)
            else { return completion(.failure(.couldNotUnwrap))}
            print("Fetched Challenges successfully")
            
            self.currentChallenge = fetchedChallenge
            DayController.shared.fetchAllDays { (result) in
                switch result {
                case .success(let days):
                    self.currentChallenge?.days = days
                    completion(.success(fetchedChallenge))
                    
                case .failure(let error):
                    return completion(.failure(.ckError(error)))
                }
            }
        }
    }
    
    //MARK: - Delete
    func clearAllData(_ days: Day, completion: @escaping (Result<Bool, MindsetError>) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [days.recordID])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { ( _, recordIDs, error) in
            
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let recordIDs = recordIDs else { return completion(.failure(.couldNotUnwrap))}
            print("\(recordIDs) were removed successfully")
            completion(.success(true))
        }
        
        publicDB.add(operation)
    }
}//END OF CLASS
