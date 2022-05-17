//
//  SearchDocumentUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import XCTest

@testable import PLOSClient

private class MockQueryRepository: QueryRepository {
    func read(query: String) async throws -> [Document] {
        [Document(query)]
    }
}

class SearchDocumentUseCaseTests: XCTestCase {
    func testExecute() async throws {
        // Arrange
        let testQuery = "test"
        let useCase = SearchDocumentUseCase(repository: AnyQueryRepository(wrapped: MockQueryRepository()))
        
        // Act
        let result = try await useCase.execute(with: testQuery)
        
        // Assert
        XCTAssertEqual(result, [Document(testQuery)])
    }
}
