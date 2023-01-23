//
//  RequestBuilder.swift
//  Wordle
//
//  Created by e.razdrogin on 18.01.2023.
//

import Foundation

protocol IRequestBuilder: IRequestConfigurator
{
	func build<Q: Encodable>(with query: Q?) -> URLRequest
}

final class RequestBuilder
{
	private let endpoint: URL = URL(string: "localhost: 8080")!
	private let encoder = JSONEncoder()

	var requestConfig: RequestConfig?

}

extension RequestBuilder: IRequestBuilder
{
	func build<Q: Encodable>(with query: Q) -> URLRequest {
		var request = URLRequest(url: self.endpoint.appendingPathComponent(self.requestConfig?.path ?? ""))
		request.httpMethod = self.requestConfig?.httpMethod.rawValue
		request.httpBody = try? encoder.encode(query)

		return request
	}
}
