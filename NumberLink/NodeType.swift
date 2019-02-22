enum NodeType: Int, CaseIterable {
    case left   = 0
    case top    = 1
    case right  = 2
    case bottom = 3

    static let division = NodeType.allCases.count
}
