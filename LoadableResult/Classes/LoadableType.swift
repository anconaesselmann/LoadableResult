//  Created by Axel Ancona Esselmann on 2/5/20.
//

import Foundation

public protocol LoadableType {
    associatedtype LoadedType
    var loaded: LoadedType? { get }
}

extension LoadableResult: LoadableType {
    public var loaded: T? {
        switch self {
        case .inactive, .loading, .error: return nil
        case .loaded(let loaded): return loaded
        }
    }
}
