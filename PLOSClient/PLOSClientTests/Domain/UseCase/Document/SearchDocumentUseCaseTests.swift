//
//  SearchDocumentUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import XCTest
import Resolver

@testable import PLOSClient

extension Document {
    init(_ id: String) {
        self.init(id: id,
                  publicationDate: "test",
                  authorDisplay: "test",
                  abstract: "test",
                  titleDisplay: "test",
                  articleType: "test",
                  journal: "test",
                  counterTotallAll: 1000)
    }
}

private struct MockRepository: QueryRepository {
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
