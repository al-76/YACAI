//
//  SearchHistoryUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private class MockRepository: HistoryRepository {
    private let query: String

    init(query: String) {
        self.query = query
    }

    func read() -> AnyPublisher<[History], Error> {
        Just([History(id: query)])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func write(item: PLOSClient.History) -> AnyPublisher<Bool, Error> {
        Empty().eraseToAnyPublisher()
    }
}

class SearchHistoryUseCaseTests: XCTestCase {
    func testExecute() throws {
        // Arrange
        let testQuery = "test"
        let expected = [History(id: testQuery)]
        let repository = MockRepository(query: testQuery)
        let useCase = SearchHistoryUseCase(repository: repository)

        // Act
        let res = try awaitPublisher(useCase.execute(with: testQuery))

        // Assert
        XCTAssertEqual(res, expected)
    }
}
