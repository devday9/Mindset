//
//  Challenge.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import UIKit
import CloudKit

struct ChallengeStrings {
    static let recordTypeKey = "Challenge"
    fileprivate static let titleKey = "title"
    fileprivate static let startDateKey = "startDate"
    fileprivate static let endDateKey = "endDate"
    fileprivate static let userReferenceKey = "userReference"
}

class Challenge {
    var title: String
    var startDate: Date
    var endDate: Date
    var tasks: [Task]
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference?
    
    init(title: String, startDate: Date, endDate: Date, tasks: [Task], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.tasks = tasks
        self.recordID = recordID
        self.userReference = userReference
    }
}//END OF CLASS

//MARK: - Extensions
extension Challenge {
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[ChallengeStrings.titleKey] as? String,
              let startDate = ckRecord[ChallengeStrings.startDateKey] as? Date,
              let endDate = ckRecord[ChallengeStrings.endDateKey] as? Date else { return nil }
        
        let reference = ckRecord[ChallengeStrings.userReferenceKey] as? CKRecord.Reference
        
        self.init(title: title, startDate: startDate, endDate: endDate, tasks: [], userReference: reference)
    }
}//END OF EXTENSION

extension Challenge: Equatable{
    static func == (lhs: Challenge, rhs: Challenge) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}//END OF EXTENSION

extension CKRecord {
    convenience init(challenge: Challenge) {
        self.init(recordType: ChallengeStrings.recordTypeKey, recordID: challenge.recordID)
        
        setValuesForKeys([
            ChallengeStrings.titleKey : challenge.title,
            ChallengeStrings.startDateKey : challenge.startDate,
            ChallengeStrings.endDateKey : challenge.endDate
        ])
        
        if let userReference = challenge.userReference {
            setValue(userReference, forKey: ChallengeStrings.userReferenceKey)
        }
    }
}//END OF EXTENSION
