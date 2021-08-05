//
//  SearchViewModelTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private let testErrorString = "error"

extension ViewError: Equatable {
    public static func == (lhs: ViewError, rhs: ViewError) -> Bool {
        lhs.id == rhs.id
    }
}

private enum TestError: Error {
    case someError
}

class MockSearchHistoryUseCase: UseCase {
    typealias Input = String
    typealias Output = [History]
    
    func execute(with input: String) -> AnyPublisher<[History], Error> {
        if input == testErrorString {
            return Fail(error: TestError.someError)
                .eraseToAnyPublisher()
        }
        return Just([History(id: input)])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockAddHistoryUseCase: UseCase {
    typealias Input = String
    typealias Output = Bool
    
    func execute(with input: String) -> AnyPublisher<Bool, Error> {
        if input == testErrorString {
            return Fail(error: TestError.someError)
                .eraseToAnyPublisher()
        }
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class SearchViewModelTests: XCTestCase {
    let viewModel = SearchViewModel(searchHistoryUseCase: AnyUseCase(wrapped: MockSearchHistoryUseCase()),
                                    addHistoryUseCase: AnyUseCase(wrapped: MockAddHistoryUseCase()))
    
    func testHistorySearch() throws {
        // Arrange
        let testQuery = "test"
        let expected = [History(id: testQuery)]
        
        // Act
        viewModel.text = testQuery
        
        // Assert
        let res = try await(viewModel.$history.dropFirst())
        XCTAssertEqual(res, expected)
    }
    
    func testHistorySearchError() throws {
        // Arrange
        let expected = ViewError(TestError.someError)
        
        // Act
        viewModel.text = testErrorString
        
        // Assert
        let res = try await(viewModel.$error.dropFirst())
        XCTAssertEqual(res, expected)
    }
    
    func testAddHistory() throws {
        // Arrange
        let expected = [History(id: "")]
        
        // Act
        viewModel.historyText = "test"
        
        // Assert
        let res = try await(viewModel.$history.dropFirst(2))
        XCTAssertEqual(res, expected)
    }
    
    func testAddHistoryError() throws {
        // Arrange
        let expected = ViewError(TestError.someError)
        
        // Act
        viewModel.historyText = testErrorString
        
        // Assert
        let res = try await(viewModel.$error.dropFirst())
        XCTAssertEqual(res, expected)
    }
}
        
