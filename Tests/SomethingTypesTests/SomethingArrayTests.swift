import XCTest
@testable import SomethingTypes

final class SomethingArrayTests: XCTestCase {

  func test_init_whenArrayIsNotEmpty_returnsSomethingArray() {
    XCTAssertNotNil(SomethingArray([1,2,3]))
  }

  func test_init_whenArrayIsEmpty_returnsNil() {
    XCTAssertNil(SomethingArray([]))
  }

  func test_seed_createsArrayWithElement() {
    XCTAssertEqual(SomethingArray.seed(1).elements, [1])
  }

  func test_appendStaticMethod_createsArrayWithElement() {
    XCTAssertEqual(SomethingArray.append(1).elements, [1])
  }

  func test_appendInstanceMethod_addsElements() {
    var array = SomethingArray([1])
    array?.append(2)
    array?.append(3)
    XCTAssertEqual(array?.elements, [1,2,3])
  }
}
