//
//  CommandRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation

protocol CommandRepository {
    associatedtype CommandRepositoryType

    func add(item: CommandRepositoryType) async throws -> Bool
}

final class AnyCommandRepository<T>: CommandRepository {
    private let addObject: (T) async throws -> Bool

    init<TypeUseCase: CommandRepository>(wrapped: TypeUseCase)
        where TypeUseCase.CommandRepositoryType == T {
        addObject = wrapped.add
    }

    func add(item: T) async throws -> Bool {
        try await addObject(item)
    }
}

