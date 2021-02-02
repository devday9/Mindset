//
//  RandomQuote.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 2/2/21.
//

import Foundation

struct TopLevelObject: Codable {
    let randomQuote: [SecondLevelDictionary]
}

struct SecondLevelDictionary: Codable {
    let quote: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case quote = "q"
        case author = "a"
    }
}//END OF STRUCT
