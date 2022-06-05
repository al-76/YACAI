//
//  Mapper.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 30.07.2021.
//

import Foundation

protocol Mapper {
    associatedtype Input
    associatedtype Output
    
    func map(input: Input) -> Output
}

struct AnyMapper<Input, Output>: Mapper {
    private let mapObject: (_ input: Input) -> Output

    init<TypeMapper: Mapper>(wrapped: TypeMapper)
        where TypeMapper.Input == Input, TypeMapper.Output == Output {
        mapObject = wrapped.map
    }

    func map(input: Input) -> Output {
        mapObject(input)
    }
}
