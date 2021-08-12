//
//  SearchDocumentUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import XCTest
import RxSwift
import RxTest

@testable import PLOSClient

private class MockQueryRepository: QueryRepository {
    func read(query: String) -> Observable<[Document]> {
        return Observable.just([Document(query)])
    }
}

class SearchDocumentUseCaseTests: XCTestCase {
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    
    func testExecute() {
        // Arrange
        let testQuery = "test"
        let output = scheduler.createObserver([Document].self)
        let useCase = SearchDocumentUseCase(repository: AnyQueryRepository(wrapped: MockQueryRepository()))
        useCase.execute(with: testQuery)
            .bind(to: output)
            .disposed(by: disposeBag)
        
        // Act
        scheduler.start()
        
        // Assert
        XCTAssertRecordedElements(output.events.dropLast(), [ [Document(testQuery)] ])
    }
}
