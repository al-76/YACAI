//
//  SearchHistoryUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private class MockRepository: QueryRepository {
    typealias T = History

    func read(query: String) -> AnyPublisher<[History], Error> {
        return Just([History(id: query)])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class SearchHistoryUseCaseTests: XCTestCase {
    func testExecute() throws {
        // Arrange
        let testQuery = "test"
        let expected = [History(id: testQuery)]
        let repository = MockRepository()
        let useCase = SearchHistoryUseCase(repository: AnyQueryRepository(wrapped: repository))

        // Act
        let res = try await(useCase.execute(with: testQuery))

        // Assert
        XCTAssertEqual(res, expected)
    }
}