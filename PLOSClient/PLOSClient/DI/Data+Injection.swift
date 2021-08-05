//
//  Data+Injection.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Resolver

extension Resolver {
    public static func registerData() {
        registerHistoryRepository()
        registerDocumentsRepository()
    }
    
    private static func registerHistoryRepository() {
        register { HistoryRepository(storage: resolve()) }
            .scope(.application)
        register { AnyQueryRepository(wrapped: resolve(HistoryRepository.self)) }
        register { AnyCommandRepository(wrapped: resolve(HistoryRepository.self)) }
    }
    
    private static func registerDocumentsRepository() {
        register { AnyMapper(wrapped: DocumentsMapper()) }
        register { AnyQueryRepository(wrapped:
                                        DocumentsRepository(network: resolve(),
                                                            mapper: resolve())) }
    }
}
