//
//  HistoryRepositoryTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 05.08.2021.
//

import Combine
import XCTest

@testable import PLOSClient

@MainActor
final class HistoryRepositoryTests: XCTestCase {
    private var storage: FakeHistoryStorage!
    private var repository: DefaultHistoryRepository!

    override func setUp() {
        storage = FakeHistoryStorage()
        storage.saveAnswer = Answer.nothing()
        storage.loadAnswer = Answer.nothing()
        repository = DefaultHistoryRepository(storage: storage)
    }

    func testWrite() async throws {
        // Arrange
        storage.saveAnswer = Answer.success(true)

        // Act
        let result = try await value(repository.write(item: .stub))
        
        // Assert
        XCTAssertEqual(result, true)
    }
    
    func testWriteError() async {
        // Arrange
        storage.saveAnswer = Answer.fail()

        // Act
        let result = await error(repository.write(item: .stub))
        
        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
    
    func testRead() async throws {
        // Arrange
        storage.loadAnswer = Answer.success(.stub)

        // Act
        let result = try await value(repository.read())
        
        // Assert
        XCTAssertEqual(result, .stub)
    }

    func testReadError() async {
        // Arrange
        storage.loadAnswer = Answer.fail()

        // Act
        let result = await error(repository.read())

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
}
