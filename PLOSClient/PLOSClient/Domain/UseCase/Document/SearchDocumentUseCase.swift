//
//  SearchDocumentUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

class SearchDocumentUseCase: UseCase {
    typealias Input = String
    typealias Output = [Document]
    
    private let repository: AnyQueryRepository<Document>
    
    init(repository: AnyQueryRepository<Document>) {
        self.repository = repository
    }

    func execute(with word: String) -> AnyPublisher<[Document], Error> {
        return repository.read(query: word)
    }
}
