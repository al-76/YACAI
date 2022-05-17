//
//  DocumentsViewModelTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import XCTest

@testable import PLOSClient

private let testError = "error"

private class MockSearchUseCase: UseCase {
    func execute(with input: String) async throws -> [Document] {
        if input == testError {
            throw TestError.someError
        }
        return [Document(input)]
    }
}

class DocumentsViewModelTests: XCTestCase {
    var viewModel: DocumentsViewModel!
    
    override func setUp() {
        viewModel = DocumentsViewModel(searchUseCase: AnyUseCase(wrapped: MockSearchUseCase()))
    }
    
    func testSearchDocuments() {
        // Arrange
        let testQuery = "test"
        let found = expectation(description: "Documents are found!")
        var documents: [Document]?
        viewModel.documents.bind {
            documents = $0
            found.fulfill()
        }
        
        // Act
        viewModel.search(document: testQuery)
        
        // Assert
        waitForExpectations(timeout: 3)
        XCTAssertEqual(documents, [Document(testQuery)])
    }
    
    func testSearchDocumentsError() {
        // Arrange
        let found = expectation(description: "There's an error!")
        var error: Error?
        viewModel.error.bind {
            error = $0
            found.fulfill()
        }
        
        // Act
        viewModel.search(document: testError)
        
        // Assert
        waitForExpectations(timeout: 3)
        XCTAssertEqual(error as! TestError, TestError.someError)
    }
}
