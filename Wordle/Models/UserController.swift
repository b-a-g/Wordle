//
//  UserController.swift
//  Wordle
//
//  Created by Бабинцев Павел Валерьевич on 25.05.2022.
//

import Foundation


struct UserController
{
    static let lifetimeInMinutes: Int = 1
    
    static func allowUser(lastLoginDate: Date) -> Bool {
        
        let cal = Calendar.current
        guard let lastWithAddLifeTime = cal.date(byAdding: .minute, value: lifetimeInMinutes, to: lastLoginDate) else {
            return true
        }
        
        return lastWithAddLifeTime < Date()
    }
}
