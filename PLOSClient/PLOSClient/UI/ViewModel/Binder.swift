//
//  Binder.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 13.05.2022.
//

import Foundation

final class Binder<T> {
    typealias OnResult = (T) -> Void
    
    private var onResult: OnResult?
    
    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onResult?(self.value)
            }
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ onResult: @escaping OnResult) {
        self.onResult = onResult
    }
}

class BinderOpt<T> {
    typealias OnResult = (T?) -> Void
    
    private var onResult: OnResult?
    
    var value: T? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onResult?(self.value)
            }
        }
    }
    
    init(value: T?) {
        self.value = value
    }
    
    func bind(_ onResult: @escaping OnResult) {
        self.onResult = onResult
    }
}
