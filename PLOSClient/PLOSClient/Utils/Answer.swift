//
//  Answer.swift
//  PLOSClientTests
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

#if DEBUG

import Combine

enum Answer {
    static func success<T>(_ data: T) -> AnyPublisher<T, Error> {
        Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    static func fail<T>(_ error: Error = TestError.someError) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }

    static func fail<T>(_ error: Error, _ type: T.Type) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }

    static func nothing<T>() -> AnyPublisher<T, Error> {
        Empty<T, Error>()
            .eraseToAnyPublisher()
    }
}

#endif
