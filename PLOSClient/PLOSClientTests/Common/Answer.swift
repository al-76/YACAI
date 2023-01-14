//
//  Answer.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

import Combine

enum Answer {
    static func successAnswer<T>(_ data: T) -> AnyPublisher<T, Error> {
        Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    static func failAnswer<T>(_ error: Error = TestError.someError) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }

    static func failAnswer<T>(_ error: Error, _ type: T.Type) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }

    static func noAnswer<T>() -> AnyPublisher<T, Error> {
        Empty<T, Error>()
            .eraseToAnyPublisher()
    }
}
