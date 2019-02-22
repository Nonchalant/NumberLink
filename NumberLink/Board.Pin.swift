extension Board {
    public struct Pin {
        public let id: Id
        public let pairs: [Position]
    }
}

extension Board.Pin {
    public struct Id {
        public let rawValue: Int
    }
}

extension Board.Pin {
    init(id: Int, pairs: [Int]) {
        self.id = Id(rawValue: id)
        self.pairs = pairs.map(Board.Position.init(rawValue:))
    }
}
