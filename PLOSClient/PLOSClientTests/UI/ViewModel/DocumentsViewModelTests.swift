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

private class MockSearchDocumentUseCase: UseCase {
    func execute(with input: String) -> AnyPublisher<[Document], Error> {
        if input == testErrorString {
            return Fail(error: TestError.someError)
                .eraseToAnyPublisher()
        }
        return Just([Document(input)])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class DocumentsViewModelTests: XCTestCase {
    var viewModel: DocumentsViewModel!
    
    override func setUp() {
        viewModel = DocumentsViewModel(searchUseCase: AnyUseCase(wrapped: MockSearchDocumentUseCase()))
    }
    
    func testHistorySearch() throws {
        // Arrange
        let testQuery = "test"
        let expected = [Document(testQuery)]
        
        // Act
        viewModel.searchDocument = testQuery
        
        // Assert
        let res = try awaitPublisher(viewModel.$documents.dropFirst())
        XCTAssertEqual(res, expected)
    }
    
    func testHistorySearchError() throws {
        // Arrange
        let expected = ViewError(TestError.someError)
        
        // Act
        viewModel.searchDocument = testErrorString
        
        // Assert
        let res = try awaitPublisher(viewModel.$error.dropFirst())
        XCTAssertEqual(res, expected)
    }
}
