//
//  UIContainer.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 04.08.2021.
//

import Factory

final class UIContainer: SharedContainer {
    static let documentsViewModel = Factory {
        DocumentsViewModel(searchHistoryUseCase: DomainContainer.searchHistoryUseCase(),
                           addHistoryUseCase: DomainContainer.addHistoryUseCase())
    }

    static let documentListViewModel = Factory {
        DocumentListViewModel(searchUseCase: DomainContainer.searchDocumentUseCase())
    }
}
