//
//  XCTestCase+Await.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import XCTest

enum TestAwaitError: Error {
    case unexpectedResult
}

extension XCTestCase {
    func values<T: Publisher>(_ publisher: T) async throws -> [T.Output] {
        var result: [T.Output] = []

        for try await value in publisher.values {
            result.append(value)
        }

        return result
    }

    func value<T: Publisher>(_ publisher: T) async throws -> T.Output? {
        (try await values(publisher)).first
    }

    func error<T: Publisher>(_ publisher: T) async -> T.Failure where T.Failure == Error {
        do {
            _ = try await values(publisher)
        } catch let error {
            return error
        }

        return TestAwaitError.unexpectedResult
    }
}
