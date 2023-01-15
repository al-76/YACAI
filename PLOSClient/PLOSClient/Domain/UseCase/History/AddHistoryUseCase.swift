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
        repository.read()
            .flatMap { [weak self] in
                let item = History(id: value)
                guard let self,
                      !$0.contains(item) else {
                    return Just(false)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.repository.write(item: item)
            }
            .eraseToAnyPublisher()
    }
}
