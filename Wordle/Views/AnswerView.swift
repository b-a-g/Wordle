//
//  AnswerView.swift
//  Wordle
//
//  Created by Александр Беляев on 10.05.2022.
//

import SwiftUI

internal struct AnswerView: View {

    @State var answer: String = ""

    @ObservedObject var answerViewModel: AnswerViewModel
    @State var guessingWord: String

    internal init(word: String) {
        self.guessingWord = word.lowercased()
        self.answerViewModel = AnswerViewModel()
        self.answerViewModel.setGuessingWord(guessingWord)
    }

    var body: some View {
        ZStack {
            List() {
                ForEach(self.answerViewModel.answersStruct, id: \.self) { answer in
                    HStack(spacing: 10) {
                        ForEach(answer, id: \.self) { element in
                            LetterView(element.char, element.status)
                        }
                    }
                }
            }
            List() {
                ForEach(0..<6) { _ in
                    HStack(spacing: 10) {
                        ForEach(0..<5) { _ in
                            Color.gray.scaledToFit()
                        }
                    }
                }
                HStack(spacing: 10) {
                    TextField("Enter your word", text: $answer)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Button("Post") {
                        if answer.count == 5 {
                            self.answerViewModel.addAnswer(answer)
                            answer = ""
                        }
                    }
                }
            }
            .opacity(0.3)
        }
    }
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        let view = AnswerView(word: "empty")
        view.answerViewModel.addAnswer("jopaa")
        view.answerViewModel.addAnswer("emptt")
        view.answerViewModel.addAnswer("empty")
        view.answerViewModel.addAnswer("emqty")
        return view
    }
}
