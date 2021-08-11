//
//  SearchHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

class SearchHistoryUseCase: UseCase {
    private let repository: AnyQueryRepository<History>
    
    init(repository: AnyQueryRepository<History>) {
        self.repository = repository
    }
    
    func execute(with value: String) -> AnyPublisher<[History], Error> {
        return repository.read(query: value)
            .map { $0.reversed() }
            .eraseToAnyPublisher()
    }
}
