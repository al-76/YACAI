//
//  Result+Extension.swift
//  PLOSClient
//
//  Created by Vyacheslav Konopkin on 06.08.2021.
//

extension Result {
    func getState() -> (Success?, Failure?) {
        switch self {
        case let .success(result):
            return (result, nil)
        case let .failure(error):
            return (nil, error)
        }
    }
}

extension Result {
    func isFailure() -> Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }
}

extension Result {
    func flatMap<U>(_ transform: (Success) -> U) -> Result<U, Failure> {
        switch self {
        case let .success(value):
            return .success(transform(value))
        case let .failure(error):
            return .failure(error)
        }
    }
}

typealias BoolResult = Result<Bool, Error>

