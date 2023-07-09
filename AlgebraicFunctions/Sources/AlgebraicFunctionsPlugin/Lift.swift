//
//  Lift.swift
//
//
//  Created by Van Simmons on 6/18/23.
//
import SwiftSyntax
import SwiftSyntaxMacros

public enum LiftOperation {
    case funcToInit
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
            throw LiftError.invalidDecl(is: declaration, shouldBe: FunctionDeclSyntax.self)
        }
        guard let extType = fdecl.signature.output?.returnType else {
            throw LiftError.nilReturnType
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
