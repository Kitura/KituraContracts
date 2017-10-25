/**
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import XCTest
@testable import KituraContracts

class KituraContractsTests: XCTestCase {
     static var allTests = [
        ("testStringIdentifier", testStringIdentifier),
        ("testIntIdentifier", testIntIdentifier),
//        ("testTypeComputation", testTypeComputation),
        ("testRequestError", testRequestError)
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
        guard let identifier: Identifier = try? Int(value: strId) else {
            XCTFail("Failed to create an Int identifier!")
            return
        }
        XCTAssertEqual(strId,  identifier.value)

        guard let intIdentifier = identifier as? Int else {
            XCTFail("Failed to cast to concrete type: Int")
            return
        }
        XCTAssertEqual(123456,  intIdentifier)
    }

//    func testTypeComputation() {
//        XCTAssertEqual(User.type, "User")
//        XCTAssertEqual(User.typeLowerCased, "user")
//        XCTAssertEqual(User.route, "/users")
//    }

    func testRequestError() {
        var errorCode = 500
        var reason = "Internal Server Error"
        var error = RequestError.internalServerError
        XCTAssertEqual(errorCode, error.rawValue)
        XCTAssertEqual(errorCode, error.httpCode)
        XCTAssertEqual(reason, error.reason)
        XCTAssertEqual("\(errorCode) : \(reason)", error.description)

        errorCode = 1500
        reason = "http_\(errorCode)"
        error = RequestError(httpCode: errorCode)
        XCTAssertEqual(errorCode, error.rawValue)
        XCTAssertEqual(errorCode, error.httpCode)
        XCTAssertEqual(reason, error.reason)
        XCTAssertEqual("\(errorCode) : \(reason)", error.description)
     }
}
