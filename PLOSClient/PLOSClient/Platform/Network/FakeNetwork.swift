//
//  FakeNetwork.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 15.01.2023.
//

#if DEBUG

import Combine
import Foundation

final class FakeNetwork: Network {
    var answer = Answer.success(Data())

    func request(url: URL) -> AnyPublisher<Data, Error> {
        answer
    }
}

#endif
