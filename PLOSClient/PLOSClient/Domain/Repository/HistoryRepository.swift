//
//  QueryRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine
import Foundation

protocol HistoryRepository {
    func read() -> AnyPublisher<[History], Error>
    func write(item: History) -> AnyPublisher<Bool, Error>
}
