//
//  AlgebraicFunctionsMacro.swift
//
//
//  Created by Van Simmons on 6/18/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct AlgebraicFunctionsMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        let generator = CodeGenerator(macro: node, context: context)
        return generator.generate()
    }

    private struct CodeGenerator {
        let macro: any FreestandingMacroExpansionSyntax
        let context: any MacroExpansionContext
        
        func generate() -> ExprSyntax {
            return ExprSyntax("()").with(\.leadingTrivia, macro.leadingTrivia)
        }
    }
}
