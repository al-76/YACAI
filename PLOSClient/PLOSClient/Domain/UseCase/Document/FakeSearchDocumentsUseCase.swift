//
//  FakeSearchDocumentsUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

#if DEBUG

import Combine
import Foundation

final class FakeSearchDocumentUseCase: UseCase {
    var answer = Just([Document].stub)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()

    func execute(with word: String) -> AnyPublisher<[Document], Error> {
        answer
    }
}

#endif
