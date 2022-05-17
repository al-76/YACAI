//
//  SearchDocumentUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

class SearchDocumentUseCase: UseCase {
    private let repository: AnyQueryRepository<[Document]>

    init(repository: AnyQueryRepository<[Document]>) {
        self.repository = repository
    }

    func execute(with word: String) async throws -> [Document] {
        try await repository.read(query: word)
    }
}
