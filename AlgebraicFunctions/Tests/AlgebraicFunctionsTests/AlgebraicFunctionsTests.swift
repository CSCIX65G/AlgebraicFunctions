import XCTest
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
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
            func doubler(_ anInt: Int) -> Double { .init(2 * anInt) }
            """,
            expandedSource: """
            
            func doubler(_ anInt: Int) -> Double {
                .init(2 * anInt)
            }
            """,
            macros: testMacros
        )
    }
}
