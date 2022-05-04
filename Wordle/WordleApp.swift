//
//  WordleApp.swift
//  Wordle
//
//  Created by Александр Беляев on 15.04.2022.
//

import SwiftUI
import Firebase

@main
struct WordleApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
