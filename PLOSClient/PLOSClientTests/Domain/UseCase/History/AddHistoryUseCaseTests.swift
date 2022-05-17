//
//  AddHistoryUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import XCTest

@testable import PLOSClient

private class MockCommandRepository: CommandRepository {
    func add(item: History) async throws -> Bool {
        true
    }
}

class AddHistoryUseCaseTests: XCTestCase {
    func testExecute() async throws {
        let useCase = AddHistoryUseCase(repository: AnyCommandRepository(wrapped: MockCommandRepository()))
        
        // Act
        let result = try await useCase.execute(with: "test")
        
        // Assert
        XCTAssertEqual(result, true)
    }
}
