//
//  UseCase.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 28.07.2021.
//

import Combine
import Foundation

protocol UseCase<Input, Output> {
    associatedtype Input
    associatedtype Output

    func callAsFunction(with input: Input) -> AnyPublisher<Output, Error>
}
