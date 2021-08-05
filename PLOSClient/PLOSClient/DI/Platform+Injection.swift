//
//  Platform+Injection.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Resolver

extension Resolver {
    public static func registerPlatform() {
        register { DefaultNetwork() as Network }
        register { DefaultStorage() as Storage }
    }
}
