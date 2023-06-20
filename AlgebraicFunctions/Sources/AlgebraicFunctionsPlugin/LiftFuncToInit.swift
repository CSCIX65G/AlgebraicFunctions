//
//  AlgebraicFunctionsMacro.swift
//
//
//  Created by Van Simmons on 6/18/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

enum Error: Swift.Error {
    case invalidDecl(is: DeclSyntaxProtocol, shouldBe: Any.Type)
}

extension Error: CustomStringConvertible {
    var description: String {
        switch self {
            case let .invalidDecl(is: whatItIs, shouldBe: whatItShouldBe):
                "LiftFuncToInit only works on funcs. Provided syntax of \(whatItIs.self) should be \(whatItShouldBe)"
        }
    }
}

public struct LiftFuncToInitMacro: PeerMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard declaration.is(FunctionDeclSyntax.self) else {
            throw Error.invalidDecl(is: declaration, shouldBe: FunctionDeclSyntax.self)
        }
        return [
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
