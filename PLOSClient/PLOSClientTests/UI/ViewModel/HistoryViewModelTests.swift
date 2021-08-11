//
//  HistoryViewModelTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import RxCocoa
import RxSwift
import RxTest
import XCTest

@testable import PLOSClient

private let testError = "error"

private class MockAddHistoryUseCase: UseCase {
    func execute(with input: String) -> Observable<BoolResult> {
        if input == testError {
            return .just(.failure(TestError.someError))
        }
        return .just(.success(true))
    }
}

private class MockSearchHistoryUseCase: UseCase {
    func execute(with input: String) -> Observable<HistoryResult> {
        if input == testError {
            return .just(.failure(TestError.someError))
        }
        return .just(.success([History(id: input)]))
    }
}

class HistoryViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    var viewModel: HistoryViewModel!
    
    override func setUp() {
        viewModel = HistoryViewModel(searchHistoryUseCase: AnyUseCase(wrapped: MockSearchHistoryUseCase()),
                                     addHistoryUseCase: AnyUseCase(wrapped: MockAddHistoryUseCase()))
    }
    
    func testSearchHistory() {
        // Arrange
        let testQuery = "test"
        let inputText = scheduler.createHotObservable([
            .next(200, testQuery)
        ]).asDriver(onErrorJustReturn: "")
        let output = viewModel
            .transform(from: HistoryViewModel.Input(searchHistory: inputText,
                                                    addHistory: Signal.never()))
        let outputHistory = scheduler.createObserver([History].self)
        output.history
            .drive(outputHistory)
            .disposed(by: disposeBag)
        
        // Act
        scheduler.start()
        
        // Assert
        XCTAssertRecordedElements(outputHistory.events, [
            [History(id: testQuery)]
        ])
    }
    
    func testSearchHistoryError() {
        // Arrange
        let inputText = scheduler.createHotObservable([
            .next(200, testError)
        ]).asDriver(onErrorJustReturn: "")
        let output = viewModel
            .transform(from: HistoryViewModel.Input(searchHistory: inputText,
                                                    addHistory: Signal.never()))
        let outputHistory = scheduler.createObserver([History].self)
        let outputErrors = scheduler.createObserver(Error.self)
        disposeBag.insert {
            output.history.drive(outputHistory)
            output.errors.emit(to: outputErrors)
        }
        
        // Act
        scheduler.start()
        
        // Assert
        XCTAssertRecordedElements(outputErrors.events, [
            TestError.someError
        ])
    }
    
    func testAddHistory() {
        // Arrange
        let testQuery = "test"
        let inputSearchHistory = scheduler.createHotObservable([
            .next(200, testQuery)
        ]).asDriver(onErrorJustReturn: "")
        let inputAddHistory = scheduler.createHotObservable([
            .next(300, "addHistory")
        ]).asSignal(onErrorJustReturn: "")
        let output = viewModel
            .transform(from: HistoryViewModel.Input(searchHistory: inputSearchHistory,
                                                    addHistory: inputAddHistory))
        let outputHistory = scheduler.createObserver([History].self)
        output.history
            .drive(outputHistory)
            .disposed(by: disposeBag)
        
        // Act
        scheduler.start()
        
        // Assert
        XCTAssertRecordedElements(outputHistory.events, [
            [History(id: testQuery)],
            [History(id: testQuery)]
        ])
    }
    
    func testAddHistoryError() {
        // Arrange
        let inputSearchHistory = scheduler.createHotObservable([
            .next(200, "test")
        ]).asDriver(onErrorJustReturn: "")
        let inputAddHistory = scheduler.createHotObservable([
            .next(300, testError)
        ]).asSignal(onErrorJustReturn: "")
        let output = viewModel
            .transform(from: HistoryViewModel.Input(searchHistory: inputSearchHistory,
                                                    addHistory: inputAddHistory))
        let outputHistory = scheduler.createObserver([History].self)
        let outputErrors = scheduler.createObserver(Error.self)
        disposeBag.insert {
            output.history.drive(outputHistory)
            output.errors.emit(to: outputErrors)
        }
        
        // Act
        scheduler.start()
        
        // Assert
        XCTAssertRecordedElements(outputErrors.events, [
            TestError.someError
        ])
    }
}
