/// An array that is guranteed to have at least one item.
public struct SomethingArray<Element> {

  // MARK: Lifecycle

  public init?(_ elements: [Element]) {
    guard !elements.isEmpty else { return nil }
    self.init(storage: elements)
  }

  private init(storage: [Element]) {
    self.storage = storage
  }

  // MARK: Public

  /// Creates a new `SomethingArray` with one element.
  public static func seed(_ element: Element) -> Self { .init(storage: [element]) }

  /// Creates a new `SomethingArray` with one element.
  public static func append(_ element: Element) -> Self { .init(storage: [element]) }

  /// The elements.
  public var elements: Array<Element> { storage }

  /// Adds a new element.
  public mutating func append(_ element: Element) { storage.append(element) }

  // MARK: Private

  private var storage: Array<Element>
}

// MARK: Sequence

extension SomethingArray: Sequence {

  /// The type that allows iteration over an array's elements.
  public typealias Iterator = IndexingIterator<Array<Element>>

  public var underestimatedCount: Int { storage.underestimatedCount }

  public __consuming func makeIterator() -> IndexingIterator<Array<Element>> {
    storage.makeIterator()
  }

  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Self.Element>) throws -> R) rethrows
  -> R?
  {
    try storage.withContiguousStorageIfAvailable(body)
  }
}

//// MARK: Collection

extension SomethingArray: Collection {

  /// The index type for arrays, `Int`.
  public typealias Index = Int

  /// The position of the first element in a nonempty array.
  ///
  /// For an instance of `Array`, `startIndex` is always zero. If the array
  /// is empty, `startIndex` is equal to `endIndex`.
  public var startIndex: Int { storage.startIndex }

  /// The array's "past the end" position---that is, the position one greater
  /// than the last valid subscript argument.
  ///
  /// When you need a range that includes the last element of an array, use the
  /// half-open range operator (`..<`) with `endIndex`. The `..<` operator
  /// creates a range that doesn't include the upper bound, so it's always
  /// safe to use with `endIndex`. For example:
  ///
  ///     let numbers = [10, 20, 30, 40, 50]
  ///     if let i = numbers.firstIndex(of: 30) {
  ///         print(numbers[i ..< numbers.endIndex])
  ///     }
  ///     // Prints "[30, 40, 50]"
  ///
  /// If the array is empty, `endIndex` is equal to `startIndex`.
  public var endIndex: Int { storage.endIndex }

  /// A sequence that represents a contiguous subrange of the collection's
  /// elements.
  ///
  /// This associated type appears as a requirement in the `Sequence`
  /// protocol, but it is restated here with stricter constraints. In a
  /// collection, the subsequence should also conform to `Collection`.
  public typealias SubSequence = ArraySlice<Element>

  /// Accesses the element at the specified position.
  ///
  /// The following example accesses an element of an array through its
  /// subscript to print its value:
  ///
  ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
  ///     print(streets[1])
  ///     // Prints "Bryant"
  ///
  /// You can subscript a collection with any valid index other than the
  /// collection's end index. The end index refers to the position one past
  /// the last element of a collection, so it doesn't correspond with an
  /// element.
  ///
  /// - Parameter position: The position of the element to access. `position`
  ///   must be a valid index of the collection that is not equal to the
  ///   `endIndex` property.
  ///
  /// - Complexity: O(1)
  public subscript(position: Self.Index) -> Element { storage[position] }

  /// Accesses a contiguous subrange of the collection's elements.
  ///
  /// For example, using a `PartialRangeFrom` range expression with an array
  /// accesses the subrange from the start of the range expression until the
  /// end of the array.
  ///
  ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
  ///     let streetsSlice = streets[2..<5]
  ///     print(streetsSlice)
  ///     // ["Channing", "Douglas", "Evarts"]
  ///
  /// The accessed slice uses the same indices for the same elements as the
  /// original collection. This example searches `streetsSlice` for one of the
  /// strings in the slice, and then uses that index in the original array.
  ///
  ///     let index = streetsSlice.firstIndex(of: "Evarts")!    // 4
  ///     print(streets[index])
  ///     // "Evarts"
  ///
  /// Always use the slice's `startIndex` property instead of assuming that its
  /// indices start at a particular value. Attempting to access an element by
  /// using an index outside the bounds of the slice may result in a runtime
  /// error, even if that index is valid for the original collection.
  ///
  ///     print(streetsSlice.startIndex)
  ///     // 2
  ///     print(streetsSlice[2])
  ///     // "Channing"
  ///
  ///     print(streetsSlice[0])
  ///     // error: Index out of bounds
  ///
  /// - Parameter bounds: A range of the collection's indices. The bounds of
  ///   the range must be valid indices of the collection.
  ///
  /// - Complexity: O(1)
  public subscript(bounds: Range<Self.Index>) -> Self.SubSequence { storage[bounds] }

  /// The type that represents the indices that are valid for subscripting an
  /// array, in ascending order.
  public typealias Indices = Range<Int>

  /// The indices that are valid for subscripting the collection, in ascending
  /// order.
  ///
  /// A collection's `indices` property can hold a strong reference to the
  /// collection itself, causing the collection to be nonuniquely referenced.
  /// If you mutate the collection while iterating over its indices, a strong
  /// reference can result in an unexpected copy of the collection. To avoid
  /// the unexpected copy, use the `index(after:)` method starting with
  /// `startIndex` to produce indices instead.
  ///
  ///     var c = MyFancyCollection([10, 20, 30, 40, 50])
  ///     var i = c.startIndex
  ///     while i != c.endIndex {
  ///         c[i] /= 5
  ///         i = c.index(after: i)
  ///     }
  ///     // c == MyFancyCollection([2, 4, 6, 8, 10])
  public var indices: Self.Indices { storage.indices }

  /// A Boolean value indicating whether the collection is empty.
  ///
  /// When you need to check whether your collection is empty, use the
  /// `isEmpty` property instead of checking that the `count` property is
  /// equal to zero. For collections that don't conform to
  /// `RandomAccessCollection`, accessing the `count` property iterates
  /// through the elements of the collection.
  ///
  ///     let horseName = "Silver"
  ///     if horseName.isEmpty {
  ///         print("My horse has no name.")
  ///     } else {
  ///         print("Hi ho, \(horseName)!")
  ///     }
  ///     // Prints "Hi ho, Silver!"
  ///
  /// - Complexity: O(1)
  public var isEmpty: Bool { storage.isEmpty }

  /// The number of elements in the collection.
  ///
  /// To check whether a collection is empty, use its `isEmpty` property
  /// instead of comparing `count` to zero. Unless the collection guarantees
  /// random-access performance, calculating `count` can be an O(*n*)
  /// operation.
  ///
  /// - Complexity: O(1) if the collection conforms to
  ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
  ///   of the collection.
  public var count: Int { storage.count }

  /// Returns an index that is the specified distance from the given index.
  ///
  /// The following example obtains an index advanced four positions from a
  /// string's starting index and then prints the character at that position.
  ///
  ///     let s = "Swift"
  ///     let i = s.index(s.startIndex, offsetBy: 4)
  ///     print(s[i])
  ///     // Prints "t"
  ///
  /// The value passed as `distance` must not offset `i` beyond the bounds of
  /// the collection.
  ///
  /// - Parameters:
  ///   - i: A valid index of the collection.
  ///   - distance: The distance to offset `i`. `distance` must not be negative
  ///     unless the collection conforms to the `BidirectionalCollection`
  ///     protocol.
  /// - Returns: An index offset by `distance` from the index `i`. If
  ///   `distance` is positive, this is the same value as the result of
  ///   `distance` calls to `index(after:)`. If `distance` is negative, this
  ///   is the same value as the result of `abs(distance)` calls to
  ///   `index(before:)`.
  ///
  /// - Complexity: O(1) if the collection conforms to
  ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
  ///   value of `distance`.
  public func index(_ i: Self.Index, offsetBy distance: Int) -> Self.Index {
    storage.index(i, offsetBy: distance)
  }

  /// Returns an index that is the specified distance from the given index,
  /// unless that distance is beyond a given limiting index.
  ///
  /// The following example obtains an index advanced four positions from a
  /// string's starting index and then prints the character at that position.
  /// The operation doesn't require going beyond the limiting `s.endIndex`
  /// value, so it succeeds.
  ///
  ///     let s = "Swift"
  ///     if let i = s.index(s.startIndex, offsetBy: 4, limitedBy: s.endIndex) {
  ///         print(s[i])
  ///     }
  ///     // Prints "t"
  ///
  /// The next example attempts to retrieve an index six positions from
  /// `s.startIndex` but fails, because that distance is beyond the index
  /// passed as `limit`.
  ///
  ///     let j = s.index(s.startIndex, offsetBy: 6, limitedBy: s.endIndex)
  ///     print(j)
  ///     // Prints "nil"
  ///
  /// The value passed as `distance` must not offset `i` beyond the bounds of
  /// the collection, unless the index passed as `limit` prevents offsetting
  /// beyond those bounds.
  ///
  /// - Parameters:
  ///   - i: A valid index of the collection.
  ///   - distance: The distance to offset `i`. `distance` must not be negative
  ///     unless the collection conforms to the `BidirectionalCollection`
  ///     protocol.
  ///   - limit: A valid index of the collection to use as a limit. If
  ///     `distance > 0`, a limit that is less than `i` has no effect.
  ///     Likewise, if `distance < 0`, a limit that is greater than `i` has no
  ///     effect.
  /// - Returns: An index offset by `distance` from the index `i`, unless that
  ///   index would be beyond `limit` in the direction of movement. In that
  ///   case, the method returns `nil`.
  ///
  /// - Complexity: O(1) if the collection conforms to
  ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
  ///   value of `distance`.
  public func index(_ i: Self.Index, offsetBy distance: Int, limitedBy limit: Self.Index) -> Self.Index? {
    storage.index(i, offsetBy: distance, limitedBy: limit)
  }

  /// Returns the distance between two indices.
  ///
  /// Unless the collection conforms to the `BidirectionalCollection` protocol,
  /// `start` must be less than or equal to `end`.
  ///
  /// - Parameters:
  ///   - start: A valid index of the collection.
  ///   - end: Another valid index of the collection. If `end` is equal to
  ///     `start`, the result is zero.
  /// - Returns: The distance between `start` and `end`. The result can be
  ///   negative only if the collection conforms to the
  ///   `BidirectionalCollection` protocol.
  ///
  /// - Complexity: O(1) if the collection conforms to
  ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the
  ///   resulting distance.
  public func distance(from start: Self.Index, to end: Self.Index) -> Int {
    storage.distance(from: start, to: end)
  }

  /// Returns the position immediately after the given index.
  ///
  /// The successor of an index must be well defined. For an index `i` into a
  /// collection `c`, calling `c.index(after: i)` returns the same index every
  /// time.
  ///
  /// - Parameter i: A valid index of the collection. `i` must be less than
  ///   `endIndex`.
  /// - Returns: The index value immediately after `i`.
  public func index(after i: Self.Index) -> Self.Index {
    storage.index(after: i)
  }

  /// Replaces the given index with its successor.
  ///
  /// - Parameter i: A valid index of the collection. `i` must be less than
  ///   `endIndex`.
  public func formIndex(after i: inout Self.Index) {
    storage.formIndex(after: &i)
  }
}
