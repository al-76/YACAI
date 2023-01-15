//
//  PlatformContainer.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Factory

final class PlatformContainer: SharedContainer {
    static let network = Factory {
        DefaultNetwork()
    }

    static let historyStorage = Factory {
        DefaultStorage<History>(name: "history")
    }
}
