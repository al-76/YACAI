//
//  DocumentsRepositoryTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 05.08.2021.
//

import XCTest
import RxSwift
import RxTest

@testable import PLOSClient

private let testErrorString = "error"

private class MockNetwork: Network {
    func get(with url: String, completion: @escaping Completion) -> Cancellable? {
        if url.contains(testErrorString) {
            completion(.failure(TestError.someError))
            return nil
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
        return nil
    }
}

private class MockMapper: Mapper {
    func map(input: DocumentDTO) -> Document {
        return Document("test")
    }
}

class DocumentsRepositoryTests: XCTestCase {
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    var repository: DocumentsRepository!
    
    override func setUp() {
        repository = DocumentsRepository(network: MockNetwork(),
                                         mapper: AnyMapper(wrapped: MockMapper()))
    }
    
    func testRead() {
        // Arrange
        let output = scheduler.createObserver(DocumentResult.self)
        repository.read(query: "test")
            .bind(to: output)
            .disposed(by: disposeBag)

        // Act
        scheduler.start()

        // Assert
        XCTAssertRecordedElements(output.events, [
            .success([Document("test")])
        ])
    }
    
    func testReadError() {
        // Arrange
        let output = scheduler.createObserver(DocumentResult.self)
        repository.read(query: testErrorString)
            .bind(to: output)
            .disposed(by: disposeBag)

        // Act
        scheduler.start()

        // Assert
        XCTAssertRecordedElements(output.events, [
            .failure(TestError.someError)
        ])
    }
}
