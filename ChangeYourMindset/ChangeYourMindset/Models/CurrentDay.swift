//
//  CurrentDay.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import UIKit
import CloudKit

struct DayStrings {
    static let recordTypeKey = "Day"
    fileprivate static let dailyJournalKey = "dailyJournal"
    fileprivate static let allTasksAreCompleteKey = "allTasksAreComplete"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let userReferenceKey = "userReference"
    fileprivate static let photoAssetKey = "photoAsset"
}

class Day {
    var dailyJournal: String
    var allTasksAreComplete: Bool
    var tasks: [Task]
    var timestamp: Date
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference?
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
    
    init(dailyJournal: String, allTasksAreComplete: Bool, tasks: [Task], timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?, dailyProgressPhoto: UIImage?) {
        self.dailyJournal = dailyJournal
        self.allTasksAreComplete = allTasksAreComplete
        self.tasks = tasks
        self.timestamp = timestamp
        self.recordID = recordID
        self.userReference = userReference
        self.dailyProgressPhoto = dailyProgressPhoto
    }
    
}//END OF CLASS

//MARK: - Extensions
extension Day {
    
    convenience init?(ckrecord: CKRecord) {
        guard let dailyJournal = ckrecord[DayStrings.dailyJournalKey] as? String,
              let timestamp = ckrecord[DayStrings.timestampKey] as? Date,
              let allTasksAreComplete = ckrecord[DayStrings.allTasksAreCompleteKey] as? Bool
              else { return nil }
        
        let reference = ckrecord[DayStrings.userReferenceKey] as? CKRecord.Reference
        
        var foundPhoto: UIImage?
        
        if let photoAsset = ckrecord[DayStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        self.init(dailyJournal: dailyJournal, allTasksAreComplete: allTasksAreComplete, tasks: [], timestamp: timestamp, recordID: ckrecord.recordID, userReference: reference, dailyProgressPhoto: foundPhoto)
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
        
        setValuesForKeys([
            DayStrings.dailyJournalKey : day.dailyJournal,
            DayStrings.timestampKey : day.timestamp
        ])
        
        if let userReference = day.userReference {
            setValue(userReference, forKey: DayStrings.userReferenceKey)
        }
        
        if  day.photoAsset != nil {
            setValue(day.photoAsset, forKey: DayStrings.photoAssetKey)
        }
    }
}//END OF EXTENSION
