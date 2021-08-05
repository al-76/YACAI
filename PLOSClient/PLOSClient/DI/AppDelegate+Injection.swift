//
//  AppDelegate+Injection.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 01.08.2021.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerPlatform()
        registerData()
        registerDomain()
        registerUI()
    }
}
