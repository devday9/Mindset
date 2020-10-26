//
//  MindsetError.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/26/20.
//

import Foundation

enum MindsetError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return "There was an error: \(error.localizedDescription)"
        case .couldNotUnwrap:
            return "Unable to unwrap"
        }
    }
}
