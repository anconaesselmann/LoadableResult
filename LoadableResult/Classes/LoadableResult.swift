//  Created by Axel Ancona Esselmann on 1/23/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public enum LoadableResult<T> {
    case inactive
    case loading
    case loaded(T)
    case error(Error)

    var hasLoaded: Bool {
        if case .loaded = self {
            return true
        } else {
            return false
        }
    }

    // TODO: Very basic implementation of map. Does not handle exceptions.
    public func map<E>(_ transform: @escaping (LoadableResult<T>) -> E) -> E {
        return transform(self)
    }

}

/// Error types are not compared to determine equality, only the fact that an error occured.
extension LoadableResult: Equatable where T: Equatable {
    public static func == (lhs: LoadableResult<T>, rhs: LoadableResult<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.error, .error): return true
        case (.loaded(let lhe), .loaded(let rhe)): return lhe == rhe
        default: return false
        }
    }
}

extension LoadableResult: TypelessRequestStatusConvertable {
    public var typeless: TypelessRequestStatus {
        switch self {
        case .inactive: return .inProgress
        case .loading: return .inProgress
        case .loaded: return .success
        case .error(let error): return .error(error)
        }
    }
}

public protocol TypelessRequestStatusConvertable {
    var typeless: TypelessRequestStatus { get }
}
