//
//  LiftFuncToInit.swift
//  
//
//  Created by Van Simmons on 6/19/23.
//
import AlgebraicFunctionsPlugin

@attached(peer, names: arbitrary)
public macro Lift<A, B>(
    _ type: LiftOperation,
    file: StaticString = #filePath,
    line: UInt = #line
) = #externalMacro(module: "AlgebraicFunctionsPlugin", type: "Lift")
