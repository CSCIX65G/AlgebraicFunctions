//
//  LiftFuncToInit.swift
//  
//
//  Created by Van Simmons on 6/19/23.
//
import AlgebraicFunctionsPlugin

@attached(peer, names: arbitrary)
public macro liftFuncToInit(
    _ expression: @autoclosure () throws -> Bool,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    verbose: Bool = false
) = #externalMacro(module: "AlgebraicFunctionsPlugin", type: "LiftFuncToInitMacro")
