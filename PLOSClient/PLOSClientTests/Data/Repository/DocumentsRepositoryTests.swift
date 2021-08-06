//
//  DocumentsRepositoryTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 05.08.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private let testErrorString = "error"

private enum TestError: Error {
    case someError
}

class MockNetwork: Network {
    func get(with url: String, completion: @escaping Completion) {
        if url.contains(testErrorString) {
            completion(.failure(TestError.someError))
            return
        }
        completion(.success(Data("""
        {
          "response": {
            "numFound": 300,
            "start": 0,
            "docs": [
                {
                    "id": "id",
                    "journal": "journal",
                    "publication_date": "publication_date",
                    "title_display": "title_display",
                    "article_type": "article_type",
                    "author_display": ["author1", "author2"],
                    "abstract": ["Some", "text"],
                    "counter_total_all": 100500
                }
            ]
          }
        }
        """.utf8)))
    }
}

class MockMapper: Mapper {
    typealias Input = DocumentDTO
    typealias Output = Document

    func map(input: DocumentDTO) -> Document {
        return Document("test")
    }
}

class DocumentsRepositoryTests: XCTestCase {
    let repository = DocumentsRepository(network: MockNetwork(),
                                         mapper: AnyMapper(wrapped: MockMapper()))
    
    func testRead() throws {
        // Arrange
        let expected = [Document("test")]

        // Act
        let res = try await(repository.read(query: "test"))

        // Assert
        XCTAssertEqual(res, expected)
    }
    
    func testReadError() throws {
        // Arrange
        let expected = TestError.someError

        // Act
        let res = try awaitError(repository.read(query: testErrorString))

        // Assert
        XCTAssertEqual(res as? TestError, expected)
    }
}