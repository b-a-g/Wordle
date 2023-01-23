//
//  Word.swift
//  Wordle
//
//  Created by e.razdrogin on 23.01.2023.
//
import Foundation

struct Word: Decodable
{
	let id: Int
	let word: String
	let lasShown: Date?
	let showsCount: Int?
}
