//
//  HistoryViewModelTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import XCTest

@testable import PLOSClient

private let testError = "error"

private class MockAddHistoryUseCase: UseCase {
    func execute(with input: String) async throws -> Bool {
        if input == testError {
            throw TestError.someError
        }
        return true
    }
}

private class MockSearchHistoryUseCase: UseCase {
    func execute(with input: String) async throws -> [History] {
        if input == testError {
            throw TestError.someError
        }
        return [History(id: input)]
    }
}

class HistoryViewModelTests: XCTestCase {
    var viewModel: HistoryViewModel!

    override func setUp() {
        viewModel = HistoryViewModel(searchHistoryUseCase: AnyUseCase(wrapped: MockSearchHistoryUseCase()),
                                     addHistoryUseCase: AnyUseCase(wrapped: MockAddHistoryUseCase()))
    }

    func testSearchHistory() {
        // Arrange
        let testQuery = "test"
        var history: [History]?
        let found = expectation(description: "History is found!")
        viewModel.history.bind {
            history = $0
            found.fulfill()
        }

        // Act
        viewModel.search(history: testQuery)

        // Assert
        waitForExpectations(timeout: 3)
        XCTAssertEqual(history, [History(id: testQuery)])
    }

    func testSearchHistoryError() {
        // Arrange
        let found = expectation(description: "There's an error!")
        var error: Error?
        viewModel.error.bind {
            error = $0
            found.fulfill()
        }

        // Act
        viewModel.search(history: testError)

        // Assert
        waitForExpectations(timeout: 3)
        XCTAssertEqual(error as! TestError, TestError.someError)
    }

    func testAddHistory() {
        // Arrange
        let testQuery = "test"
        var history: [History]?
        let found = expectation(description: "History has added!")
        viewModel.history.bind {
            history = $0
            found.fulfill()
        }

        // Act
        viewModel.add(history: testQuery)

        // Assert
        waitForExpectations(timeout: 3)
        XCTAssertEqual(history, [History(id: testQuery)])
    }

    func testAddHistoryError() {
        // Arrange
        let found = expectation(description: "There's an error!")
        var error: Error?
        viewModel.error.bind {
            error = $0
            found.fulfill()
        }

        // Act
        viewModel.add(history: testError)

        // Assert
        waitForExpectations(timeout: 3)
        XCTAssertEqual(error as! TestError, TestError.someError)
    }
}
