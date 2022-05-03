//
//  Endpoint.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseURL: URL { get }
    var path: String { get }
}

enum WordsAPI {
    case getWord
}

extension WordsAPI: APIBuilder {
    var urlRequest: URLRequest {
        return URLRequest(url: self.baseURL.appendingPathComponent(self.path))
    }

    var baseURL: URL {
        switch self {
            case .getWord:
                return URL(string: "https://sheets.googleapis.com/v4/spreadsheets/1Mz9lHS-cLaIEIaaYdoUwRyoF1VGp831iBflPer_Tcd0")!
        }
    }

    var path: String {
        return "/values:batchGet"
    }
}
