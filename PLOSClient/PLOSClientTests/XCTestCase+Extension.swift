//
//  XCTestCase+Extension.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 09.08.2021.
//

import RxSwift
import RxTest
import XCTest

public func XCTAssertRecordedElements(_ stream: [Recorded<Event<Error>>],
                                      _ errors: [Error],
                                      file: StaticString = #file,
                                      line: UInt = #line) {
    if stream.count < errors.count {
        XCTFail("\(stream) doesn't equal to \(errors)!",
                file: file, line: line)
        return
    }
    
    for (index, element) in errors.enumerated() {
        let streamError = stream[index].value.element!
        if type(of: streamError) != type(of: element) {
            XCTFail("\(streamError) doesn't equal to \(element)!",
                    file: file, line: line)
            return
        }
    }
}

public func XCTAssertRecordedElements<Type>(_ stream: [Recorded<Event<Type>>],
                                      _ errors: [Error],
                                      file: StaticString = #file,
                                      line: UInt = #line) {
    if stream.count < errors.count {
        XCTFail("\(stream) doesn't equal to \(errors)!",
                file: file, line: line)
        return
    }
    
    for (index, element) in errors.enumerated() {
        let streamError = stream[index].value.error!
        if type(of: streamError) != type(of: element) {
            XCTFail("\(streamError) doesn't equal to \(element)!",
                    file: file, line: line)
            return
        }
    }
}

public func XCTAssertRecordedElements<Type>(_ stream: [Recorded<Event<Result<Type, Error>>>],
                                      _ items: [Result<Type, Error>],
                                      file: StaticString = #file,
                                      line: UInt = #line) where Type: Equatable {
    if stream.count < items.count {
        XCTFail("\(stream) doesn't equal to \(items)!",
                file: file, line: line)
        return
    }
    
    for (index, element) in items.enumerated() {
        let streamItem = stream[index].value.element!
        switch (streamItem, element) {
        case let (.success(item1), .success(item2)):
            if (item1 != item2) {
                XCTFail("\(item1) doesn't equal to \(item2)!",
                        file: file, line: line)
                return
            }
            break
        case let (.failure(error1), .failure(error2)):
            if type(of: error1) != type(of: error2) {
                XCTFail("\(error1) doesn't equal to \(error2)!",
                        file: file, line: line)
                return
            }
            break
        default:
            XCTFail("\(streamItem) doesn't equal to \(element)!",
                    file: file, line: line)
            return
        }
    }
}
