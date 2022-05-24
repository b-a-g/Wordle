//
//  AnswerView.swift
//  Wordle
//
//  Created by Александр Беляев on 10.05.2022.
//

import SwiftUI

internal struct AnswerView: View {

    @State var answer: String = ""

    private let textlimit = 5
    
    enum Field: Hashable {
            case answer
        case nothing
    }
    
    @FocusState private var answerFieldFocused: Field?

    @ObservedObject var answerViewModel: AnswerViewModel
    @State var guessingWord: String

    internal init(word: String) {
        self.guessingWord = word.lowercased()
        self.answerViewModel = AnswerViewModel()
        self.answerViewModel.setGuessingWord(guessingWord)
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        self.answerFieldFocused = .answer
    }
    
   

    var body: some View {
        VStack {
            Spacer(minLength: 200)
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
                .frame(width: 600, alignment: .center)
                List() {
                    ForEach(0..<6) { _ in
                        HStack(spacing: 10) {
                            ForEach(0..<5) { _ in
                                Color.gray.scaledToFit()
                            }
                        }
                    }
                    HStack(spacing: 10) {
                        TextField("Введи слово", text: $answer, onCommit: self.onCommit)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .font(.largeTitle)
                            .focused($answerFieldFocused, equals: .answer)
                            .onChange(of: self.answer, perform: { value in
                                if value.count > self.textlimit {
                                    self.answer = String(value.prefix(self.textlimit))
                                  }
                              })
                    }
                }
                .opacity(0.3)
                .frame(width: 600, alignment: .center)
            }
        }
        .fullBackground(imageName: "Wordle_screen-3")
        .onAppear {
            self.answerFieldFocused = .answer
        }
        
    }
    
    func onCommit() {
        if answer.count == 5 {
            self.answerViewModel.addAnswer(answer)
            answer = ""
        }
        self.answerFieldFocused = .answer
    }
}

public extension View {
    func fullBackground(imageName: String) -> some View {
       return background(
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
       )
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
