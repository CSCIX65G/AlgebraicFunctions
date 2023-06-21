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
    case nilReturnType
    case translationFailed
    case noStatements
}

extension Error: CustomStringConvertible {
    var description: String {
        switch self {
            case let .invalidDecl(is: whatItIs, shouldBe: whatItShouldBe):
                "LiftFuncToInit only works on funcs. Provided syntax of \(whatItIs.self) should be \(whatItShouldBe)"
            case .nilReturnType:
                "LiftFuncToInit requires a valid return type"
            case .translationFailed:
                "LiftFuncToInit failed to generate"
            case .noStatements:
                "LiftFuncToInit should have some statements in the body"
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
        guard let fdecl = declaration.as(FunctionDeclSyntax.self) else {
            throw Error.invalidDecl(is: declaration, shouldBe: FunctionDeclSyntax.self)
        }
        guard let extType = fdecl.signature.output?.returnType else {
            throw Error.nilReturnType
        }
        guard let rawStatements = fdecl.body?.statements else {
            throw Error.noStatements
        }
        let statements = rawStatements
        
        guard let output = ExtensionDeclSyntax(
            leadingTrivia: .carriageReturn,
            attributes: .none,
            modifiers: fdecl.modifiers,
            extensionKeyword: .keyword(.extension),
            extendedType: extType,
            inheritanceClause: .none,
            genericWhereClause: .none,
            memberBlock: .init(
                leftBrace: .leftBraceToken(),
                members: .init([
                    .init(
                        leadingTrivia: .none,
                        decl: InitializerDeclSyntax.init(
                            leadingTrivia: .spaces(4),
                            attributes: .none,
                            modifiers: .none,
                            initKeyword: .keyword(.`init`),
                            optionalMark: .none,
                            genericParameterClause: .none,
                            signature: .init(input: fdecl.signature.input),
                            genericWhereClause: .none,
                            body: .init(statements: statements),
                            trailingTrivia: .none
                        ),
                        trailingTrivia: .none
                    )
                ]),
                rightBrace: .rightBraceToken()
            ),
            trailingTrivia: .carriageReturnLineFeed
        ).as(DeclSyntax.self) else {
            throw Error.translationFailed
        }
        return [
            output
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
