//
//  SearchHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

struct SearchHistoryUseCase: UseCase {
    private let repository: AnyQueryRepository<History>
    
    init(repository: AnyQueryRepository<History>) {
        self.repository = repository
    }
    
    func execute(with value: String) -> AnyPublisher<[History], Error> {
        repository.read(query: value)
            .map { $0.reversed() }
            .eraseToAnyPublisher()
    }
}
