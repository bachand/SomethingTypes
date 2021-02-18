import XCTest
@testable import SomethingTypes

final class SomethingArrayTests: XCTestCase {

  func test_init_whenArrayIsNotEmpty_returnsSomethingArray() {
    XCTAssertNotNil(SomethingArray([1,2,3]))
  }

  func test_init_whenArrayIsEmpty_returnsNil() {
    XCTAssertNil(SomethingArray([]))
  }
}
