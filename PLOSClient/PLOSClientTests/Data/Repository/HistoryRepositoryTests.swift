//
//  HistoryRepositoryTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 05.08.2021.
//

import XCTest

@testable import PLOSClient

private let testErrorString = "error"

private class MockStorage: Storage {
    private let data: Data

    init(_ data: Data) {
        self.data = data
    }

    func get<T: Codable>(id: String, defaultObject: T) -> T {
        if let res = try? JSONDecoder().decode(T.self, from: data) {
            return res
        }
        return defaultObject
    }

    func save<T: Codable>(id: String, object: T) throws {}

    func clear(id: String) throws {}
}

private class MockErrorStorage: Storage {
    func get<T: Codable>(id: String, defaultObject: T) -> T {
        defaultObject
    }

    func save<T: Codable>(id: String, object: T) throws {
        throw TestError.someError
    }

    func clear(id: String) throws {
        throw TestError.someError
    }
}

class HistoryRepositoryTests: XCTestCase {
    func testAdd() async throws {
        // Arrange
        let repository = HistoryRepository(storage: MockStorage(Data()))

        // Act
        let result = try await repository.add(item: History(id: "test"))

        // Assert
        XCTAssertEqual(result, true)
    }

    func testAddError() async throws {
        // Arrange
        let repository = HistoryRepository(storage: MockErrorStorage())

        // Act
        do {
            _ = try await repository.add(item: History(id: testErrorString))
        } catch let error {
            // Assert
            XCTAssertEqual(error as! TestError, TestError.someError)
        }
    }

    func testRead() async throws {
        // Arrange
        let expected = [
            History(id: "test1"),
            History(id: "test2")
        ]
        let data = try JSONEncoder().encode(expected)
        let repository = HistoryRepository(storage: MockStorage(data))

        // Act
        let result = try await repository.read(query: "")

        // Assert
        XCTAssertEqual(result, expected)
    }

    func testReadQuery() async throws {
        // Arrange
        let testQuery = "test1"
        let data = try JSONEncoder().encode([
            History(id: testQuery),
            History(id: "test2")
        ])
        let repository = HistoryRepository(storage: MockStorage(data))

        // Act
        let result = try await repository.read(query: testQuery)

        // Assert
        XCTAssertEqual(result, [History(id: testQuery)])
    }

    func testReadNotFound() async throws {
        // Arrange
        let testQuery = "not found"
        let data = try JSONEncoder().encode([
            History(id: "test1"),
            History(id: "test2")
        ])
        let repository = HistoryRepository(storage: MockStorage(data))

        // Act
        let result = try await repository.read(query: testQuery)

        // Assert
        XCTAssertEqual(result, [History]())
    }
}
