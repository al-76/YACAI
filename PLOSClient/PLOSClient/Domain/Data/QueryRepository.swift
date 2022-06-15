//
//  QueryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation
import RxSwift

protocol QueryRepository {
    associatedtype QueryRepositoryType

    func read(query: String) -> Observable<QueryRepositoryType>
}

final class AnyQueryRepository<T>: QueryRepository {
    private let readObject: (String) -> Observable<T>

    init<TypeQueryRepository: QueryRepository>(wrapped: TypeQueryRepository)
        where TypeQueryRepository.QueryRepositoryType == T {
        readObject = wrapped.read
    }

    func read(query: String) -> Observable<T> {
        readObject(query)
    }
}
