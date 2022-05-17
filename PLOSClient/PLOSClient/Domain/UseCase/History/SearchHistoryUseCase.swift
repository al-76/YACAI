//
//  SearchHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

class SearchHistoryUseCase: UseCase {
    private let repository: AnyQueryRepository<[History]>
    
    init(repository: AnyQueryRepository<[History]>) {
        self.repository = repository
    }
    
    func execute(with value: String) async throws -> [History] {
        try await repository.read(query: value)
            .reversed()
    }
}
