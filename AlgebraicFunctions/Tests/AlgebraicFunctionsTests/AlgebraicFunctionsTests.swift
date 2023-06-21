import XCTest
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import PowerAssert

@testable import AlgebraicFunctions
@testable import AlgebraicFunctionsPlugin

let testMacros: [String: Macro.Type] = [
    "LiftFuncToInit" : LiftFuncToInitMacro.self,
]

final class AlgebraicFunctionsTests: XCTestCase {
    func testMacro() throws {
        assertMacroExpansion(
            """
            @LiftFuncToInit
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

            public extension Double {
                init(_ anInt: Int) {
                .init(2 * anInt)
                }
            }

            
            """,
            macros: testMacros
        )
    }
}
