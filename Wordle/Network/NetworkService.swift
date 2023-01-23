//
//  NetworkService.swift
//  Wordle
//
//  Created by e.razdrogin on 18.01.2023.
//

import Foundation

final class NetworService
{
	private let requestBuilderFactory: () -> IRequestBuilder

	init(requestBuilderFactory: @escaping () -> IRequestBuilder) {
		self.requestBuilderFactory = requestBuilderFactory
	}

	func load<R: Decodable>(request: URLRequest) async throws -> R {
		let data =  try await URLSession.shared.data(for: request).0

		return try JSONDecoder().decode(R.self, from: data)
	}

	func getWord() -> URLRequest {
		return self.requestBuilderFactory()
			.path("getNew")
			.build(with: EmptyQuery())
	}

	func leaders() -> URLRequest {
		return self.requestBuilderFactory()
			.path("leaders")
			.build(with: EmptyQuery())
	}

	func auth(login: String, password: String) -> URLRequest
	{
		return self.requestBuilderFactory()
			.path("auth")
			.httpMethod(.post)
			.build(with: User(email: login, password: password))
	}

	func createUser(email: String, password: String) -> URLRequest {
		return self.requestBuilderFactory()
			.path("create")
			.httpMethod(.post)
			.build(with: User(email: email, password: password))
	}
}
