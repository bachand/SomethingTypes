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
  static func seed(_ element: Element) -> Self { .init(storage: [element]) }

  /// Creates a new `SomethingArray` with one element.
  static func append(_ element: Element) -> Self { .init(storage: [element]) }

  /// Adds a new element.
  func append(_ element: Element) -> Self {
    var newStorage = storage
    newStorage.append(element)
    return .init(storage: newStorage)
  }

  private var storage: Array<Element>
}
