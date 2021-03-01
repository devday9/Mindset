//
//  RandomQuote.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 2/2/21.
//

import Foundation

struct TopLevelObject: Codable {
    let randomQuote: [Quote]
}

struct Quote: Codable {
    let text: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case text = "q"
        case author = "a"
    }
}//END OF STRUCT
