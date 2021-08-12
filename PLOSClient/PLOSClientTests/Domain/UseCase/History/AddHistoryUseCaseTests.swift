//
//  AddHistoryUseCaseTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import XCTest
import RxSwift
import RxTest

@testable import PLOSClient

private class MockCommandRepository: CommandRepository {
    func add(item: History) -> Observable<Bool> {
        return Observable.just(true)
    }
}

class AddHistoryUseCaseTests: XCTestCase {
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    
    func testExecute() {
        let output = scheduler.createObserver(Bool.self)
        let useCase = AddHistoryUseCase(repository: AnyCommandRepository(wrapped: MockCommandRepository()))
        useCase.execute(with: "test")
            .bind(to: output)
            .disposed(by: disposeBag)
        
        // Act
        scheduler.start()
        
        // Assert
        XCTAssertRecordedElements(output.events.dropLast(), [ true ])
    }
}
