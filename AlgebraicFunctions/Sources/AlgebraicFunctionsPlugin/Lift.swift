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

        return [
            ExtensionDeclSyntax(
                extensionKeyword: .keyword(.extension),
                extendedType: extType,
                genericWhereClause: .none,
                memberBlock: .init(
                    leftBrace: .leftBraceToken(),
                    members: .init([
                        .init(decl: try funcToInit(fdecl: fdecl))
                    ]),
                    rightBrace: .rightBraceToken()
                )
            )
            .with(\.leadingTrivia, .carriageReturnLineFeed)
            .with(\.trailingTrivia, .carriageReturnLineFeed)
        ].compactMap { $0.as(DeclSyntax.self)  }
    }
}
