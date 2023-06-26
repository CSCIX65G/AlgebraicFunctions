//
//  Lower.swift
//
//
//  Created by Van Simmons on 6/19/23.
//
import AlgebraicFunctionsPlugin
import Lowers

@attached(peer, names: arbitrary)
public macro Lower<A, B>(
    operation: LowerOperation,
    file: StaticString = #filePath,
    line: UInt = #line
) = #externalMacro(module: "AlgebraicFunctionsPlugin", type: "Lower")
