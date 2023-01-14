//
//  AddHistoryUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private class MockRepository: HistoryRepository {
    func read() -> AnyPublisher<[PLOSClient.History], Error> {
        Empty().eraseToAnyPublisher()
    }

    func write(item: History) -> AnyPublisher<Bool, Error> {
        Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class AddHistoryUseCaseTests: XCTestCase {
    func testExecute() throws {
        // Arrange
        let expected = true
        let repository = MockRepository()
        let useCase = AddHistoryUseCase(repository: repository)

        // Act
        let res = try awaitPublisher(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(res, expected)
    }
}

