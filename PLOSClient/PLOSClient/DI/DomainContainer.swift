//
//  DomainContainer.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Factory

final class DomainContainer: SharedContainer {
    static let searchHistoryUseCase = Factory {
        SearchHistoryUseCase(repository: DataContainer.historyRepository())
    }

    static let addHistoryUseCase = Factory {
        AddHistoryUseCase(repository: DataContainer.historyRepository())
    }

    static let searchDocumentUseCase = Factory {
        SearchDocumentUseCase(repository: DataContainer.documentsRepository())
    }
}
