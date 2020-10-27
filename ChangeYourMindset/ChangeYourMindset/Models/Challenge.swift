//
//  Challenge.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import UIKit
import CloudKit

class Challenge {
    var title: String
    var startDate: Date
    var endDate: Date
    var tasks: [Task]
    var userReference: CKRecord.Reference
    
    init(title: String, startDate: Date, endDate: Date, tasks: [Task], userReference: CKRecord.Reference) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.tasks = tasks
        self.userReference = userReference
    }
}//END OF CLASS

//MARK: - Extensions
extension Challenge {
    
    convenience init?(ckRecord: CKRecord) {
        guard let 
    }
    
}//END OF EXTENSION
