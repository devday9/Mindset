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
    
    func fetchQuote(completion: @escaping (Result<Quote, NetworkError>) -> Void) {
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
                guard  let quote = try JSONDecoder().decode([Quote].self, from: data).first else { return }
                return completion(.success(quote))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}//END OF CLASS
