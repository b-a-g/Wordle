//
//  UserController.swift
//  Wordle
//
//  Created by Бабинцев Павел Валерьевич on 25.05.2022.
//

import Foundation


struct UserController
{
    static let lifetimeInMinutes: Int = 15
    
    static func allowUser(lastLoginDate: Date) -> Bool {
        return true
//        let cal = Calendar.current
//        guard let lastWithAddLifeTime = cal.date(byAdding: .minute, value: lifetimeInMinutes, to: lastLoginDate) else {
//            return true
//        }
//
//        return lastWithAddLifeTime < Date()
    }
}
