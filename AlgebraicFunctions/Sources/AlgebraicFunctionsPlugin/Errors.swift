//
//  Errors.swift
//  
//
//  Created by Van Simmons on 7/9/23.
//
import SwiftSyntax

public enum LiftError: Swift.Error {
    case invalidDecl(is: DeclSyntaxProtocol, shouldBe: Any.Type)
    case nilReturnType
    case translationFailed
    case noStatements
    case oneArgumentOnly
}

extension LiftError: CustomStringConvertible {
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
