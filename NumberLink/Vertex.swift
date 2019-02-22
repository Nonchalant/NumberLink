enum Vertex: Equatable {
    case pin(id: Int, index: Int)
    case vacant(index: Int)
}

extension Vertex {
    var index: Int {
        switch self {
        case let .pin(_, index):
            return index
        case let .vacant(index):
            return index
        }
    }

    var capacity: Int {
        switch self {
        case .pin:
            return 1
        case .vacant:
            return 2
        }
    }
}
