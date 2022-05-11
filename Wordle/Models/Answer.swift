//
//  Answer.swift
//  Wordle
//
//  Created by Александр Беляев on 11.05.2022.
//

public struct Answer: Hashable {
    let char: Character
    let status: CharPlace
}
