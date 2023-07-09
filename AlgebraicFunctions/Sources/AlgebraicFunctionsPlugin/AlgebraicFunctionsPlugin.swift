//
//  AlgebraicFunctionsPlugin.swift
//
//
//  Created by Van Simmons on 6/18/23.
//

#if canImport(SwiftCompilerPlugin)
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AlgebraicFunctionsPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        Lift.self,
        Lower.self
    ]
}
#endif
