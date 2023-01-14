//
//  DocumentsRepository.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Combine

protocol DocumentsRepository {
    func read(query: String) -> AnyPublisher<[Document], Error>
}

