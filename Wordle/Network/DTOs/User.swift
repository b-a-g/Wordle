//
//  User.swift
//  Wordle
//
//  Created by e.razdrogin on 23.01.2023.
//
import Foundation

struct User: Codable
{
	let id: UUID
	let email: String
	let password: String
	let firstName: String?
	let lastName: String?

	init(email: String, password: String, firstName: String? = "", lastName: String? = "") {
		
		self.id = UUID()
		self.email = email
		self.password = password
		self.firstName = firstName
		self.lastName = lastName
	}
}

enum CodingKeys: String, CodingKey
{
	case firstName = "first_name"
	case lastName = "last_name"
}
