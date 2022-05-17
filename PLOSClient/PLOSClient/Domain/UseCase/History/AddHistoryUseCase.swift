//
//  AddHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

class AddHistoryUseCase: UseCase {
    private let repository: AnyCommandRepository<History>
    
    init(repository: AnyCommandRepository<History>) {
        self.repository = repository
    }
        
    func execute(with value: String) async throws -> Bool {
        try await repository.add(item: History(id: value))
    }
}
