//
//  DocumentListViewModelTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Combine
import XCTest

@testable import PLOSClient

final class DocumentListViewModelTests: XCTestCase {
    private var useCase: FakeSearchDocumentUseCase!
    private var viewModel: DocumentListViewModel<ImmediateScheduler>!
    
    override func setUp() {
        useCase = FakeSearchDocumentUseCase()
        viewModel = DocumentListViewModel(searchUseCase: useCase,
                                          scheduler: ImmediateScheduler.shared)
    }
    
    func testHistorySearch() throws {
        // Arrange
        useCase.answer = Answer.success(.stub)
        
        // Act
        viewModel.searchDocument = "test"
        
        // Assert
        XCTAssertEqual(viewModel.documents, .stub)
    }
    
    func testHistorySearchError() throws {
        // Arrange
        useCase.answer = Answer.fail()
        
        // Act
        viewModel.searchDocument = "test"
        
        // Assert
        XCTAssertEqual(viewModel.error, ViewError(TestError.someError))
    }
}
