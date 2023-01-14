//
//  DataContainer.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Factory

final class DataContainer: SharedContainer {
    static let historyRepository = Factory {
        DefaultHistoryRepository(storage: PlatformContainer.storage())
    }

    static let documentsRepository = Factory {
        DefaultDocumentsRepository(network: PlatformContainer.network(),
                                   mapper: AnyMapper(wrapped: DocumentsMapper()))
    }
}
