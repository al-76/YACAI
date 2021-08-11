//
//  AddHistoryUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private class MockRepository: CommandRepository {
    func add(item: History) -> AnyPublisher<Bool, Error> {
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class AddHistoryUseCaseTests: XCTestCase {
    func testExecute() throws {
        // Arrange
        let expected = true
        let repository = MockRepository()
        let useCase = AddHistoryUseCase(repository: AnyCommandRepository(wrapped: repository))

        // Act
        let res = try await(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(res, expected)
    }
}

