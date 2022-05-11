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
        let newWordArrayOfChars = Array(newWord)
        let guessingWordArrayOfChars = Array( self.guessingWord)
        var newAnswer = [Answer]()
        if self.guessingWord == newWord {
            self.gameStatus = .won
            for char in newWordArrayOfChars {
                newAnswer.append(Answer(char: String(char), status: .onPlace))
            }
        } else {
            for index in 0..<guessingWordArrayOfChars.count {
                if newWordArrayOfChars[index] == guessingWordArrayOfChars[index] {
                    newAnswer.append(Answer(char: String(newWordArrayOfChars[index]), status: .onPlace))
                } else if guessingWordArrayOfChars.contains(newWordArrayOfChars[index]) {
                    newAnswer.append(Answer(char: String(newWordArrayOfChars[index]), status: .exists))
                } else {
                    newAnswer.append(Answer(char: String(newWordArrayOfChars[index]), status: .wrong))
                }
            }
        }
        self.existedAnswers.append(newWord)
        return newAnswer
    }
}
