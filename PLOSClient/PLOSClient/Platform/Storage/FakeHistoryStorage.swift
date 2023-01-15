//
//  FakeHistoryStorage.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 15.01.2023.
//

#if DEBUG

import Combine
import Foundation

final class FakeHistoryStorage: Storage {
    var saveAnswer = Answer.success(true)
    var loadAnswer = Answer.success([History].stub)

    func save(item: History) -> AnyPublisher<Bool, Error> {
        saveAnswer
    }

    func load() -> AnyPublisher<[History], Error> {
        loadAnswer
    }
}

#endif
