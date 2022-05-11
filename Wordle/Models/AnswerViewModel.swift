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
    private var existedAnswers = [String]()

    public func setGuessingWord(_ guessingWord: String) {
        self.guessingWord = guessingWord
    }

    internal func addAnswer(_ answer: String) {
        if self.answersStruct.count < 6 && self.gameStatus == .inProgress && !self.existedAnswers.contains(answer){
            let newAnswer = self.checkNewWord(answer.lowercased())
            self.answersStruct.append(newAnswer)
        }
        if self.answersStruct.count == 6  && self.gameStatus == .inProgress {
            self.gameStatus = .completed
        }
    }

    private func checkNewWord(_ newWord: String) -> [Answer] {
        let newWordArr = Array(newWord)
        let guessWordArr = Array( self.guessingWord)
        var newAnswer = [Answer]()
        if self.guessingWord == newWord {
            self.gameStatus = .won
            for char in newWordArr {
                newAnswer.append(Answer(char: char, status: .onPlace))
            }
        } else {
            for index in 0..<guessWordArr.count {
                if newWordArr[index] == guessWordArr[index] {
                    newAnswer.append(Answer(char: newWordArr[index], status: .onPlace))
                } else if guessWordArr.contains(newWordArr[index]) {
                    newAnswer.append(Answer(char: newWordArr[index], status: .exists))
                } else {
                    newAnswer.append(Answer(char: newWordArr[index], status: .wrong))
                }
            }
        }
        self.existedAnswers.append(newWord)
        return newAnswer
    }
}
