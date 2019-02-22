import XCTest
@testable import NumberLink

final class GraphTests: XCTestCase {
    func testVacants() {
        let board = Board(
            size: Board.Size(width: 4, height: 4),
            pins: [
                Board.Pin(id: 1, pairs: [0, 9]),
                Board.Pin(id: 2, pairs: [4, 6]),
                Board.Pin(id: 3, pairs: [2, 15])
            ]
        )

        let graph = Graph(vertices: [
            Vertex.pin(id: 1, index: 0),
            Vertex.vacant(index: 1),
            Vertex.pin(id: 3, index: 2),
            Vertex.vacant(index: 3),
            Vertex.pin(id: 2, index: 4),
            Vertex.vacant(index: 5),
            Vertex.pin(id: 2, index: 6),
            Vertex.vacant(index: 7),
            Vertex.vacant(index: 8),
            Vertex.pin(id: 1, index: 9),
            Vertex.vacant(index: 10),
            Vertex.vacant(index: 11),
            Vertex.vacant(index: 12),
            Vertex.vacant(index: 13),
            Vertex.vacant(index: 14),
            Vertex.pin(id: 3, index: 15)
        ])

        XCTAssertEqual(Graph(board: board), graph)
        XCTAssertEqual(graph.vacants, [
            Vertex.vacant(index: 1),
            Vertex.vacant(index: 3),
            Vertex.vacant(index: 5),
            Vertex.vacant(index: 7),
            Vertex.vacant(index: 8),
            Vertex.vacant(index: 10),
            Vertex.vacant(index: 11),
            Vertex.vacant(index: 12),
            Vertex.vacant(index: 13),
            Vertex.vacant(index: 14)
        ])
    }
}
