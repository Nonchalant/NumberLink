import XCTest
@testable import NumberLink

final class VertexTests: XCTestCase {
    func testIndex() {
        XCTAssertEqual(Vertex.pin(id: 0, index: 1).index, 1)
        XCTAssertEqual(Vertex.vacant(index: 2).index, 2)
    }

    func testCapacity() {
        XCTAssertEqual(Vertex.pin(id: 0, index: 1).capacity, 1)
        XCTAssertEqual(Vertex.vacant(index: 2).capacity, 2)
    }
}
