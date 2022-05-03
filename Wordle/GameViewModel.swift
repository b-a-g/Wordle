//
//  GameViewModel.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//

import Foundation
import Combine

protocol IGameViewModel {
    func getWord()
}

class GameViewModel: ObservableObject, IGameViewModel {

    private let service: IGoogleSheetsService

    private(set) var word = ""
    private var cancelLables = Set<AnyCancellable>()

    @Published private(set) var state: ResultState = .loading

    init(service: GoogleSheetsService) {
        self.service = service
    }

    func getWord() {
        self.state = .loading

        let cancellable = service
            .request(from: .getWord)
            .sink { res in
                switch res {
                case .finished:
                    self.state = .success(content: self.word)
                case .failure(let error):
                    self.state = .failed(error: error)
                }

            } receiveValue: { response in
                self.word = response.word
            }

        self.cancelLables.insert(cancellable)
    }
}
