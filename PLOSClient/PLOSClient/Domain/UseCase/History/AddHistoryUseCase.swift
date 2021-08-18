//
//  AddHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift

class AddHistoryUseCase: UseCase {
    private let repository: AnyCommandRepository<History>
    
    init(repository: AnyCommandRepository<History>) {
        self.repository = repository
    }
        
    func execute(with value: String) -> Observable<Bool> {
        repository.add(item: History(id: value))
    }
}
