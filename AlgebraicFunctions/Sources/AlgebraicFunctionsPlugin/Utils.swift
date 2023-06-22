//
//  File.swift
//  
//
//  Created by Van Simmons on 6/21/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

func funcToInit(
    fdecl: FunctionDeclSyntax
) throws -> InitializerDeclSyntax {
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

    return .init(
        leadingTrivia: .none,
        attributes: .init(arrayLiteral: .attribute(.init(stringLiteral: "@inlinable"))),
        modifiers: fdecl.modifiers,
        initKeyword: .keyword(.`init`),
        optionalMark: .none,
        genericParameterClause: .none,
        signature: .init(input: newInput),
        genericWhereClause: .none,
        body: .init(statements: statements),
        trailingTrivia: .none
    )
}
