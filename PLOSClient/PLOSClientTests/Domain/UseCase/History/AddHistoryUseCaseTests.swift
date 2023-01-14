//
//  AddHistoryUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 31.07.2021.
//

import Combine
import XCTest

@testable import PLOSClient

@MainActor
final class AddHistoryUseCaseTests: XCTestCase {
    private var repository: FakeHistoryRepository!
    private var useCase: AddHistoryUseCase!

    override func setUp() async throws {
        repository = FakeHistoryRepository()
        useCase = AddHistoryUseCase(repository: repository)
    }

    func testExecute() async throws {
        // Arrange
        repository.writeAnswer = Answer.successAnswer(true)

        // Act
        let result = try await value(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(result, true)
    }

    func testExecuteError() async {
        // Arrange
        repository.writeAnswer = Answer.failAnswer()

        // Act
        let result = await error(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(result as? TestError, .someError)
    }
}

