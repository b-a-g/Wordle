//
//  AnswerView.swift
//  Wordle
//
//  Created by Александр Беляев on 10.05.2022.
//

import SwiftUI

public protocol IAnswerUI {
    var gameStatus: GameStatus { get }
    mutating func startNewGame(with word: String)
    mutating func addAnswer(_ answer: String)
}

internal struct AnswerView: View, IAnswerUI {

    private var guessingWord: String = ""
    internal var gameStatus: GameStatus = .inProgress

    private var answersStruct = [[String: CharPlace]]()

    var body: some View {
        List() {
            ForEach(self.answersStruct, id: \.self) { answer in
                HStack {
                    Color.orange.scaledToFit()
                    ForEach(answer.keys) { key in

                    }
//                    ForEach(answer, id: \.self) { key in
//
//                    }
//                    answer.keys.forEach { key in
//                        if let value = answer[key] {
//                            LetterView(key, value)
//                        }
//                    }
                }
            }
        }
    }

    internal mutating func startNewGame(with word: String) {
        self.guessingWord = word
        self.gameStatus = .inProgress
        self.answersStruct.removeAll()
    }

    internal mutating func addAnswer(_ answer: String) {
        let newAnswer = self.checkNewWord(answer)
        self.answersStruct.append(newAnswer)
        if self.answersStruct.count == 5  && self.gameStatus != .won {
            self.gameStatus = .completed
        }
    }

    private mutating func checkNewWord(_ newWord: String) -> [String: CharPlace] {
        let newWordArrayOfChars = Array(arrayLiteral: newWord)
        let guessingWordArrayOfChars = Array(arrayLiteral: self.guessingWord)
        var newAnswer: [String: CharPlace] = ["": .wrong]
        if self.guessingWord == newWord {
            self.gameStatus = .won
            for char in newWordArrayOfChars {
                newAnswer[char] = .onPlace
            }
        } else {
            for index in 0..<guessingWordArrayOfChars.count {
                if newWordArrayOfChars[index] == guessingWordArrayOfChars[index] {
                    newAnswer[newWordArrayOfChars[index]] = .onPlace
                } else if guessingWordArrayOfChars.contains(newWordArrayOfChars[index]) {
                    newAnswer[newWordArrayOfChars[index]] = .exists
                } else {
                    newAnswer[newWordArrayOfChars[index]] = .wrong
                }
            }
        }
        print("JOPAJOPAJOPA")
        print(newAnswer)
        return newAnswer
    }
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        var view = AnswerView()
        view.startNewGame(with: "empty")
        view.addAnswer("jopaa")
        view.addAnswer("emptt")
        return view
    }
}
