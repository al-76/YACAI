//
//  HistoryRepositoryTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 05.08.2021.
//

import RxSwift
import RxTest
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
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)

    func testAdd() {
        // Arrange
        let output = scheduler.createObserver(BoolResult.self)
        let repository = HistoryRepository(storage: MockStorage(Data()))
        repository.add(item: History(id: "test"))
            .bind(to: output)
            .disposed(by: disposeBag)

        // Act
        scheduler.start()

        // Assert
        XCTAssertRecordedElements(output.events, [
            .success(true)
        ])
    }

    func testAddError() {
        // Arrange
        let output = scheduler.createObserver(BoolResult.self)
        let repository = HistoryRepository(storage: MockErrorStorage())
        repository.add(item: History(id: testErrorString))
            .bind(to: output)
            .disposed(by: disposeBag)

        // Act
        scheduler.start()

        // Assert
        XCTAssertRecordedElements(output.events, [
            .failure(TestError.someError)
        ])
    }

    func testRead() throws {
        // Arrange
        let output = scheduler.createObserver(HistoryResult.self)
        let expected = [
            History(id: "test1"),
            History(id: "test2")
        ]
        let data = try JSONEncoder().encode(expected)
        let repository = HistoryRepository(storage: MockStorage(data))
        repository.read(query: "")
            .bind(to: output)
            .disposed(by: disposeBag)

        // Act
        scheduler.start()

        // Assert
        XCTAssertRecordedElements(output.events, [
            .success(expected)
        ])
    }

    func testReadQuery() throws {
        // Arrange
        let output = scheduler.createObserver(HistoryResult.self)
        let testQuery = "test1"
        let data = try JSONEncoder().encode([
            History(id: testQuery),
            History(id: "test2")
        ])
        let repository = HistoryRepository(storage: MockStorage(data))
        repository.read(query: testQuery)
            .bind(to: output)
            .disposed(by: disposeBag)

        // Act
        scheduler.start()

        // Assert
        XCTAssertRecordedElements(output.events, [
            .success([History(id: testQuery)])
        ])
    }

    func testReadNotFound() throws {
        // Arrange
        let output = scheduler.createObserver(HistoryResult.self)
        let testQuery = "not found"
        let data = try JSONEncoder().encode([
            History(id: "test1"),
            History(id: "test2")
        ])
        let repository = HistoryRepository(storage: MockStorage(data))
        repository.read(query: testQuery)
            .bind(to: output)
            .disposed(by: disposeBag)

        // Act
        scheduler.start()

        // Assert
        XCTAssertRecordedElements(output.events, [
            .success([History]())
        ])
    }
}
