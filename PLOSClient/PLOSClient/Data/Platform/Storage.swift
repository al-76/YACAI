//
//  Storage.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Combine
import Foundation

protocol Storage<T> {
    associatedtype T: Codable

    func load() -> AnyPublisher<[T], Error>
    func save(item: T) -> AnyPublisher<Bool, Error>
}
