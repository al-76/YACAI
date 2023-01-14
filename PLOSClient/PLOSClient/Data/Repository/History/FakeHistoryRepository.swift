//
//  FakeHistoryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

#if DEBUG

import Foundation
import Combine

final class FakeHistoryRepository: HistoryRepository {
    var readAnswer = Answer.successAnswer([History].stub)
    var writeAnswer = Answer.successAnswer(true)

    func read() -> AnyPublisher<[History], Error> {
        readAnswer
    }

    func write(item: History) -> AnyPublisher<Bool, Error> {
        writeAnswer
    }
}

#endif
