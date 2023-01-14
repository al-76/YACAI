//
//  DocumentsViewModelTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private let testErrorString = "error"

private class MockSearchHistoryUseCase: UseCase {
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

private class MockAddHistoryUseCase: UseCase {
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

class DocumentsViewModelTests: XCTestCase {
    var viewModel: DocumentsViewModel!
    
    override func setUp() {
        viewModel = DocumentsViewModel(searchHistoryUseCase: MockSearchHistoryUseCase(),
                                       addHistoryUseCase: MockAddHistoryUseCase())
    }
    
    func testHistorySearch() throws {
        // Arrange
        let testQuery = "test"
        let expected = [History(id: testQuery)]
        
        // Act
        viewModel.searchHistory = testQuery
        
        // Assert
        let res = try awaitPublisher(viewModel.$history.dropFirst(2))
        XCTAssertEqual(res, expected)
    }
    
    func testHistorySearchError() throws {
        // Arrange
        let expected = ViewError(TestError.someError)
        
        // Act
        viewModel.searchHistory = testErrorString
        
        // Assert
        let res = try awaitPublisher(viewModel.$error.dropFirst())
        XCTAssertEqual(res, expected)
    }
    
    func testAddHistory() throws {
        // Arrange
        let expected = [History(id: "")]
        
        // Act
        viewModel.addHistory = "test"
        
        // Assert
        let res = try awaitPublisher(viewModel.$history.dropFirst(2))
        XCTAssertEqual(res, expected)
    }
    
    func testAddHistoryError() throws {
        // Arrange
        let expected = ViewError(TestError.someError)
        
        // Act
        viewModel.addHistory = testErrorString
        
        // Assert
        let res = try awaitPublisher(viewModel.$error.dropFirst())
        XCTAssertEqual(res, expected)
    }
}
        
