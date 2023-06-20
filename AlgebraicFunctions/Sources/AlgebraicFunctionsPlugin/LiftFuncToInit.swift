//
//  AlgebraicFunctionsMacro.swift
//
//
//  Created by Van Simmons on 6/18/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct LiftFuncToInitMacro: PeerMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        [
            DeclSyntax(stringLiteral: "")
        ]
    }
    
    private struct CodeGenerator {
        let macro: any FreestandingMacroExpansionSyntax
        let context: any MacroExpansionContext
        
        func generate() -> ExprSyntax {
            return ExprSyntax("()").with(\.leadingTrivia, macro.leadingTrivia)
        }
    }
}
