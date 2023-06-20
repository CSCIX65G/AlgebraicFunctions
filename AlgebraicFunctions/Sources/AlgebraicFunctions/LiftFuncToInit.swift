//
//  LiftFuncToInit.swift
//  
//
//  Created by Van Simmons on 6/19/23.
//
import AlgebraicFunctionsPlugin

@attached(peer, names: arbitrary)
public macro LiftFuncToInit<A, B>(
    _ expression: (A) async throws -> B,
    _ message: @autoclosure () -> String = "Lift func to init",
    file: StaticString = #filePath,
    line: UInt = #line,
    verbose: Bool = false
) = #externalMacro(module: "AlgebraicFunctionsPlugin", type: "LiftFuncToInitMacro")
