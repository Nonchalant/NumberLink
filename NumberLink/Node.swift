enum Node: Equatable {
    case end(mate: Int)
    case inside
}

extension Node {
    var mate: Int {
        switch self {
        case let .end(mate):
            return mate
        case .inside:
            return -1
        }
    }
}
