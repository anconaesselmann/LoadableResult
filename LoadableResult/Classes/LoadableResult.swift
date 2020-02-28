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

    /// Every state can be remapped.
    /// map should be used when a states get combined or changed altogether.
    /// mapLoaded exists if you want to only map the loaded case, which is the more common case.
    ///
    /// Example:
    /// A server response returns a valid object that should actually be treated as an error case.
    public func map<E>(_ transform: @escaping (LoadableResult<T>) -> E) -> E {
        return transform(self)
    }

    /// The loaded state gets transformed to a new type.
    /// In case acces to each individual state is necessary use map.
    ///
    /// Example:
    /// - A server response returns a full object. We are only interested in in one property.
    /// - A server response returns a list of objects. We are only interested in the first element in the list
    public func mapLoaded<E>(_ transform: @escaping (T) -> E) -> LoadableResult<E> {
        switch self {
        case .inactive:
            return .inactive
        case .loading:
            return .loading
        case .loaded(let loaded):
            return .loaded(transform(loaded))
        case .error(let error):
            return .error(error)
        }
    }

    /// A network request might return an error that needs to be processed before we display it for the user
    public func mapError<ErrorType>(_ transform: @escaping (Error) -> ErrorType) -> Self where ErrorType: Error {
        switch self {
        case .inactive, .loading, .loaded:
            return self
        case .error(let error):
            return .error(transform(error))
        }
    }

    /// A server request returns an error case from which we might be able to recover before with local data.
    public func mapError(_ transform: @escaping (Error) -> T?) -> Self {
        switch self {
        case .inactive, .loading, .loaded:
            return self
        case .error(let error):
            if let recovered = transform(error) {
                return .loaded(recovered)
            } else {
                return self
            }
        }
    }

}

extension LoadableResult: Equatable where T: Equatable {
    /// Note: Error types are not compared to determine equality, only the fact that an error occured.
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
