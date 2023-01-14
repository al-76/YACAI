//
//  FakeDocumentsRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 14.01.2023.
//

import Combine
import Foundation

final class FakeDocumentsRepository: DocumentsRepository {
    var readAnswer = Just([Document].stub)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()

    func read(query: String) -> AnyPublisher<[Document], Error> {
        readAnswer
    }
}
