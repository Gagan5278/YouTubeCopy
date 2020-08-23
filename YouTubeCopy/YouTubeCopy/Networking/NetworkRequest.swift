//
//  NetworkRequest.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//

import Foundation
import Combine
import UIKit

protocol NetworkAPI {
    func fetchItem<T: Decodable>(from urlString: String, modelType: T.Type, decoder: JSONDecoder) -> AnyPublisher<T, CustomError>
    func fetchImage(from urlString: String)  -> AnyPublisher<UIImage, CustomError>
}

class NetworkRequest: NetworkAPI {
    
    //MARK:- Fetch items from server
    func fetchItem<T: Decodable>(from urlString: String, modelType: T.Type, decoder: JSONDecoder = JSONDecoder() ) -> AnyPublisher<T, CustomError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: CustomError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: T.self, decoder: decoder)
            .mapError{CustomError.mapError(error: $0)}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    //MARK:- Fetch image
    func fetchImage(from urlString: String)  -> AnyPublisher<UIImage, CustomError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: CustomError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .compactMap{UIImage(data: $0.data)}
            .mapError{CustomError.mapError(error: $0)}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
