//
//  ContentView.swift
//  Wordle
//
//  Created by Александр Беляев on 15.04.2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isSignedIn") var isSignedIn = false

    @StateObject var viewModel = GameViewModel()
    var body: some View {
        if isSignedIn {
            Group {
                switch viewModel.state {
                    case .loading:
                        ProgressView()
                    case .failed(let error):
                        ErrorView(error: error, handler: viewModel.getWord)
                    case .success(let vm):
                        let tabView = TabView {
                            AnswerView(vm: vm)
                        }
                            .accentColor(Color(.systemTeal))
                        tabView
                }
            }
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isSignedIn: true, viewModel: GameViewModel())
    }
}
