//
//  UserController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import UIKit
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    var currentUser: User?
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func createUser(username: String, profilePhoto: UIImage?,
                    completion: @escaping (Result<Bool, MindsetError>) -> Void) {
        
        fetchAppleUserReference { (result) in
            switch result {
            case .success(let reference):
                let user = User(username: username, appleUserReference: reference, profilePhoto: profilePhoto)
                let userRecord = CKRecord(user: user)
                
                self.privateDB.save(userRecord) { (record, error) in
                    if let error = error {
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        return completion(.failure(.ckError(error)))
                    }
                    
                    guard let record = record,
                          let savedUser = User(ckRecord: record) else {
                        completion(.failure(.couldNotUnwrap))
                        return
                    }
                    
                    self.currentUser = savedUser
                    ChallengeController.shared.createChallenge { (result) in
                        switch result {
                        case .success(_):
                            return completion(.success(true))
                        case .failure(_):
                            print("Failed to create challenge")
                            
                            return completion(.failure(.couldNotUnwrap))
                        }
                    }
                }
                
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
        }
    }
    
    func fetchUser(completion: @escaping (Result<User?, MindsetError>) -> Void) {
        
        fetchAppleUserReference { (result) in
            switch result {
            case .success(let reference):
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.appleUserReferenceKey, reference])
                
                let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
                
                self.privateDB.perform(query, inZoneWith: nil) { (records, error) in
                    if let error = error {
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        completion(.failure(.ckError(error)))
                        return
                    }
                    
                    guard let record = records?.first else {
                        return completion(.success(nil))
                    }
                    guard let fetchedUser = User(ckRecord: record) else {
                        completion(.failure(.couldNotUnwrap))
                        return
                    }
                    
                    self.currentUser = fetchedUser
                    ChallengeController.shared.fetchAllChallenges { (result) in
                        switch result {
                        case .success(_):
                            print("Successfully fetched user with id: \(fetchedUser.recordID)")
                            completion(.success(self.currentUser))
                        case .failure(let error):
                            print(error.errorDescription)
                            return completion(.failure(.ckError(error)))
                        }
                    }
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
        }
    }
    
    func fetchAppleUserReference(completion: @escaping (Result<CKRecord.Reference, MindsetError>) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            
            guard let recordID = recordID else { return completion(.failure(.couldNotUnwrap)) }
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            completion(.success(reference))
        }
    }
}//END OF CLASS
