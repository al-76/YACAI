//
//  SearchHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

final class SearchHistoryUseCase: UseCase {
    private let repository: HistoryRepository
    
    init(repository: HistoryRepository) {
        self.repository = repository
    }
    
    func execute(with value: String) -> AnyPublisher<[History], Error> {
        repository.read(query: value)
            .map { $0.reversed() }
            .eraseToAnyPublisher()
    }
}
