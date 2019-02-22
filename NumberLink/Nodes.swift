extension Array where Element == [Int: Node] {
    func unique() -> [Element] {
        var array: [Element] = []
        var matesArray: [Element] = []

        for node in self where !matesArray.contains(node.mates()) {
            array.append(node)
            matesArray.append(node.mates())
        }

        return array
    }
}

extension Dictionary where Key == Int, Value == Node {
    func mate(index: Int) -> Int? {
        return findNodes(by: index)
            .map { $0.mate / NodeType.division }
            .first
    }

    func mates() -> [Int: Node] {
        return self.filter { $0.value != .inside }
    }

    func occupied(index: Int) -> Int {
        return findNodes(by: index).count
    }

    func subIndex(base index: Int, type: NodeType) -> Int {
        return index * NodeType.division + type.rawValue
    }

    func findNode(base index: Int, type: NodeType) -> Node? {
        return self[self.subIndex(base: index, type: type)]
    }

    func findNodes(by index: Int) -> [Node] {
        return NodeType.allCases
            .compactMap { self[self.subIndex(base: index, type: $0)] }
    }
}
