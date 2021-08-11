//
//  AddHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

class AddHistoryUseCase: UseCase {
    private let repository: AnyCommandRepository<History>
    
    init(repository: AnyCommandRepository<History>) {
        self.repository = repository
    }
        
    func execute(with value: String) -> AnyPublisher<Bool, Error> {
        return repository.add(item: History(id: value))
    }
}
