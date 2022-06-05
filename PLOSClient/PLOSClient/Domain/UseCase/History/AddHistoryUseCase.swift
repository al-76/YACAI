//
//  AddHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

struct AddHistoryUseCase: UseCase {
    private let repository: AnyCommandRepository<History>
    
    init(repository: AnyCommandRepository<History>) {
        self.repository = repository
    }
        
    func execute(with value: String) -> AnyPublisher<Bool, Error> {
        repository.add(item: History(id: value))
    }
}
