//
//  SearchHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift

class SearchHistoryUseCase: UseCase {
    private let repository: AnyQueryRepository<[History]>
    
    init(repository: AnyQueryRepository<[History]>) {
        self.repository = repository
    }
    
    func execute(with value: String) -> Observable<[History]> {
        repository.read(query: value)
            .map { $0.reversed() }
    }
}
