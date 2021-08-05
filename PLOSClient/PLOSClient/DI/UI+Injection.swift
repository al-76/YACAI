//
//  UI+Injection.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 04.08.2021.
//

import Resolver

extension Resolver {
    public static func registerUI() {
        register { SearchViewModel(searchHistoryUseCase: resolve(),
                                   addHistoryUseCase: resolve()) }
            .scope(.shared)
        register { SearchResultViewModel(searchUseCase: resolve()) }
            .scope(.shared)
    }
}
