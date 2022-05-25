//
//  GameViewModel.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//
import SwiftUI
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
    
    public var needLogoutHandler: (() -> Void)? = nil
    @AppStorage("isSignedIn") var isSignedIn = true
    
    @Published private(set) var state: ResultState = .loading

    private var ref = Database.root
    private var refHandle: DatabaseHandle?
    
    private var currentPlayer: Player? = nil

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
                let name = rawUser["username"] as? String
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
    
    func setCurrentWord(word: String) {
        self.ref.child("current/word").setValue(word)
    }
    
    func getWordOrFetchIt(completion: @escaping(_ word: String) -> Void) {
        self.getCurrentWord { [weak self] rawWord in
            if let rawWord = rawWord {
                completion(rawWord)
            }
            else {
                self?.fetchWords(completion: completion)
            }
        }
        
    }
    func getCurrentWord(completion: @escaping(_ word: String?) -> Void) {
        let resultsRef = ref.child("current/word")
        resultsRef.getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                self.state = .failed(error: error!)
                completion(nil)
                return;
            }
            completion(snapshot.value as? String)
        }
    }
    
    func update(score: Int) {
        guard let id = self.getCurrentUserID() else {
            return
        }
        self.ref.child("users/\(id)/score").setValue(score)
    }
    
    func updateLastLogin() {
        guard let id = self.getCurrentUserID() else {
            return
        }
        self.ref.child("users/\(id)/lastLoginDate").setValue(Date().timeIntervalSince1970)
    }

    func getWord() {
        self.state = .loading
        guard let player = self.currentPlayer else {
            return
        }
        let allowUser = UserController.allowUser(lastLoginDate: player.lastGameDate)
        if allowUser {
            self.getWordOrFetchIt() { [weak self] word in
                self?.wordFetched(word: word)
            }
        }
        else {
            self.logout()
        }
        
    }

    private func fetchWords(completion: @escaping(_ word: String) -> Void) {
        let ref = ref.child("words")
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
                self.setCurrentWord(word: word)
                completion(word)
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
        self.state = .success(vm: vm)
    }
    
    func exit() {
        self.updateLastLogin()
        self.logout()
    }
    
    func logout() {
        self.isSignedIn = false
        self.state = .loading
        self.currentPlayer = nil
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
        self.updateWord {
            self.getWord()
        }
    }
    
    func updateWord(completion:@escaping (() -> Void)) {
        self.fetchWords(completion: { _ in completion() })
    }

    func onViewDisappear() {
        ref.removeAllObservers()
    }
}
