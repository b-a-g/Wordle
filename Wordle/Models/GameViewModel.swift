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

struct Player
{
    let id: String
    let name: String?
    let scores: Int
    let lastGameDate: Date
}

internal class GameViewModel: ObservableObject, IGameViewModel {
    @Published private(set) var state: ResultState = .loading
    @Published var alert = false
    @Published var alertMessage = ""
    @Published var word = ""

    private var ref = Database.root
    private var refHandle: DatabaseHandle?
    
    private var currentPlayer: Player? = nil

    private func showAlertMessage(message: String) {
        alertMessage = message
        alert.toggle()
    }

    private func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }

    init() {
        self.newGame()
    }
    
    func newGame() {
        self.fetchPlayer() { [weak self] in
            self?.getWord()
        }
    }
    
    func fetchPlayer(completion: @escaping (() -> Void)) {
        guard let id = self.getCurrentUserID() else {
            return
        }
        let resultsRef = ref.child("users/\(id)")
        resultsRef.getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                self.state = .failed(error: error!)
                completion()
                return;
            }
            if let rawUser = snapshot.value as? NSDictionary,
               let score = rawUser["score"] as? Int,
                let dateTime = rawUser["lastLoginDate"] as? TimeInterval {
                let name = rawUser["name"] as? String
                self.currentPlayer = Player(id: id,
                                            name: name,
                                            scores: score,
                                            lastGameDate: Date(timeIntervalSince1970: dateTime))
                completion()
            } else {
                self.createUser(completion: completion)
            }

        }
    }
    
    func createUser(completion: @escaping (() -> Void)) {
        guard let id = self.getCurrentUserID() else {
            completion()
            return
        }
        
        let name = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email
        let date = Date()
        let score = 0
        self.ref.child("users/\(id)/score").setValue(score)
        self.ref.child("users/\(id)/username").setValue(name)
        self.ref.child("users/\(id)/lastLoginDate").setValue(date.timeIntervalSince1970)
        self.currentPlayer = Player(id: id,
                                    name: name,
                                    scores: score,
                                    lastGameDate: date)
        completion()
    }
    
    func setWordUsed(word: String) {
        self.ref.child("used/\(word)/used").setValue(1)
    }
    
    func update(score: Int) {
        guard let id = self.getCurrentUserID() else {
            return
        }
        self.ref.child("users/\(id)/score").setValue(score)
    }

    func getWord() {
        self.state = .loading
        guard let player = self.currentPlayer else {
            return
        }
        let allowUser = UserController.allowUser(lastLoginDate: player.lastGameDate)
        if allowUser {
            self.fetchWords(from: ref.child("words"))
        }
        else {
            self.exit()
        }
        
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
                let word = resultWords[Int.random(in: 0..<resultWords.count)]
                self.wordFetched(word: word)
            }
        });
    }
    
    func wordFetched(word: String) {
        guard let player = self.currentPlayer else {
            return
        }
        let vm = AnswerViewModel()
        vm.setGuessingWord(word)
        vm.setCurrnetNameAndScore(name: player.name,
                                  score: player.scores)
        vm.exitHandler = { [weak self] in
            self?.exit()
        }
        
        vm.succesCompleteHandler = { [weak self] points in
            self?.goNext(points)
        }
        self.word = word
        self.state = .success(vm: vm)
    }
    
    func exit() {
        //Сбро полтзовтеля и отправка в базу последнее время логина
    }
    
    func goNext(_ points: Int) {
        guard let player = self.currentPlayer else {
            return
        }
        let curr = player.scores + points
        self.currentPlayer = Player(id: player.id,
                                    name: player.name,
                                    scores: curr,
                                    lastGameDate: player.lastGameDate)
        self.update(score: curr)
        self.getWord()
    }

    func onViewDisappear() {
        ref.removeAllObservers()
    }
}
