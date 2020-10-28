//
//  Task.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import UIKit
import CloudKit

struct TaskStrings {
    static let recordTypeKey = "Task"
    fileprivate static let nameKey = "name"
    fileprivate static let isCompleteKey = "isComplete"
    fileprivate static let dayReferenceKey = "dayReference"
    fileprivate static let photoAssetKey = "photoAsset"
}//END OF STRUCT

class Task {
    var name: String
    var isComplete: Bool
    var recordID: CKRecord.ID
    // reference grandparent ie challenge
    var dayReference: CKRecord.Reference?
    var progressPhoto: UIImage? {
        get {
            guard let data = photoData else { return nil }
            return UIImage(data: data)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoData: Data?
    
    var photoAsset: CKAsset? {
        guard let data = photoData else { return nil }
        let tempDirectory = NSTemporaryDirectory()
        let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
        let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
        
        return CKAsset(fileURL: fileURL)
    }
    
    init(name: String, isComplete: Bool = false, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), dayReference: CKRecord.Reference?, progressPhoto: UIImage? = nil) {
        self.name = name
        self.isComplete = isComplete
        self.recordID = recordID
        self.dayReference = dayReference
        self.progressPhoto = progressPhoto
    }
}//END OF CLASS

//MARK: - Extensions
extension Task {
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[TaskStrings.nameKey] as? String,
              let isComplete = ckRecord[TaskStrings.isCompleteKey] as? Bool else { return nil }
        
        let reference = ckRecord[TaskStrings.dayReferenceKey] as? CKRecord.Reference
        
        var foundPhoto: UIImage?
        
        if let photoAsset = ckRecord[TaskStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        self.init(name: name, isComplete: isComplete, recordID: ckRecord.recordID, dayReference: reference, progressPhoto: foundPhoto)
    }
}//END OF EXTENSION

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}//END OF EXTENSION

extension CKRecord {
    convenience init(task: Task) {
        self.init(recordType: TaskStrings.recordTypeKey, recordID: task.recordID)
        
        self.setValuesForKeys([
            TaskStrings.nameKey : task.name,
            TaskStrings.isCompleteKey : task.isComplete
        ])
        
        if let dayReference = task.dayReference {
            setValue(dayReference, forKey: TaskStrings.dayReferenceKey)
        }
        
        if task.photoAsset != nil {
            setValue(task.photoAsset, forKey: TaskStrings.photoAssetKey)
        }
    }
}//END OF EXTENSION
