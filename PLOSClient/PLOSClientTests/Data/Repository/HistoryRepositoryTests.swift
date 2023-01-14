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
    
    func save<T: Codable>(id: String, object: T) throws {
    }
    
    func clear(id: String) throws {
    }
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
    func testWrite() throws {
        // Arrange
        let expected = true
        let repository = DefaultHistoryRepository(storage: MockStorage(Data()))
        
        // Act
        let res = try awaitPublisher(repository.write(item: History(id: "test")))
        
        // Assert
        XCTAssertEqual(res, expected)
    }
    
    func testWriteError() throws {
        // Arrange
        let expected = TestError.someError
        let repository = DefaultHistoryRepository(storage: MockErrorStorage())
        
        // Act
        let res = try awaitError(repository.write(item: History(id: "test")))
        
        // Assert
        XCTAssertEqual(res as? TestError, expected)
    }
    
    func testRead() throws {
        // Arrange
        let expected = [
            History(id: "test1"),
            History(id: "test2")
        ]
        let data = try JSONEncoder().encode(expected)
        let repository = DefaultHistoryRepository(storage: MockStorage(data))
        
        // Act
        let res = try awaitPublisher(repository.read())
        
        // Assert
        XCTAssertEqual(res, expected)
    }
}
