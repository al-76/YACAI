//
//  SearchDocumentUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift

class SearchDocumentUseCase: UseCase {
    private let repository: AnyQueryRepository<DocumentResult>

    init(repository: AnyQueryRepository<DocumentResult>) {
        self.repository = repository
    }

    func execute(with word: String) -> Observable<DocumentResult> {
        return repository.read(query: word)
    }
}
