//
//  ResultState.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//

import Foundation

enum ResultState {
    case loading
    case success(content: String)
    case failed(error: Error)
}
