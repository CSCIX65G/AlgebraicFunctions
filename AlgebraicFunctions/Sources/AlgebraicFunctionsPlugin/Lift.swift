//
//  AlgebraicFunctionsMacro.swift
//
//
//  Created by Van Simmons on 6/18/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

public enum LiftOperation {
    case funcToInt
}

public enum Error: Swift.Error {
    case invalidDecl(is: DeclSyntaxProtocol, shouldBe: Any.Type)
    case nilReturnType
    case translationFailed
    case noStatements
    case oneArgumentOnly
}

extension Error: CustomStringConvertible {
    public var description: String {
        switch self {
            case let .invalidDecl(is: whatItIs, shouldBe: whatItShouldBe):
                "Lift only works on funcs. Provided syntax of \(whatItIs.self) should be \(whatItShouldBe)"
            case .nilReturnType:
                "Lift requires a valid return type"
            case .translationFailed:
                "Lift failed to generate"
            case .noStatements:
                "Lift should have some statements in the body"
            case .oneArgumentOnly:
                "Lift should have exactly one arg"
        }
    }
}

public struct Lift: PeerMacro {
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
        guard let statements = fdecl.body?.statements else {
            throw Error.noStatements
        }
        let paramList = fdecl.signature.input.parameterList
        guard paramList.count == 1, let param = paramList.first else {
            throw Error.oneArgumentOnly
        }
        let argExternalName = fdecl.identifier.description
        let newParam = param.with(\.firstName, .identifier(argExternalName))
        let newParamList = paramList.replacing(childAt: 0, with: newParam)
        let newInput = fdecl.signature.input.with(\.parameterList, newParamList)

        guard let output = ExtensionDeclSyntax(
            leadingTrivia: .carriageReturnLineFeed,
            attributes: .none,
            modifiers: .none,
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
                            leadingTrivia: .none, //.spaces(4),
                            attributes: .init(arrayLiteral: .attribute(.init(stringLiteral: "@inlinable"))),
                            modifiers: fdecl.modifiers,
                            initKeyword: .keyword(.`init`),
                            optionalMark: .none,
                            genericParameterClause: .none,
                            signature: .init(input: newInput),
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
