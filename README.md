# SomethingTypes

`SomethingArray` define away the empty case with a compile-time guarantee that "something" always exists in the array.

```swift
var array = SomethingArray<Int>.seed(1)
print(array) // [1]
array.append(2)
print(array) // [1,2]
```

It is possible to create a `SomethingArray` from a standard array, but the result is an optional.

```swift
print(SomethingArray([4,5,6])) // Optional([4,5,6])
print(SomethingArray<Int>([])) // nil
```

`static func append(_:)` is an alias for `static func seed(_:)` that enables a homogenous code.

```swift
var array = SomethingArray.append("a")
array.append("b")
array.append("c")
print(array) // ["a","b","c"]
```
