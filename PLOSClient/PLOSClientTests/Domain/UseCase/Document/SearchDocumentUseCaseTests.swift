//
//  SearchDocumentUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import XCTest

@testable import PLOSClient

@MainActor
final class SearchDocumentUseCaseTests: XCTestCase {
    private var repository: FakeDocumentsRepository!
    private var useCase: SearchDocumentUseCase!

    override func setUp() async throws {
        repository = FakeDocumentsRepository()
        useCase = SearchDocumentUseCase(repository: repository)
    }

    func testExecute() async throws {
        // Arrange
        repository.readAnswer = Answer.success(.stub)

        // Act
        let result = try await value(useCase(with: "test"))

        // Assert
        XCTAssertEqual(result, .stub)
    }

    func testExecuteError() async {
        // Arrange
        repository.readAnswer = Answer.fail()

        // Act
        let result = await error(useCase(with: "test"))

        // Assert
        XCTAssertEqual(result as? TestError, .someError)
    }
}
