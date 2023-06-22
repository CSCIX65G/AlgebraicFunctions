//
//  LiftTests.swift
//  
//
//  Created by Van Simmons on 6/21/23.
//

import XCTest
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import PowerAssert

@testable import AlgebraicFunctions
@testable import AlgebraicFunctionsPlugin

let testMacros: [String: Macro.Type] = [
    "Lift" : Lift.self,
]

final class LiftTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Lift(.funcToInit)
            @inlinable
            public func doubler(_ anInt: Int) -> Double {
                .init(2 * anInt)
            }
            """,
            expandedSource: """
            @inlinable
            public func doubler(_ anInt: Int) -> Double {
                .init(2 * anInt)
            }

            extension Double {
                @inlinable
                public init(doubler anInt: Int) {
                    .init(2 * anInt)
                }
            }

            
            """,
            macros: testMacros
        )
    }
}
