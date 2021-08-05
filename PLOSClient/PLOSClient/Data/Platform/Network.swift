//
//  Network.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 03.08.2021.
//

import Foundation

protocol Network {
    typealias Completion = (Result<Data, Error>) -> Void
    
    func get(with url: String, completion: @escaping Completion) -> Void
}
