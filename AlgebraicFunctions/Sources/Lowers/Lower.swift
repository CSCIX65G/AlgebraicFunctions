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
}

extension LowerError: CustomStringConvertible {
    public var description: String {
        switch self {
            case let .invalidDecl(is: whatItIs, shouldBe: whatItShouldBe):
                "Lower only works on funcs. Provided syntax of \(whatItIs.self) should be \(whatItShouldBe)"
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
        guard let fdecl = declaration.as(InitializerDeclSyntax.self) else {
            throw LowerError.invalidDecl(is: declaration, shouldBe: FunctionDeclSyntax.self)
        }

        return [
            FunctionDeclSyntax(
                leadingTrivia: .none, .none,
                attributes: .none, .none,
                modifiers: .none, .none,
                funcKeyword: .keyword(.func), .none,
                identifier: .identifier("aFunc"), .none,
                genericParameterClause: .none, .none,
                signature: fdecl.signature, .none,
                genericWhereClause: .none, .none,
                body: .none, .none,
                trailingTrivia: .none
            )
            .with(\.leadingTrivia, .carriageReturnLineFeed)
        ].compactMap { $0.as(DeclSyntax.self)  }
    }
}
