//
//  DocumentsViewModelTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Combine
import XCTest

@testable import PLOSClient

final class DocumentsViewModelTests: XCTestCase {
    private var searchHistoryUseCase: FakeSearchHistoryUseCase!
    private var addHistoryUseCase: FakeAddHistoryUseCase!
    private var viewModel: DocumentsViewModel<ImmediateScheduler>!
    
    override func setUp() {
        searchHistoryUseCase = FakeSearchHistoryUseCase()
        addHistoryUseCase = FakeAddHistoryUseCase()
        viewModel = DocumentsViewModel(searchHistoryUseCase: searchHistoryUseCase,
                                       addHistoryUseCase: addHistoryUseCase,
                                       scheduler: ImmediateScheduler.shared)
    }
    
    func testHistorySearch() throws {
        // Arrange
        searchHistoryUseCase.answer = Answer.success(.stub)
        addHistoryUseCase.answer = Answer.nothing()
        
        // Act
        viewModel.searchHistory = "test"
        
        // Assert
        XCTAssertEqual(viewModel.history, .stub)
    }
    
    func testHistorySearchError() throws {
        // Arrange
        searchHistoryUseCase.answer = Answer.fail()
        addHistoryUseCase.answer = Answer.nothing()

        // Act
        viewModel.searchHistory = "test"

        // Assert
        XCTAssertEqual(viewModel.error, ViewError(TestError.someError))
    }
    
    func testAddHistory() throws {
        // Arrange
        searchHistoryUseCase.answer = Answer.success(.stub)
        addHistoryUseCase.answer = Answer.success(true)

        // Act
        viewModel.addHistory = "test"

        // Assert
        XCTAssertEqual(viewModel.history, .stub)
    }

    func testAddHistoryError() throws {
        // Arrange
        searchHistoryUseCase.answer = Answer.nothing()
        addHistoryUseCase.answer = Answer.fail()

        // Act
        viewModel.addHistory = "test"

        // Assert
        XCTAssertEqual(viewModel.error, ViewError(TestError.someError))
    }
}
        
