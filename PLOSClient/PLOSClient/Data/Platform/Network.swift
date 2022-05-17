//
//  Network.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Foundation

protocol Network {
    func get(with url: String) async throws -> Data
}
