//
//  CommandRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation
import RxSwift

protocol CommandRepository {
    associatedtype CommandRepositoryType

    func add(item: CommandRepositoryType) -> Observable<Bool>
}

final class AnyCommandRepository<T>: CommandRepository {
    private let addObject: (T) -> Observable<Bool>

    init<TypeUseCase: CommandRepository>(wrapped: TypeUseCase)
        where TypeUseCase.CommandRepositoryType == T {
        addObject = wrapped.add
    }

    func add(item: T) -> Observable<Bool> {
        addObject(item)
    }
}

