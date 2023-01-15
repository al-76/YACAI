//
//  SearchHistoryUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import XCTest

@testable import PLOSClient

@MainActor
final class SearchHistoryUseCaseTests: XCTestCase {
    private var repository: FakeHistoryRepository!
    private var useCase: SearchHistoryUseCase!

    override func setUp() async throws {
        repository = FakeHistoryRepository()
        useCase = SearchHistoryUseCase(repository: repository)
    }

    func testExecute() async throws {
        // Arrange
        repository.readAnswer = Answer.success(.stub)

        // Act
        let result = try await value(useCase(with: ""))

        // Assert
        XCTAssertEqual(result, .stub.reversed())
    }

    func testExecuteFilter() async throws {
        // Arrange
        repository.readAnswer = Answer.success(.stub)

        // Act
        let result = try await value(useCase(with: "Ribos"))

        // Assert
        XCTAssertEqual(result, [.stub])
    }

    func testExecuteError() async {
        // Arrange
        repository.readAnswer = Answer.fail()

        // Act
        let result = await error(useCase(with: ""))

        // Assert
        XCTAssertEqual(result as? TestError, .someError)
    }
}
