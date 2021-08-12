//
//  SearchDocumentUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift

class SearchDocumentUseCase: UseCase {
    private let repository: AnyQueryRepository<[Document]>

    init(repository: AnyQueryRepository<[Document]>) {
        self.repository = repository
    }

    func execute(with word: String) -> Observable<[Document]> {
        return repository.read(query: word)
    }
}
