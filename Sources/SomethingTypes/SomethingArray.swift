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

  /// Creates a new `SomethingArray` with one element.
  public static func seed(_ element: Element) -> Self { .init(storage: [element]) }

  /// Creates a new `SomethingArray` with one element.
  public static func append(_ element: Element) -> Self { .init(storage: [element]) }

  /// The elements.
  public var elements: Array<Element> { storage }

  /// Adds a new element.
  public mutating func append(_ element: Element) { storage.append(element) }

  private var storage: Array<Element>
}
