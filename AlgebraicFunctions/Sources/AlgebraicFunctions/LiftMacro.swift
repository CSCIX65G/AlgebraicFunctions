//
//  LiftMacro.swift
//  
//
//  Created by Van Simmons on 6/19/23.
//
@attached(peer)
public macro Lift(
    file: StaticString = #filePath,
    line: UInt = #line
) = #externalMacro(module: "AlgebraicFunctionsPlugin", type: "Lift")
