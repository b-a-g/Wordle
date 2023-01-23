//
//  IRequestConfigurator.swift
//  Wordle
//
//  Created by e.razdrogin on 18.01.2023.
//

protocol IRequestConfigurator: AnyObject
{
	var requestConfig: RequestConfig? { get set }

	@discardableResult
	func httpMethod(_ httpMethod: HTTPMethod) -> Self

	@discardableResult
	func path(_ path: String) -> Self
}

extension IRequestConfigurator
{
	@discardableResult
	func httpMethod(_ httpMethod: HTTPMethod) -> Self {
		self.requestConfig?.httpMethod = httpMethod
		return self
	}

	@discardableResult
	func path(_ path: String) -> Self {
		self.requestConfig?.path = path
		return self
	}
}
