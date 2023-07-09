//
//  LiftMacro.swift
//  
//
//  Created by Van Simmons on 6/19/23.
//
@attached(peer, names: arbitrary)
public macro Lift<A, B>(
    file: StaticString = #filePath,
    line: UInt = #line
) = #externalMacro(module: "AlgebraicFunctionsPlugin", type: "Lift")
