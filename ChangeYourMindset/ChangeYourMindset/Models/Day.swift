//
//  Day.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import UIKit
import CloudKit

struct DayStrings {
    static let recordTypeKey = "Day"
    fileprivate static let dailyJournalKey = "dailyJournal"
    fileprivate static let tasksCompletedKey = "tasksCompleted"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let userReferenceKey = "userReference"
    fileprivate static let challengeReferenceKey = "challengeReference"
    fileprivate static let photoAssetKey = "photoAsset"
    fileprivate static let dayNumberKey = "dayNumber"
}

class Day {
    let dayNumber: Int
    var dailyJournal: String
    var tasksCompleted: [Bool]
    var allTasksCompleted: Bool {
        var returnValue = true
        for task in tasksCompleted {
            if task == false {
                returnValue = false
            }
        }
        return returnValue
    }
    
    var recordID: CKRecord.ID
    var challengeReference: CKRecord.Reference
    var dailyProgressPhoto: UIImage? {
        get {
            guard let data = photoData else { return nil }
            return UIImage(data: data)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoData: Data?
    
    var photoAsset: CKAsset? {
        get {
            guard let data = photoData else { return nil }
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try data.write(to: fileURL)
            }catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(dayNumber: Int, dailyJournal: String = "", tasksCompleted: [Bool] = [false, false, false, false, false, false, false], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), challengeReference: CKRecord.Reference, dailyProgressPhoto: UIImage? = nil) {
        self.dayNumber = dayNumber
        self.dailyJournal = dailyJournal
        self.tasksCompleted = tasksCompleted
        self.recordID = recordID
        self.challengeReference = challengeReference
        self.dailyProgressPhoto = dailyProgressPhoto
    }
    
}//END OF CLASS

//MARK: - Extensions
extension Day {
    
    convenience init?(ckrecord: CKRecord) {
        guard let dayNumber = ckrecord[DayStrings.dayNumberKey] as? Int,
              let dailyJournal = ckrecord[DayStrings.dailyJournalKey] as? String,
              let challengeReference = ckrecord[DayStrings.challengeReferenceKey] as? CKRecord.Reference,
              let tasksCompleted = ckrecord[DayStrings.tasksCompletedKey] as? [Bool] else { return nil }
        
        var foundPhoto: UIImage?
        
        if let photoAsset = ckrecord[DayStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        self.init(dayNumber: dayNumber, dailyJournal: dailyJournal,tasksCompleted: tasksCompleted, recordID: ckrecord.recordID, challengeReference: challengeReference, dailyProgressPhoto: foundPhoto)
    }
}//END OF EXTENSION

extension Day: Equatable {
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}//END OF EXTENSION

extension CKRecord {
    convenience init(day: Day) {
        self.init(recordType: DayStrings.recordTypeKey, recordID: day.recordID)
        
        self.setValuesForKeys([
            DayStrings.dailyJournalKey : day.dailyJournal,
            DayStrings.dayNumberKey : day.dayNumber,
            DayStrings.tasksCompletedKey : day.tasksCompleted,
            DayStrings.challengeReferenceKey : day.challengeReference
        ])
        
        if  day.photoAsset != nil {
            setValue(day.photoAsset, forKey: DayStrings.photoAssetKey)
        }
    }
}//END OF EXTENSION
