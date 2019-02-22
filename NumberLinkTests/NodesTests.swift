import XCTest
@testable import NumberLink

final class NodesTests: XCTestCase {
    func testUnique() {
        let node1: [Int: Node] = [
            0: .end(mate: 2),
            1: .inside
        ]

        let node2: [Int: Node] = [
            0: .end(mate: 2),
            1: .inside,
            2: .inside
        ]

        let node3: [Int: Node] = [
            0: .end(mate: 2),
            1: .inside,
            2: .end(mate: 0)
        ]

        XCTAssertEqual([node1, node2, node3].unique(), [node1, node3])
    }

    func testMate() {
        let nodes: [Int: Node] = [
            0: .end(mate: 1),
            1: .end(mate: 0)
        ]

        XCTAssertEqual(nodes.mate(index: 0), 0)
    }

    func testMates() {
        let nodes: [Int: Node] = [
            0: .end(mate: 2),
            1: .inside,
            2: .end(mate: 0),
            3: .inside
        ]

        XCTAssertEqual(nodes.mates(), [
            0: .end(mate: 2),
            2: .end(mate: 0)
        ])
    }

    func testOccupied() {
        let nodes: [Int: Node] = [
            0: .end(mate: 0),
            1: .end(mate: 0),
            2: .end(mate: 0),
            4: .end(mate: 0)
        ]

        XCTAssertEqual(nodes.occupied(index: 0), 3)
    }

    func testSubIndex() {
        let nodes: [Int: Node] = [:]

        XCTAssertEqual(nodes.subIndex(base: 0, type: .left), 0)
        XCTAssertEqual(nodes.subIndex(base: 1, type: .top), 5)
        XCTAssertEqual(nodes.subIndex(base: 2, type: .right), 10)
        XCTAssertEqual(nodes.subIndex(base: 3, type: .bottom), 15)
    }

    func testFindNode() {
        let nodes: [Int: Node] = [
            0: .end(mate: 1)
        ]

        XCTAssertEqual(nodes.findNode(base: 0, type: .left), .end(mate: 1))
        XCTAssertNil(nodes.findNode(base: 0, type: .top))
    }

    func testFindNodes() {
        let nodes: [Int: Node] = [
            0: .end(mate: 0),
            1: .end(mate: 1),
            2: .inside,
            4: .end(mate: 2)
        ]

        let subNodes: [Node] = [
            .end(mate: 0),
            .end(mate: 1),
            .inside
        ]

        XCTAssertEqual(nodes.findNodes(by: 0), subNodes)
    }
}
