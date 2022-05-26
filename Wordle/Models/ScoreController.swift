//
//  ScoreController.swift
//  Wordle
//
//  Created by Бабинцев Павел Валерьевич on 25.05.2022.
//

import Foundation
struct ScoreController {
    
    ///очки за верный ответ от
    static func winScore(by row: Int) -> Int {
        switch row {
        case 6: return 10
        case 5: return 50
        case 4: return 100
        case 3: return 150
        case 2: return 200
        case 1: return 500
            
        default:
                return 0
        }
    }
    
    ///Букв на своем месте
    static let onPlace = 5
    
    /// Буква существует но не на своем месте
    static let exist = 1
}
