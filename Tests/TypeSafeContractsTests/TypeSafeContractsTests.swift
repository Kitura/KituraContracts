import XCTest
@testable import TypeSafeContracts

class TypeSafeContractsTests: XCTestCase {
     static var allTests = [
        ("testStringIdentifier", testStringIdentifier),
    ]

    func testStringIdentifier() {
        let strId = "123456"
        let identifier1: Identifier = String(strId)
        XCTAssertEqual(strId,  identifier1.value)

        let identifier2: Identifier = String(value: strId)
        XCTAssertEqual(strId,  identifier2.value)

        guard let strId2 = identifier2 as? String else {
            XCTFail("Failed to cast to concrete type: String")
            return
        }        
        XCTAssertEqual(strId, strId2)
    }

    func testIntIdentifier() {
        let strId = "123456"
        guard let identifier: Identifier = try? IntId(value: strId) else {
            XCTFail("Failed to create an Int identifier!")
            return
        }        
        XCTAssertEqual(strId,  identifier.value)

        guard let intIdentifier = identifier as? IntId else {
            XCTFail("Failed to cast to concrete type: IntId")
            return
        }
        XCTAssertEqual(123456,  intIdentifier.id)
    }
}
