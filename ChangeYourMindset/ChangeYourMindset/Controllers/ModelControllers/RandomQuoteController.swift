//
//  RandomQuoteController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 2/2/21.
//

import Foundation

struct StringConstants {
    fileprivate static let baseURL = "https://zenquotes.io/api"
    fileprivate static let randomEndpoint = "random"
}//END OF STRUCT

class RandomQuoteController {
    
    static let shared = RandomQuoteController()
    
    static func fetchQuote(completion: @escaping (Result<[SecondLevelDictionary], NetworkError>) -> Void) {
        guard let baseURL = URL(string: StringConstants.baseURL) else {
            return completion(.failure(.invalidURL))
        }
        
        let finalURL = baseURL.appendingPathComponent(StringConstants.randomEndpoint)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let secondLevelDictionary = topLevelObject.randomQuote
                return completion(.success(secondLevelDictionary))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}//END OF CLASS
