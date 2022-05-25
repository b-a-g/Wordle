//
//  ResultState.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//

import Foundation

enum ResultState {
    case loading
    case success(vm: AnswerViewModel)
    case failed(error: Error)
}
