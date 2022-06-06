//
//  SearchDocumentUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

class SearchDocumentUseCase: UseCase {
    private let repository: AnyQueryRepository<Document>
    
    init(repository: AnyQueryRepository<Document>) {
        self.repository = repository
    }

    func execute(with word: String) -> AnyPublisher<[Document], Error> {
        repository.read(query: word)
    }
}
