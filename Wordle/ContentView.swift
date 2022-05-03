//
//  ContentView.swift
//  Wordle
//
//  Created by Александр Беляев on 15.04.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = GameViewModel(service: GoogleSheetsService())
    var body: some View {
        Group {
            switch viewModel.state {
                case .loading:
                    ProgressView()
                case .failed(let error):
                    ErrorView(error: error, handler: viewModel.getWord)
                case .success(let word):
                    Text(word)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
