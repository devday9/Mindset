//
//  Task.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import UIKit
import CloudKit

class Task {
    var name: String
    var isComplete: Bool
    var progressPhoto: UIImage?
    var dayReference: CKRecord.Reference
    
    init(name: String, isComplete: Bool, progressPhoto: UIImage?, dayReference: CKRecord.Reference) {
        self.name = name
        self.isComplete = isComplete
        self.progressPhoto = progressPhoto
        self.dayReference = dayReference
    }
}//END OF CLASS
