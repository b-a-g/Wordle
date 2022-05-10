//
//  LetterView.swift
//  Wordle
//
//  Created by Александр Беляев on 10.05.2022.
//

import SwiftUI

internal struct LetterView: View {
    internal var letter: String
    internal var state: CharPlace

    internal init(_ letter: String, _ state: CharPlace) {
        self.letter = letter
        self.state = state
    }

    var body: some View {
        ZStack {
            switch self.state {
                case .onPlace:
                    Color.green.scaledToFit()
                case .exists:
                    Color.orange.scaledToFit()
                case .wrong:
                    Color.white.scaledToFit()
            }
            Text(self.letter).scaledToFit()
        }
    }
}

struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        LetterView("j", .exists)
    }
}
