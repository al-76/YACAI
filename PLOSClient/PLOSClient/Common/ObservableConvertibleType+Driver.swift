//
//  ObservableConvertibleType+Driver.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 12.08.2021.
//

import RxSwift
import RxCocoa

extension ObservableConvertibleType {
    public func asDriver(errors: PublishRelay<Error>) -> Driver<Element> {
        asDriver { error in
            errors.accept(error)
            return Driver.never()
        }
    }
}
