//
//  GoogleSheetsService.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//
//delete it?
import GoogleSignIn
import Foundation
import Combine

protocol IGoogleSheetsService {
    func request(from endpoint: WordsAPI) -> AnyPublisher<WordsResponse, APIError>
}

class GoogleSheetsService: IGoogleSheetsService {

    private var gidConfig: GIDConfiguration
    init() {
        self.gidConfig = GIDConfiguration.init(clientID: "770346214819-5clkai2sjkj5sibqvjgc78lkl3t848f1.apps.googleusercontent.com")
    }

    func request(from endpoint: WordsAPI) -> AnyPublisher<WordsResponse, APIError> {
        return URLSession
            .shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError{ _ in APIError.unknown }
            .flatMap { data, response -> AnyPublisher<WordsResponse, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }

                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    return Just(data)
                        .decode(type: WordsResponse.self, decoder: jsonDecoder)
                        .mapError { _ in APIError.decodingError }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
