//
//  main.swift
//
//
//  Created by Van Simmons on 7/9/23.
//
import AlgebraicFunctions

@Lift()
@inlinable
public func doubler(_ anInt: Int) -> Double {
    let value = 2 * anInt
    return .init(value)
}

print("Hello, world")
