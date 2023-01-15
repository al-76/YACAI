//
//  FakeSearchHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

#if DEBUG

import Combine
import Foundation

final class FakeSearchHistoryUseCase: UseCase {
    var answer = Answer.success([History].stub)

    func execute(with query: String) -> AnyPublisher<[History], Error> {
        answer
    }
}

#endif
