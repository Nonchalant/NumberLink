extension Board {
    public struct Size {
        public let width: Int
        public let height: Int
    }
}

extension Board.Size {
    var amount: Int {
        return width * height
    }
}
