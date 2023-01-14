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
        repository.readAnswer = Answer.successAnswer(.stub)

        // Act
        let result = try await value(useCase.execute(with: ""))

        // Assert
        XCTAssertEqual(result, .stub.reversed())
    }

    func testExecuteFilter() async throws {
        // Arrange
        repository.readAnswer = Answer.successAnswer(.stub)

        // Act
        let result = try await value(useCase.execute(with: "Ribos"))

        // Assert
        XCTAssertEqual(result, [.stub])
    }

    func testExecuteError() async {
        // Arrange
        repository.readAnswer = Answer.failAnswer()

        // Act
        let result = await error(useCase.execute(with: ""))

        // Assert
        XCTAssertEqual(result as? TestError, .someError)
    }
}
