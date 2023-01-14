//
//  AddHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

final class AddHistoryUseCase: UseCase {
    private let repository: HistoryRepository
    
    init(repository: HistoryRepository) {
        self.repository = repository
    }
        
    func execute(with value: String) -> AnyPublisher<Bool, Error> {
        repository.write(item: History(id: value))
    }
}
