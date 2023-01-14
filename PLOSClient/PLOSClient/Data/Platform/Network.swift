//
//  Network.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Combine
import Foundation

protocol Network {
    func request(url: URL) -> AnyPublisher<Data, Error>
}
