//
//  TopScoresUseCase.swift
//  Wordle
//
//  Created by Бабинцев Павел Валерьевич on 26.05.2022.
//

import Foundation
import FirebaseDatabase

class TopScoresUseCase
{

    func fetchScores(completion: @escaping ([Int]) -> Void) {
        let ref = Database.root
        let resultsRef = ref.child("users")
        resultsRef.getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion([])
                return;
            }
            var scores = [Int]()
            if let rawUsers = snapshot.value as? NSDictionary {
                for val in rawUsers {
                    if let userVal = val.value as? NSDictionary,
                       let score = userVal["score"] as? Int {
                        scores.append(score)
                    }
                }
            }
            completion(scores)
        }
    }
}
