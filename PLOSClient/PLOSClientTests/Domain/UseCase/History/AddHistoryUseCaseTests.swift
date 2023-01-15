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
        repository.readAnswer = Answer.nothing()
        repository.writeAnswer = Answer.nothing()
        useCase = AddHistoryUseCase(repository: repository)
    }

    func testExecute() async throws {
        // Arrange
        repository.readAnswer = Answer.success(.stub)
        repository.writeAnswer = Answer.success(true)

        // Act
        let result = try await value(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(result, true)
    }

    func testExecuteDuplicate() async throws {
        // Arrange
        let item = History.stub.id
        repository.readAnswer = Answer.success(.stub)
        repository.writeAnswer = Answer.success(true)

        // Act
        let result = try await value(useCase.execute(with: item))

        // Assert
        XCTAssertEqual(result, false)
    }

    func testExecuteWriteError() async {
        // Arrange
        repository.readAnswer = Answer.success(.stub)
        repository.writeAnswer = Answer.fail()

        // Act
        let result = await error(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(result as? TestError, .someError)
    }

    func testExecuteReadError() async {
        // Arrange
        repository.readAnswer = Answer.fail()

        // Act
        let result = await error(useCase.execute(with: "test"))

        // Assert
        XCTAssertEqual(result as? TestError, .someError)
    }
}

