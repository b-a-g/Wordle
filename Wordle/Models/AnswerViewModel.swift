//
//  AnswerViewModel.swift
//  Wordle
//
//  Created by Александр Беляев on 11.05.2022.
//

import Foundation

public class AnswerViewModel: ObservableObject {

    @Published var gameStatus: GameStatus = .inProgress
    @Published var guessingWord: String = ""
    @Published var answersStruct = [[Answer]]()
    
    @Published var needShowWonAlert: Bool = false
    @Published var wonAlertMessage: String = ""
    
    @Published var needShowFailAlert: Bool = false
    @Published var failAlertMessage: String = ""
    
    @Published var needShowRepeatedAlert: Bool = false
    
    @Published var nameAndScoreString: String = ""
    
    
    
    
    
    public var succesCompleteHandler: (( _ points: Int) -> Void)?
    public var exitHandler: (() -> Void)?
    
    private var existedAnswers = [String]()
    
    @Published var score: Int = 0
    
    public func setCurrnetNameAndScore(name: String?, score: Int) {
        let name = name ?? "Участник"
        self.nameAndScoreString = "Привет, \(name.prefix(5))***\(name.suffix(5))! Удачи в игре!\nТвой текущий счёт: \(score)."
    }

    public func setGuessingWord(_ guessingWord: String) {
        self.guessingWord = guessingWord
    }

    internal func addAnswer(_ answer: String) {
        if self.answersStruct.count < 6 && self.gameStatus == .inProgress {
            if self.existedAnswers.contains(answer) == false {
                let newAnswer = self.checkNewWord(answer.lowercased())
                self.answersStruct.append(newAnswer)
            } else {
                self.needShowRepeatedAlert = true
            }
        }

        if self.existedAnswers.count == 6  && self.gameStatus == .inProgress {
            self.gameStatus = .completed
            self.needShowFailAlert = true
        }
    }

    private func checkNewWord(_ newWord: String) -> [Answer] {
        let newWordArr = Array(newWord)
        let guessWordArr = Array( self.guessingWord)
        var newAnswer = [Answer]()
        
        var currScore = 0
        
        if self.guessingWord == newWord {
            self.gameStatus = .won
            
            currScore += ScoreController.winScore(by: self.existedAnswers.count + 1)
            for char in newWordArr {
                newAnswer.append(Answer(char: char, status: .onPlace))
            }
            self.score += currScore
            self.showWonAlert()
        }
        else
        {
            for index in 0..<guessWordArr.count {
                if newWordArr[index] == guessWordArr[index] {
                    newAnswer.append(Answer(char: newWordArr[index], status: .onPlace))
                    currScore += ScoreController.onPlace
                } else if guessWordArr.contains(newWordArr[index]) {
                    newAnswer.append(Answer(char: newWordArr[index], status: .exists))
                    currScore += ScoreController.exist
                } else {
                    newAnswer.append(Answer(char: newWordArr[index], status: .wrong))
                }
            }
            self.score += currScore
        }
        
        self.existedAnswers.append(newWord)
        return newAnswer
    }
    func showWonAlert() {
        self.needShowWonAlert = true
        self.wonAlertMessage = "Поздравляем, ты отгадал слово! \n Очки которые ты заработал: \(score)\n переходим к следующему"
    }
    func goNextWord() {
        self.succesCompleteHandler?(self.score)
    }
    
    func exit() {
        self.exitHandler?()
    }
}
