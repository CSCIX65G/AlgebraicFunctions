//
//  LowerTests.swift
//  
//
//  Created by Van Simmons on 6/25/23.
//

import XCTest
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import PowerAssert

final class LowerTests: XCTestCase {
    func testLowerInitToFunc() throws {
        assertMacroExpansion(
            """
            extension Double {
                @inlinable
                public init(doubler anInt: Int) {
                    let value = 2 * anInt
                    self = .init(value)
                }
            }
            """,
            expandedSource: """
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
