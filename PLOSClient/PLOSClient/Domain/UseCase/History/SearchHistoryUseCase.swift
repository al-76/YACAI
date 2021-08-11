//
//  SearchHistoryUseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift

class SearchHistoryUseCase: UseCase {
    private let repository: AnyQueryRepository<HistoryResult>
    
    init(repository: AnyQueryRepository<HistoryResult>) {
        self.repository = repository
    }
    
    func execute(with value: String) -> Observable<HistoryResult> {
        return repository.read(query: value)
            .map { $0.flatMap { $0.reversed() }}
    }
}
