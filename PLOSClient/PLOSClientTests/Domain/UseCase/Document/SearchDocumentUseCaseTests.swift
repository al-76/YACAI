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

extension Document: Equatable {
    public static func == (lhs: Document, rhs: Document) -> Bool {
        lhs.id == rhs.id
    }
}

private class MockRepository: QueryRepository {
    private let documents: [Document]

    init(documents: [Document]) {
        self.documents = documents
    }

    func read(query: String) -> AnyPublisher<[Document], Error> {
        return Just(documents)
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
        let res = try await(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(res, expected)
    }
}
