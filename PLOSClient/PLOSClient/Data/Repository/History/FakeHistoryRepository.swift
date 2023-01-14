//
//  FakeHistoryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

import Foundation
import Combine

final class FakeHistoryRepository: HistoryRepository {
    var readAnswer = Just([History].stub)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()

    var writeAnswer = Just(true)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()

    func read() -> AnyPublisher<[History], Error> {
        readAnswer
    }

    func write(item: History) -> AnyPublisher<Bool, Error> {
        writeAnswer
    }
}
