//
//  DocumentsViewModelTests.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import XCTest
import RxSwift
import RxTest

@testable import PLOSClient

private let testError = "error"

private class MockSearchUseCase: UseCase {
    func execute(with input: String) -> Observable<[Document]> {
        if input == testError {
            return .error(TestError.someError)
        }
        return .just([Document(input)])
    }
}

class DocumentsViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    var viewModel: DocumentsViewModel!
    
    override func setUp() {
        viewModel = DocumentsViewModel(searchUseCase: AnyUseCase(wrapped: MockSearchUseCase()))
    }
    
    func testSearchDocuments() {
        // Arrange
        let testQuery = "test"
        let inputText = scheduler.createHotObservable([
            .next(200, testQuery)
        ]).asDriver(onErrorJustReturn: "")
        let output = viewModel.transform(from: DocumentsViewModel.Input(searchDocument: inputText))
        let outputDocuments = scheduler.createObserver([Document].self)
        output.documents
            .drive(outputDocuments)
            .disposed(by: disposeBag)
        
        // Act
        scheduler.start()
        
        // Assert
        XCTAssertRecordedElements(outputDocuments.events, [ [Document(testQuery)] ])
    }
    
    func testSearchDocumentsError() {
        // Arrange
        let inputText = scheduler.createHotObservable([
            .next(200, testError)
        ]).asDriver(onErrorJustReturn: "")
        let output = viewModel.transform(from: DocumentsViewModel.Input(searchDocument: inputText))
        let outputDocuments = scheduler.createObserver([Document].self)
        let outputErrors = scheduler.createObserver(Error.self)
        disposeBag.insert {
            output.documents.drive(outputDocuments)
            output.errors.emit(to: outputErrors)
        }
        
        // Act
        scheduler.start()
        
        // Assert
        XCTAssertRecordedElements(outputErrors.events, [ TestError.someError ])
    }
}
