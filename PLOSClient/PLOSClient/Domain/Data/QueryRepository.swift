//
//  QueryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation

protocol QueryRepository {
    associatedtype QueryRepositoryType

    func read(query: String) async throws -> QueryRepositoryType
}

class AnyQueryRepository<T>: QueryRepository {
    private let readObject: (String) async throws -> T

    init<TypeQueryRepository: QueryRepository>(wrapped: TypeQueryRepository)
        where TypeQueryRepository.QueryRepositoryType == T {
        readObject = wrapped.read
    }

    func read(query: String) async throws -> T {
        try await readObject(query)
    }
}
