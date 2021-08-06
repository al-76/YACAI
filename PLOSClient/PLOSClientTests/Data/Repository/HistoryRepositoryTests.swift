//
//  HistoryRepositoryTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 05.08.2021.
//

import Combine
import XCTest

@testable import PLOSClient

private let testErrorString = "error"

class MockStorage: Storage {
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
    
    func save<T: Codable>(id: String, object: T) throws {
    }
    
    func clear(id: String) throws {
    }
}

class MockErrorStorage: Storage {
    func get<T: Codable>(id: String, defaultObject: T) -> T {
        return defaultObject
    }
    
    func save<T: Codable>(id: String, object: T) throws {
        throw TestError.someError
    }
    
    func clear(id: String) throws {
        throw TestError.someError
    }
}

class HistoryRepositoryTests: XCTestCase {
    func testAdd() throws {
        // Arrange
        let expected = true
        let repository = HistoryRepository(storage: MockStorage(Data()))
        
        // Act
        let res = try await(repository.add(item: History(id: "test")))
        
        // Assert
        XCTAssertEqual(res, expected)
    }
    
    func testAddError() throws {
        // Arrange
        let expected = TestError.someError
        let repository = HistoryRepository(storage: MockErrorStorage())
        
        // Act
        let res = try awaitError(repository.add(item: History(id: "test")))
        
        // Assert
        XCTAssertEqual(res as? TestError, expected)
    }
    
    func testRead() throws {
        // Arrange
        let testQuery = ""
        let expected = [
            History(id: "test1"),
            History(id: "test2")
        ]
        let data = try JSONEncoder().encode(expected)
        let repository = HistoryRepository(storage: MockStorage(data))
        
        // Act
        let res = try await(repository.read(query: testQuery))
        
        // Assert
        XCTAssertEqual(res, expected)
    }
    
    func testReadQuery() throws {
        // Arrange
        let testQuery = "test1"
        let expected = [History(id: testQuery)]
        let data = try JSONEncoder().encode([
            History(id: testQuery),
            History(id: "test2")
        ])
        let repository = HistoryRepository(storage: MockStorage(data))
        
        // Act
        let res = try await(repository.read(query: testQuery))
        
        // Assert
        XCTAssertEqual(res, expected)
    }
    
    func testReadNotFound() throws {
        // Arrange
        let testQuery = "not found"
        let expected = [History]()
        let data = try JSONEncoder().encode([
            History(id: "test1"),
            History(id: "test2")
        ])
        let repository = HistoryRepository(storage: MockStorage(data))
        
        // Act
        let res = try await(repository.read(query: testQuery))
        
        // Assert
        XCTAssertEqual(res, expected)
    }
}
