//
//  Domain+Injection.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Resolver

extension Resolver {
    public static func registerDomain() {
        register { AnyUseCase(wrapped:
                                SearchHistoryUseCase(repository: resolve())) }
        register { AnyUseCase(wrapped:
                                AddHistoryUseCase(repository: resolve())) }
        register { AnyUseCase(wrapped:
                                SearchDocumentUseCase(repository: resolve())) }
    }
}
