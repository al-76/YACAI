//
//  DataContainer.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Factory

final class DataContainer: SharedContainer {
    static let historyRepository = Factory<HistoryRepository> {
        DefaultHistoryRepository(storage: PlatformContainer.storage())
    }

    static let documentsRepository = Factory<DocumentsRepository> {
        DefaultDocumentsRepository(network: PlatformContainer.network(),
                                   mapper: AnyMapper(wrapped: DocumentsMapper()))
    }
}
