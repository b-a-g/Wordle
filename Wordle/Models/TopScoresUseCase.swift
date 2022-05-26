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
    struct PlayerScore: Comparable
    {
        let score: Int
        let name: String
        let date: Date
        
        static func < (lhs: PlayerScore, rhs: PlayerScore) -> Bool {
            if lhs.score == rhs.score {
                return lhs.name < rhs.name
            }
            return lhs.score < rhs.score
        }
    }

    func fetchScores(completion: @escaping ([PlayerScore]) -> Void) {
        let ref = Database.root
        let resultsRef = ref.child("users")
        resultsRef.getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion([])
                return;
            }
            var scores = [PlayerScore]()
            if let rawUsers = snapshot.value as? NSDictionary {
                for val in rawUsers {
                    if let userVal = val.value as? NSDictionary,
                       let score = userVal["score"] as? Int ,
                        let name = userVal["username"] as? String,
                        let dateTime = userVal["lastLoginDate"] as? TimeInterval {
                        let pl = PlayerScore(score: score,
                                             name: name,
                                             date: Date(timeIntervalSince1970: dateTime))
                        scores.append(pl)
                    }
                }
            }
            completion(scores)
        }
    }
}
