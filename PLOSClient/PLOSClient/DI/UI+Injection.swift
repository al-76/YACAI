//
//  UI+Injection.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 04.08.2021.
//

import Resolver

extension Resolver {
    public static func registerUI() {
        register { HistoryViewModel(searchHistoryUseCase: resolve(),
                                   addHistoryUseCase: resolve()) }
            .scope(.shared)
        register { DocumentsViewModel(searchUseCase: resolve()) }
            .scope(.shared)
    }
}
