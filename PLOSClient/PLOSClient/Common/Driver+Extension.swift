//
//  Driver+Extension.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    func handleResult<Success, Error>(from: @escaping (Element) -> (Success?, Error?),
                                      errors: PublishRelay<Error>) -> SharedSequence<SharingStrategy, Success> {
        self.map { element in
            let (result, error) = from(element)
            if let error = error {
                errors.accept(error)
            }
            return result
        }
        .compactMap { $0 }
    }
}
