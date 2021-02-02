//
//  Challenge.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import UIKit
import CloudKit

struct ChallengeStrings {
    static let userReferenceKey = "userReference"
    static let recordTypeKey = "Challenge"
    fileprivate static let titleKey = "title"
    fileprivate static let startDateKey = "startDate"
    fileprivate static let isCompleteKey = "isComplete"
}

class Challenge {
    let title: String
    var startDate: Date
    var endDate: Date {
        return startDate.addingTimeInterval(6480000)
    }
    var isComplete: Bool
    var days: [Day]
    let tasks: [String] = ["10 Pages of Reading", "Drink 1 Gallon of Water", "45 Minute Workout", "15 Minutes of Prayer or Meditation", "Follow a Diet & No Cheat Meals", "No Alcohol/Drugs", "Take Progress Pic" ]
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference
    
    init(title: String = "Chang Your Mindset", startDate: Date = Date(), isComplete: Bool = false, days: [Day] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference) {
        self.title = title
        self.startDate = startDate
        self.isComplete = isComplete
        self.days = days
        self.recordID = recordID
        self.userReference = userReference
    }
    
//    var currentDay: Day {
////        let day = // search SO to find how many days from day to day in swift
////        return days.first(where: { $0.number == day})
//    }
    
    var daysSinceStartDate: Int {
        Int(Date().timeIntervalSince(startDate) / (24 * 60 * 60))
        //        (Date().timeIntervalSince(startDate) / (24 * 60 * 60))
    }
}//END OF CLASS

//MARK: - Extensions
extension Challenge {
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[ChallengeStrings.titleKey] as? String,
              let startDate = ckRecord[ChallengeStrings.startDateKey] as? Date,
              let isComplete = ckRecord[ChallengeStrings.isCompleteKey] as? Bool,
              let reference = ckRecord[ChallengeStrings.userReferenceKey] as? CKRecord.Reference else { return nil }
        
        self.init(title: title, startDate: startDate, isComplete: isComplete, recordID: ckRecord.recordID, userReference: reference)
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
        
        self.setValuesForKeys([
            ChallengeStrings.titleKey : challenge.title,
            ChallengeStrings.startDateKey : challenge.startDate,
            ChallengeStrings.isCompleteKey : challenge.isComplete,
            ChallengeStrings.userReferenceKey : challenge.userReference
        ])
    }
}//END OF EXTENSION
