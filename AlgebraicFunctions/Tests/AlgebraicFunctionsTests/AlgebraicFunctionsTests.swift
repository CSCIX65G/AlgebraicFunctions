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
        assertMacroExpansion("", expandedSource: "", macros: [:])
//        assertMacroExpansion(
//            """
//            //#stringify(a + b)
//            """,
//            expandedSource: """
//            //(a + b, "a + b")
//            """,
//            macros: testMacros
//        )
    }
}
