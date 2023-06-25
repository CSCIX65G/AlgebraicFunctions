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

    func testLiftFuncToInit() throws {
        assertMacroExpansion(
            """
            @Lift(operation: .funcToInit)
            @inlinable
            public func doubler(_ anInt: Int) -> Double {
                let value = 2 * anInt
                return .init(value)
            }
            """,
            expandedSource: """
            @inlinable
            public func doubler(_ anInt: Int) -> Double {
                let value = 2 * anInt
                return .init(value)
            }

            extension Double {
                @inlinable
                public init(doubler anInt: Int) {
                    let value = 2 * anInt
                    self = .init(value)
                }
            }


            """,
            macros: testMacros
        )
    }
}
