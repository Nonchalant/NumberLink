import Foundation


public struct NumberLinkGenerator {
    let options: Options

    /// Initializer
    ///
    /// - Parameter options:
    ///   - limit: trial limit
    ///   - isVerbose: print logs
    public init(options: Options = .default) {
        self.options = options
    }

    /// Generate Solvable NumberLink
    ///
    /// - Parameters:
    ///   - width: board width of numberLink
    ///   - height: board height of numberLink
    ///   - amountOfPins: amount of pins on board
    /// - Returns: Solvable NumberLink
    /// - Throws: Amound of pins is over than board size
    public func generate(width: Int, height: Int, amountOfPins: Int) throws -> Board? {
        let startUp = Date()

        for trial in 0..<options.limit {
            let board = try makeBoard(width: width, height: height, amountOfPins: amountOfPins)

            if options.isVerbose {
                print("\(trial): \(Date().timeIntervalSince(startUp))")
            }

            if checkValidBoard(with: board) {
                return board
            }
        }

        /// - NOTE: Not Found Valid NumberLink in limit
        return nil
    }

    func makeBoard(width: Int, height: Int, amountOfPins: Int) throws -> Board {
        var pins: [Board.Pin] = []
        var positions = (0...(width * height - 1)).shuffled()

        for id in 1...amountOfPins {
            guard let position1 = positions.popLast(), let position2 = positions.popLast() else {
                throw NumberLinkGenerator.Error.overPin
            }

            pins.append(Board.Pin(id: id, pairs: [position1, position2]))
        }

        return Board(size: Board.Size(width: width, height: height), pins: pins)
    }

    func checkValidBoard(with board: Board) -> Bool {
        let graph = Graph(board: board)

        var nodes: [[Int: Node]] = [[:]]

        for (index, vertex) in graph.vacants.enumerated() {
            var leaves: [[Int: Node]] = []

            for node in nodes {
                leaves += updateNodes(nodes: node, vertex: vertex, graph: graph, size: board.size)
            }

            nodes = leaves.unique()

            if options.isVerbose {
                print(" \(index + 1)/\(graph.vacants.count) (\(nodes.count))")
            }
        }

        let pinsCount = board.pins.map({ $0.pairs.count }).reduce(0, +)

        /// Disjoint pin
        for node in nodes where node.values.filter({ $0 != .inside }).count == pinsCount {
            var isConnectPins = true

            for pin in board.pins {
                let end1 = pin.pairs[0]
                let end2 = pin.pairs[1]

                guard let mateOfEnd1 = node.mate(index: end1.rawValue), let mateOfEnd2 = node.mate(index: end2.rawValue) else {
                    isConnectPins = false
                    break
                }

                guard mateOfEnd1 == end2.rawValue, mateOfEnd2 == end1.rawValue else {
                    isConnectPins = false
                    break
                }
            }

            if isConnectPins {
                return true
            }
        }

        return false
    }

    func updateNodes(nodes: [Int: Node], vertex: Vertex, graph: Graph, size: Board.Size) -> [[Int: Node]] {
        var edges = Edge.allCases

        let left   = vertex.index - 1
        let top    = vertex.index - size.width
        let right  = vertex.index + 1
        let bottom = vertex.index + size.width

        /// Left capacity
        if vertex.index % size.width == 0 {
            edges = edges.filter { ![.horizontal, .topAndLeft, .bottomAndLeft].contains($0) }
        }

        /// Top capacity
        if vertex.index / size.width == 0 {
            edges = edges.filter { ![.vertical, .topAndLeft, .topAndRight].contains($0) }
        }

        /// Right capacity
        if (vertex.index + 1) % size.width == 0 || graph.vertices[right].capacity == nodes.occupied(index: right) {
            edges = edges.filter { ![.horizontal, .topAndRight, .bottomAndRight].contains($0) }
        }

        /// Bottom capacity
        if vertex.index / size.width == size.height - 1 || graph.vertices[bottom].capacity == nodes.occupied(index: bottom) {
            edges = edges.filter { ![.vertical, .bottomAndLeft, .bottomAndRight].contains($0) }
        }

        /// Left on current node
        if nodes.findNode(base: vertex.index, type: .left) != nil {
            edges = edges.filter { [.horizontal, .topAndLeft, .bottomAndLeft].contains($0) }
        } else if vertex.index % size.width != 0 && graph.vertices[left].capacity == nodes.occupied(index: left) {
            edges = edges.filter { ![.horizontal, .topAndLeft, .bottomAndLeft].contains($0) }
        }

        /// Top on current node
        if nodes.findNode(base: vertex.index, type: .top) != nil {
            edges = edges.filter { [.vertical, .topAndLeft, .topAndRight].contains($0) }
        } else if vertex.index / size.width != 0 && graph.vertices[top].capacity == nodes.occupied(index: top) {
            edges = edges.filter { ![.vertical, .topAndLeft, .topAndRight].contains($0) }
        }

        return edges.compactMap {
            updateNodesByEdge(nodes: nodes, vertex: vertex, edge: $0, size: size)
        }
    }

    func updateNodesByEdge(nodes: [Int: Node], vertex: Vertex, edge: Edge, size: Board.Size) -> [Int: Node]? {
        let (inner1, outer1): (Int, Int)
        let (inner2, outer2): (Int, Int)

        switch edge {
        case .horizontal:
            /// Left on current node
            inner1 = nodes.subIndex(base: vertex.index, type: .left)
            /// Right on left node
            outer1 = nodes.subIndex(base: vertex.index - 1, type: .right)

            /// Right on current node
            inner2 = nodes.subIndex(base: vertex.index, type: .right)
            /// Left on right node
            outer2 = nodes.subIndex(base: vertex.index + 1, type: .left)

        case .vertical:
            /// Top on current node
            inner1 = nodes.subIndex(base: vertex.index, type: .top)
            /// Bottom on top node
            outer1 = nodes.subIndex(base: vertex.index - size.width, type: .bottom)

            /// Bottom on current node
            inner2 = nodes.subIndex(base: vertex.index, type: .bottom)
            /// Top on bottom node
            outer2 = nodes.subIndex(base: vertex.index + size.width, type: .top)

        case .topAndLeft:
            /// Left on current node
            inner1 = nodes.subIndex(base: vertex.index, type: .left)
            /// Right on left node
            outer1 = nodes.subIndex(base: vertex.index - 1, type: .right)

            /// Top on current node
            inner2 = nodes.subIndex(base: vertex.index, type: .top)
            /// Bottom on top node
            outer2 = nodes.subIndex(base: vertex.index - size.width, type: .bottom)

        case .topAndRight:
            /// Top on current node
            inner1 = nodes.subIndex(base: vertex.index, type: .top)
            /// Bottom on top node
            outer1 = nodes.subIndex(base: vertex.index - size.width, type: .bottom)

            /// Right on current node
            inner2 = nodes.subIndex(base: vertex.index, type: .right)
            /// Left on right node
            outer2 = nodes.subIndex(base: vertex.index + 1, type: .left)

        case .bottomAndLeft:
            /// Left on current node
            inner1 = nodes.subIndex(base: vertex.index, type: .left)
            /// Right on left node
            outer1 = nodes.subIndex(base: vertex.index - 1, type: .right)

            /// Bottom on current node
            inner2 = nodes.subIndex(base: vertex.index, type: .bottom)
            /// Top on bottom node
            outer2 = nodes.subIndex(base: vertex.index + size.width, type: .top)

        case .bottomAndRight:
            /// Right on current node
            inner1 = nodes.subIndex(base: vertex.index, type: .right)
            /// Left on right node
            outer1 = nodes.subIndex(base: vertex.index + 1, type: .left)

            /// Bottom on current node
            inner2 = nodes.subIndex(base: vertex.index, type: .bottom)
            /// Top on bottom node
            outer2 = nodes.subIndex(base: vertex.index + size.width, type: .top)
        }

        var updateNodes = nodes

        if let mateOfInner1 = nodes[inner1], let mateOfInner2 = nodes[inner2], mateOfInner1 != .inside, mateOfInner2 != .inside {
             /// Joined from both directions
            updateNodes[mateOfInner1.mate] = mateOfInner2
            updateNodes[mateOfInner2.mate] = mateOfInner1
        } else if let mateOfInner1 = nodes[inner1], mateOfInner1 != .inside {
            /// Joined from one direction
            updateNodes[mateOfInner1.mate] = .end(mate: outer2)
            updateNodes[outer2] = mateOfInner1
        } else if let mateOfInner2 = nodes[inner2], mateOfInner2 != .inside {
            /// Joined from one direction
            updateNodes[mateOfInner2.mate] = .end(mate: outer1)
            updateNodes[outer1] = mateOfInner2
        } else {
            /// Disjoint
            updateNodes[outer1] = .end(mate: outer2)
            updateNodes[outer2] = .end(mate: outer1)
        }

        updateNodes[inner1] = .inside
        updateNodes[inner2] = .inside
        return updateNodes
    }
}
