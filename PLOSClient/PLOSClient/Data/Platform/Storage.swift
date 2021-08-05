//
//  Storage.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Foundation

protocol Storage {
    func get<T: Codable>(id: String, defaultObject: T) -> T
    func save<T: Codable>(id: String, object: T) throws
    func clear(id: String) throws
}
