//
//  Lower.swift
//
//
//  Created by Van Simmons on 6/25/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

public enum LowerOperation {
    case initToFunc
}

public enum LowerError: Swift.Error {
    case invalidDecl(is: DeclSyntaxProtocol, shouldBe: Any.Type)
    case nilReturnType
    case translationFailed
    case noStatements
    case oneArgumentOnly
}

extension LowerError: CustomStringConvertible {
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

public struct Lower: PeerMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let fdecl = declaration.as(FunctionDeclSyntax.self) else {
            throw LowerError.invalidDecl(is: declaration, shouldBe: FunctionDeclSyntax.self)
        }
        guard let extType = fdecl.signature.output?.returnType else {
            throw LowerError.nilReturnType
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
        ].compactMap { $0.as(DeclSyntax.self)  }
    }
}
