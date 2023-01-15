//
//  DocumentsRepositoryTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 05.08.2021.
//

import Combine
import XCTest

@testable import PLOSClient

@MainActor
final class DocumentsRepositoryTests: XCTestCase {
    private var network: FakeNetwork!
    private var repository: DefaultDocumentsRepository!

    override func setUp() {
        network = FakeNetwork()
        repository = DefaultDocumentsRepository(network: network)
    }

    func testRead() async throws {
        // Arrange
        network.answer = Answer.success(Data("""
            { "response":{"numFound":3518,"start":0,"docs":[
                {
                  "id":"\(Document.stub.id)",
                  "journal":"\(Document.stub.journal)",
                  "publication_date":"\(ISO8601DateFormatter().string(from: Date.distantPast))",
                  "article_type":"\(Document.stub.articleType)",
                  "author_display":["\(Document.stub.authorDisplay)"],
                  "abstract":["\(Document.stub.abstract)"],
                  "title_display":"\(Document.stub.titleDisplay)",
                  "counter_total_all":\(Document.stub.counterTotalAll)
                }
            ]} }
            """.utf8))

        // Act
        let result = try await value(repository.read(query: "test"))

        // Assert
        XCTAssertEqual(result, .stub)
    }

    func testReadError() async {
        // Arrange
        network.answer = Answer.fail()

        // Act
        let result = await error(repository.read(query: "test"))

        // Assert
        XCTAssertEqual(result as? TestError, .someError)
    }
}
