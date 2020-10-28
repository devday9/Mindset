//
//  DateExtension.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/27/20.
//

import Foundation

extension Date {
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}//END OF EXTENSION
