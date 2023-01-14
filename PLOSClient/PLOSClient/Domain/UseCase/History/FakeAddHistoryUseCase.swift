//
//  FakeAddHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

#if DEBUG

import Combine
import Foundation

final class FakeAddHistoryUseCase: UseCase {
    private var answer = Answer.successAnswer(true)

    func execute(with value: String) -> AnyPublisher<Bool, Error> {
        answer
    }
}

#endif
