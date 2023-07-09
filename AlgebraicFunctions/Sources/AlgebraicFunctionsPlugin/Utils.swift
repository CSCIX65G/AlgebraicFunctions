//
//  File.swift
//  
//
//  Created by Van Simmons on 6/21/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

class FuncToInitRewriter: SyntaxRewriter {
    var replacingReturns = true

    override func visit(_ node: ReturnStmtSyntax) -> StmtSyntax {
        let string = (node.description as NSString).replacingOccurrences(of: "return ", with: "self = ")
        return StmtSyntax(stringLiteral: string)
    }

    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        super.visit(node)
    }
}

public func funcToInit(
    fdecl: FunctionDeclSyntax
) throws -> InitializerDeclSyntax {
    guard let _ = fdecl.signature.output?.returnType else {
        throw LiftError.nilReturnType
    }
    guard let body = fdecl.body else {
        throw LiftError.noStatements
    }
    let paramList = fdecl.signature.input.parameterList
    guard paramList.count == 1, let param = paramList.first else {
        throw LiftError.oneArgumentOnly
    }
    let newParam = param.with(\.firstName, .identifier(fdecl.identifier.description))
    let newInput = fdecl.signature.input
        .with(\.parameterList, paramList.replacing(childAt: 0, with: newParam))

    let rewriter = FuncToInitRewriter.init()
    let newBody = rewriter.visit(body)

    return .init(
        attributes: .init(arrayLiteral: .attribute(.init(stringLiteral: "@inlinable"))),
        modifiers: fdecl.modifiers,
        initKeyword: .keyword(.`init`),
        genericParameterClause: .none,
        signature: .init(input: newInput),
        genericWhereClause: .none,
        body: newBody
    )
}
