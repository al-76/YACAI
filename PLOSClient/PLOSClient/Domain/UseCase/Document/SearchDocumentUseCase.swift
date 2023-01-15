//
//  SearchDocumentUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

final class SearchDocumentUseCase: UseCase {
    private let repository: DocumentsRepository
    
    init(repository: DocumentsRepository) {
        self.repository = repository
    }

    func callAsFunction(with word: String) -> AnyPublisher<[Document], Error> {
        repository.read(query: word)
    }
}
