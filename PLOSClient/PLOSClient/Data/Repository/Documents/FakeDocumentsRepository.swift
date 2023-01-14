//
//  FakeDocumentsRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

#if DEBUG

import Combine
import Foundation

final class FakeDocumentsRepository: DocumentsRepository {
    var readAnswer = Answer.successAnswer([Document].stub)

    func read(query: String) -> AnyPublisher<[Document], Error> {
        readAnswer
    }
}

#endif
