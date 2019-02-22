struct Graph: Equatable {
    let vertices: [Vertex]
}

extension Graph {
    var vacants: [Vertex] {
        return vertices
            .filter {
                guard case .vacant = $0 else {
                    return false
                }

                return true
            }
    }
}

extension Graph {
    init(board: Board) {
        self.vertices = Array(0..<board.size.amount)
            .map { index -> Vertex in
                board.pins
                    .filter { $0.pairs.map({ $0.rawValue }).contains(index) }
                    .map { .pin(id: $0.id.rawValue, index: index) }
                    .first ?? .vacant(index: index)
            }
    }
}
