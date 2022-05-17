//
//  GameViewModel.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//

import Combine
import FirebaseAuth
import FirebaseDatabase

protocol IGameViewModel {
    func getWord()
}

internal class GameViewModel: ObservableObject, IGameViewModel {
    @Published private(set) var state: ResultState = .loading
    @Published var alert = false
    @Published var alertMessage = ""
    @Published var word = ""

    private var ref = Database.root
    private var refHandle: DatabaseHandle?

    private func showAlertMessage(message: String) {
        alertMessage = message
        alert.toggle()
    }

    private func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }

    init() {
        self.getWord()
    }

    func getWord() {
        self.state = .loading
        let wordRef = ref.child("words")
        self.fetchWords(from: wordRef)
    }

    private func fetchWords(from ref: DatabaseReference) {
        ref.getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                self.state = .failed(error: error!)
                return;
            }
            if let words = (snapshot.value as? [String?]) {
                var resultWords = [String]()
                for resultWord in words {
                    if let newWord = resultWord {
                        resultWords.append(newWord)
                    }
                }
                self.word = resultWords[Int.random(in: 0..<resultWords.count)]
                self.state = .success(content: self.word)
            }
        });
    }

    func onViewDisappear() {
        ref.removeAllObservers()
    }
}
