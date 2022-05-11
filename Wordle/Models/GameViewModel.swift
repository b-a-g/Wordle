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
        fetchWords(from: wordRef)
        self.state = .success(content: self.word.isEmpty ? "ИГРАЙ": self.word)
    }

    private func fetchWords(from ref: DatabaseReference) {
        ref.getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
          let _ = snapshot.value as? String ?? "Unknown";
        });
    }

    func onViewDisappear() {
      ref.removeAllObservers()
    }
}
