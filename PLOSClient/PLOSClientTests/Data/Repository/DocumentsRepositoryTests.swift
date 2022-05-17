//
//  DocumentsRepositoryTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 05.08.2021.
//

import XCTest

@testable import PLOSClient

private let testErrorString = "error"

private class MockNetwork: Network {
    func get(with url: String) async throws -> Data {
        if url.contains(testErrorString) {
            throw TestError.someError
        }
        
        return Data("""
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
        """.utf8)
    }
}

private class MockMapper: Mapper {
    func map(input: DocumentDTO) -> Document {
        Document("test")
    }
}

class DocumentsRepositoryTests: XCTestCase {
    private var repository: DocumentsRepository!
    
    override func setUp() {
        repository = DocumentsRepository(network: MockNetwork(),
                                         mapper: AnyMapper(wrapped: MockMapper()))
    }
    
    func testRead() async throws {
        // Arrange

        // Act
        let result = try await repository.read(query: "test")

        // Assert
        XCTAssertEqual(result, [Document("test")])
    }
    
    func testReadError() async throws {
        // Arrange

        // Act
        do {
            _ = try await repository.read(query: testErrorString)
            XCTFail("We need an error here!")
        } catch let error {
            // Assert
            XCTAssertEqual(error as! TestError, TestError.someError)
        }
    }
}
