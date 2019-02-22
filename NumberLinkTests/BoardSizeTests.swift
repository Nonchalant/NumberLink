import XCTest
@testable import NumberLink

final class BoardSizeTests: XCTestCase {
    func testBoardSize() {
        let size = Board.Size(width: 3, height: 4)
        XCTAssertEqual(size.amount, 12)
    }
}
