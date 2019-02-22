import XCTest
@testable import NumberLink

final class NumberLinkGeneratorTests: XCTestCase {
    var generator: NumberLinkGenerator!

    override func setUp() {
        generator = NumberLinkGenerator()
    }

    func testCheckValidBoard() {
        let validBoard = Board(
            size: Board.Size(width: 3, height: 3),
            pins: [
                Board.Pin(id: 1, pairs: [0, 4]),
                Board.Pin(id: 2, pairs: [2, 3])
            ]
        )

        XCTAssertTrue(generator.checkValidBoard(with: validBoard))

        let invalidBoard = Board(
            size: Board.Size(width: 3, height: 3),
            pins: [
                Board.Pin(id: 1, pairs: [0, 4]),
                Board.Pin(id: 2, pairs: [2, 5])
            ]
        )

        XCTAssertFalse(generator.checkValidBoard(with: invalidBoard))
    }

    func testUpdateNodes() {
        var nodes: [Int: Node]!
        var vertex: Vertex!
        var graph: Graph!
        var board = Board(size: Board.Size(width: 3, height: 3), pins: [])

        /// Top left corner
        nodes = [:]
        vertex = .vacant(index: 0)
        graph = Graph(board: board)

        XCTAssertEqual(
            generator.updateNodes(nodes: nodes, vertex: vertex, graph: graph, size: board.size),
            [
                [
                    4: .end(mate: 13),
                    2: .inside,
                    3: .inside,
                    13: .end(mate: 4)
                ]
            ]
        )

        /// Top center
        nodes = [:]
        vertex = .vacant(index: 1)
        graph = Graph(board: board)

        XCTAssertEqual(
            generator.updateNodes(nodes: nodes, vertex: vertex, graph: graph, size: board.size),
            [
                [
                    2: .end(mate: 8),
                    4: .inside,
                    6: .inside,
                    8: .end(mate: 2)
                ],
                [
                    2: .end(mate: 17),
                    4: .inside,
                    7: .inside,
                    17: .end(mate: 2)
                ],
                [
                    8: .end(mate: 17),
                    6: .inside,
                    7: .inside,
                    17: .end(mate: 8)
                ]
            ]
        )


        /// Center
        nodes = [:]
        vertex = .vacant(index: 4)
        graph = Graph(board: board)

        XCTAssertEqual(
            generator.updateNodes(nodes: nodes, vertex: vertex, graph: graph, size: board.size),
            [
                [
                    14: .end(mate: 20),
                    16: .inside,
                    18: .inside,
                    20: .end(mate: 14)
                ],
                [
                    7: .end(mate: 29),
                    17: .inside,
                    19: .inside,
                    29: .end(mate: 7)
                ],
                [
                    7: .end(mate: 14),
                    17: .inside,
                    16: .inside,
                    14: .end(mate: 7)
                ],
                [
                    7: .end(mate: 20),
                    17: .inside,
                    18: .inside,
                    20: .end(mate: 7)
                ],
                [
                    14: .end(mate: 29),
                    16: .inside,
                    19: .inside,
                    29: .end(mate: 14)
                ],
                [
                    20: .end(mate: 29),
                    18: .inside,
                    19: .inside,
                    29: .end(mate: 20)
                ]
            ]
        )


        /// Pin Capacity
        nodes = [
            4: .end(mate: 13),
            2: .inside,
            3: .inside,
            13: .end(mate: 4)
        ]
        vertex = .vacant(index: 4)
        board = Board(size: Board.Size(width: 3, height: 3), pins: [Board.Pin(id: 1, pairs: [1, 5])])
        graph = Graph(board: board)

        XCTAssertEqual(
            generator.updateNodes(nodes: nodes, vertex: vertex, graph: graph, size: board.size),
            [
                [
                    4: .end(mate: 13),
                    2: .inside,
                    3: .inside,
                    13: .end(mate: 4),
                    14: .end(mate: 20),
                    16: .inside,
                    18: .inside,
                    20: .end(mate: 14)
                ],
                [
                    4: .end(mate: 13),
                    2: .inside,
                    3: .inside,
                    13: .end(mate: 4),
                    14: .end(mate: 29),
                    16: .inside,
                    19: .inside,
                    29: .end(mate: 14)
                ],
                [
                    4: .end(mate: 13),
                    2: .inside,
                    3: .inside,
                    13: .end(mate: 4),
                    20: .end(mate: 29),
                    18: .inside,
                    19: .inside,
                    29: .end(mate: 20)
                ]
            ]
        )


        /// Left on current node
        nodes = [
            4: .end(mate: 13),
            2: .inside,
            3: .inside,
            13: .end(mate: 4)
        ]
        vertex = .vacant(index: 1)
        graph = Graph(board: board)

        XCTAssertEqual(
            generator.updateNodes(nodes: nodes, vertex: vertex, graph: graph, size: board.size),
            [
                [
                    8: .end(mate: 13),
                    6: .inside,
                    4: .inside,
                    2: .inside,
                    3: .inside,
                    13: .end(mate: 8)
                ],
                [
                    13: .end(mate: 17),
                    3: .inside,
                    2: .inside,
                    4: .inside,
                    7: .inside,
                    17: .end(mate: 13)
                ]
            ]
        )


        /// Top on current node
        nodes = [
            2: .end(mate: 17),
            4: .inside,
            7: .inside,
            17: .end(mate: 2)
        ]
        vertex = .vacant(index: 4)
        graph = Graph(board: board)

        XCTAssertEqual(
            generator.updateNodes(nodes: nodes, vertex: vertex, graph: graph, size: board.size),
            [
                [
                    2: .end(mate: 29),
                    4: .inside,
                    7: .inside,
                    17: .inside,
                    19: .inside,
                    29: .end(mate: 2)
                ],
                [
                    2: .end(mate: 14),
                    4: .inside,
                    7: .inside,
                    17: .inside,
                    16: .inside,
                    14: .end(mate: 2),
                ],
                [
                    2: .end(mate: 20),
                    4: .inside,
                    7: .inside,
                    17: .inside,
                    18: .inside,
                    20: .end(mate: 2)
                ]
            ]
        )
    }

    func testUpdateNodesByEdge() {
        var nodes: [Int: Node]!
        var vertex: Vertex!
        var edge: Edge!
        let size = Board.Size(width: 3, height: 3)


        /// horizontal (Joined from one direction - Inner1)
        nodes = [
            4: .end(mate: 13),
            2: .inside,
            3: .inside,
            13: .end(mate: 4)
        ]
        vertex = .vacant(index: 1)
        edge = .horizontal

        XCTAssertEqual(
            generator.updateNodesByEdge(nodes: nodes, vertex: vertex, edge: edge, size: size),
            [
                8: .end(mate: 13),
                6: .inside,
                4: .inside,
                2: .inside,
                3: .inside,
                13: .end(mate: 8)
            ]
        )


        /// vertical (Joined from one direction - Inner1)
        nodes = [
            4: .end(mate: 13),
            2: .inside,
            3: .inside,
            13: .end(mate: 4)
        ]
        vertex = .vacant(index: 3)
        edge = .vertical

        XCTAssertEqual(
            generator.updateNodesByEdge(nodes: nodes, vertex: vertex, edge: edge, size: size),
            [
                4: .end(mate: 25),
                2: .inside,
                3: .inside,
                13: .inside,
                15: .inside,
                25: .end(mate: 4)
            ]
        )


        /// topAndLeft (Joined from one direction - Inner2)
        nodes = [
            2: .end(mate: 17),
            4: .inside,
            7: .inside,
            17: .end(mate: 2)
        ]
        vertex = .vacant(index: 4)
        edge = .topAndLeft

        XCTAssertEqual(
            generator.updateNodesByEdge(nodes: nodes, vertex: vertex, edge: edge, size: size),
            [
                2: .end(mate: 14),
                4: .inside,
                7: .inside,
                17: .inside,
                16: .inside,
                14: .end(mate: 2)
            ]
        )


        /// topAndRight (Disjoint)
        nodes = [
            4: .end(mate: 13),
            2: .inside,
            3: .inside,
            13: .end(mate: 4)
        ]
        vertex = .vacant(index: 4)
        edge = .topAndRight

        XCTAssertEqual(
            generator.updateNodesByEdge(nodes: nodes, vertex: vertex, edge: edge, size: size),
            [
                4: .end(mate: 13),
                2: .inside,
                3: .inside,
                13: .end(mate: 4),
                7: .end(mate: 20),
                17: .inside,
                18: .inside,
                20: .end(mate: 7)
            ]
        )


        /// bottomAndLeft (Joined from both directions)
        nodes = [
            4: .end(mate: 13),
            2: .inside,
            3: .inside,
            13: .end(mate: 4),
            7: .end(mate: 14),
            17: .inside,
            16: .inside,
            14: .end(mate: 7),
        ]
        vertex = .vacant(index: 1)
        edge = .bottomAndLeft

        XCTAssertEqual(
            generator.updateNodesByEdge(nodes: nodes, vertex: vertex, edge: edge, size: size),
            [
                13: .end(mate: 14),
                2: .inside,
                3: .inside,
                4: .inside,
                7: .inside,
                17: .inside,
                16: .inside,
                14: .end(mate: 13)
            ]
        )


        /// bottomAndRight (Joined from both directions - Cycle)
        nodes = [
            2: .end(mate: 3),
            13: .inside,
            14: .inside,
            16: .inside,
            17: .inside,
            7: .inside,
            4: .inside,
            3: .end(mate: 2),
        ]
        vertex = .vacant(index: 0)
        edge = .bottomAndRight

        XCTAssertEqual(
            generator.updateNodesByEdge(nodes: nodes, vertex: vertex, edge: edge, size: size),
            [
                2: .inside,
                13: .inside,
                14: .inside,
                16: .inside,
                17: .inside,
                7: .inside,
                4: .inside,
                3: .inside
            ]
        )
    }
}
