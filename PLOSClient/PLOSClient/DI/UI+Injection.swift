//
//  UI+Injection.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 04.08.2021.
//

import Resolver

extension Resolver {
    public static func registerUI() {
        register { DocumentsViewModel(searchHistoryUseCase: resolve(),
                                      addHistoryUseCase: resolve()) }
            .scope(.shared)
        register { DocumentListViewModel(searchUseCase: resolve()) }
            .scope(.shared)
    }
}
