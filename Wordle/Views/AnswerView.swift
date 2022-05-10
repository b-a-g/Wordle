//
//  AnswerView.swift
//  Wordle
//
//  Created by Александр Беляев on 10.05.2022.
//

import SwiftUI

public protocol IAnswerUI {
    var gameStatus: GameStatus { get }
    mutating func addAnswer(_ answer: String)
}

struct Answer: Hashable {
    let char: String
    let status: CharPlace
}

internal struct AnswerView: View, IAnswerUI {
    private var guessingWord: String = ""
    internal var gameStatus: GameStatus = .inProgress

    private var answersStruct = [[Answer]]()

    public init(word: String) {
        self.guessingWord = word
        self.gameStatus = .inProgress
        self.answersStruct.removeAll()
    }

    var body: some View {
        List() {
            ForEach(self.answersStruct, id: \.self) { answer in
                HStack(spacing: 10) {
                    ForEach(answer, id: \.self) { element in
                        LetterView(element.char, element.status).frame(width: 50.0, height: 50.0, alignment: .center)
                    }
                }
            }
        }
    }

    internal mutating func addAnswer(_ answer: String) {
        let newAnswer = self.checkNewWord(answer)
        self.answersStruct.append(newAnswer)
        if self.answersStruct.count == 5  && self.gameStatus != .won {
            self.gameStatus = .completed
        }
    }

    private mutating func checkNewWord(_ newWord: String) -> [Answer] {
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
        return newAnswer
    }
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        var view = AnswerView(word: "empty")
        view.addAnswer("jopaa")
        view.addAnswer("emptt")
        view.addAnswer("empty")
        return view
    }
}
