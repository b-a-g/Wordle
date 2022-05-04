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
                    case .success(let word):
                        let tabView = TabView {
                            Text(word)
                                .tabItem {
                                    Label("Wodle", systemImage: "arrow.counterclockwise")
                                }
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
        ContentView()
    }
}
