//
//  SearchDocumentUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private class MockRepository: QueryRepository {
    private let documents: [Document]

    init(documents: [Document]) {
        self.documents = documents
    }

    func read(query: String) -> AnyPublisher<[Document], Error> {
        Just(documents)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class SearchDocumentUseCaseTests: XCTestCase {
    func testExecute() throws {
        // Arrange
        let expected = [Document("test")]
        let repository = MockRepository(documents: expected)
        let useCase = SearchDocumentUseCase(repository: AnyQueryRepository(wrapped: repository))

        // Act
        let res = try awaitPublisher(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(res, expected)
    }
}
