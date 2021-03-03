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

  public typealias Index = Int

  public var startIndex: Int { storage.startIndex }

  public var endIndex: Int { storage.endIndex }

  public typealias SubSequence = ArraySlice<Element>

  public subscript(position: Self.Index) -> Element { storage[position] }

  public subscript(bounds: Range<Self.Index>) -> Self.SubSequence { storage[bounds] }

  public typealias Indices = Range<Int>

  public var indices: Self.Indices { storage.indices }

  public var isEmpty: Bool { storage.isEmpty }

  public var count: Int { storage.count }

  public func index(_ i: Self.Index, offsetBy distance: Int) -> Self.Index {
    storage.index(i, offsetBy: distance)
  }
  public func index(_ i: Self.Index, offsetBy distance: Int, limitedBy limit: Self.Index) -> Self.Index? {
    storage.index(i, offsetBy: distance, limitedBy: limit)
  }

  public func distance(from start: Self.Index, to end: Self.Index) -> Int {
    storage.distance(from: start, to: end)
  }

  public func index(after i: Self.Index) -> Self.Index { storage.index(after: i) }

  public func formIndex(after i: inout Self.Index) { storage.formIndex(after: &i) }
}
