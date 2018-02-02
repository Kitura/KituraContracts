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
        ("testConstantRequestErrorHasExpectedErrorCodeAndReason", testConstantRequestErrorHasExpectedErrorCodeAndReason),
        ("testRequestErrorEquality", testRequestErrorEquality),
        ("testRequestErrorCanBeUsedWithSwitch", testRequestErrorCanBeUsedWithSwitch),
        ("testRequestErrorCreatedWithHTTPCodeMatchesEquivalentConstant", testRequestErrorCreatedWithHTTPCodeMatchesEquivalentConstant),
        ("testRequestErrorCreatedWithCustomHTTPCodeHasExpectedErrorCodeAndReason", testRequestErrorCreatedWithCustomHTTPCodeHasExpectedErrorCodeAndReason),
        ("testRequestErrorCreatedWithCustomRawCodeHasExpectedErrorCodeAndReason", testRequestErrorCreatedWithCustomRawCodeHasExpectedErrorCodeAndReason),
        ("testRequestErrorWithBodyHasExpectedErrorCodeAndReason", testRequestErrorWithBodyHasExpectedErrorCodeAndReason),
        ("testRequestErrorWithBodyReturnsCorrectBodyData", testRequestErrorWithBodyReturnsCorrectBodyData),
        ("testRequestErrorWithoutBodyReturnsNilBodyData", testRequestErrorWithoutBodyReturnsNilBodyData),
        ("testRequestErrorWithoutBodyOrBodyDataReturnsNilBodyData", testRequestErrorWithoutBodyOrBodyDataReturnsNilBodyData),
        ("testRequestErrorWithBodyThatCannotBeEncodedThrowsEncodingError", testRequestErrorWithBodyThatCannotBeEncodedThrowsEncodingError),
        ("testRequestErrorWithBodyDataHasExpectedErrorCodeAndReason", testRequestErrorWithBodyDataHasExpectedErrorCodeAndReason),
        ("testRequestErrorWithBodyDataReturnsCorrectBodyObject", testRequestErrorWithBodyDataReturnsCorrectBodyObject),
        ("testRequestErrorWithoutBodyDataReturnsNilBody", testRequestErrorWithoutBodyDataReturnsNilBody),
        ("testRequestErrorWithoutBodyOrBodyDataReturnsNilBody", testRequestErrorWithoutBodyOrBodyDataReturnsNilBody),
        ("testRequestErrorWithBodyDataThatCannotBeDecodedThrowsDecodingError", testRequestErrorWithBodyDataThatCannotBeDecodedThrowsDecodingError),
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

    // Test predefined instances of RequestError
    func testConstantRequestErrorHasExpectedErrorCodeAndReason() {
        let error = RequestError.internalServerError
        XCTAssertEqual(500, error.rawValue)
        XCTAssertEqual(500, error.httpCode)
        XCTAssertEqual("Internal Server Error", error.reason)
        XCTAssertEqual("500 : Internal Server Error", error.description)
    }

    // Test RequestError values can be checked for equality
    func testRequestErrorEquality() {
        let errorA = RequestError(httpCode: 500)
        let errorB = RequestError(httpCode: 500)
        let other = RequestError(httpCode: 404)
        XCTAssertEqual(errorA, errorB)
        XCTAssertNotEqual(errorA, other)
    }

    // Test RequestError values can be used with switch statements
    func testRequestErrorCanBeUsedWithSwitch() {
        let error = RequestError.internalServerError
        switch error {
            case .internalServerError:
                break
            default:
                XCTFail("Could not match error type inside switch statement!")
        }
    }

    // Test construction of custom RequestError for http codes
    func testRequestErrorCreatedWithHTTPCodeMatchesEquivalentConstant() {
        let staticError = RequestError.internalServerError
        let error = RequestError(httpCode: staticError.httpCode)
        XCTAssertEqual(staticError.rawValue, error.rawValue)
        XCTAssertEqual(staticError.httpCode, error.httpCode)
        XCTAssertEqual(staticError.description, error.description)
    }

    // Test construction of custom RequestError for unknown http codes
    func testRequestErrorCreatedWithCustomHTTPCodeHasExpectedErrorCodeAndReason() {
        let code = 1500
        let error = RequestError(httpCode: code)
        XCTAssertEqual(code, error.rawValue)
        XCTAssertEqual(code, error.httpCode)
        XCTAssertEqual("http_\(code)", error.reason)
        XCTAssertEqual("\(code) : http_\(code)", error.description)
    }

    // Test construction of custom RequestError for raw codes
    func testRequestErrorCreatedWithCustomRawCodeHasExpectedErrorCodeAndReason() {
        let code = 1500
        let error = RequestError(rawValue: code)
        XCTAssertEqual(code, error.rawValue)
        XCTAssertEqual(code, error.httpCode)
        XCTAssertEqual("error_\(code)", error.reason)
        XCTAssertEqual("\(code) : error_\(code)", error.description)
    }

    // Test construction of error instances with Codable body
    func testRequestErrorWithBodyHasExpectedErrorCodeAndReason() {
        let baseError = RequestError.serviceUnavailable
        let error = RequestError(baseError, body: Status(value: .BROKEN))
        XCTAssertEqual(baseError.rawValue, error.rawValue)
        XCTAssertEqual(baseError.httpCode, error.httpCode)
        XCTAssertEqual(baseError.reason, error.reason)
        XCTAssertEqual(baseError.description, error.description)
    }

    // Test error instances created with Codable body can be encoded to Data
    func testRequestErrorWithBodyReturnsCorrectBodyData() throws {
        let customErrorBody = Status(value: .BROKEN)
        let customErrorBodyData = try JSONEncoder().encode(customErrorBody)
        let error = RequestError(.serviceUnavailable, body: customErrorBody)
        XCTAssertNoThrow(try error.bodyData(.json))

        let bodyData = (try? error.bodyData(.json)) ?? nil
        XCTAssertNotNil(bodyData)
        if let bodyData = bodyData {
            XCTAssertEqual(customErrorBodyData, bodyData)
        }
    }

    // Test that bodyData() returns nil if RequestError not created with
    // `RequestError.init(_:body)`
    func testRequestErrorWithoutBodyReturnsNilBodyData() throws {
        let customErrorBodyData = try JSONEncoder().encode(Status(value: .BROKEN))
        let error = try RequestError(.serviceUnavailable, bodyData: customErrorBodyData, format: .json)
        XCTAssertNoThrow(try error.bodyData(.json))
        XCTAssertNil(try error.bodyData(.json))
    }

    // Test that bodyData() returns nil if error has no body
    func testRequestErrorWithoutBodyOrBodyDataReturnsNilBodyData() {
        let error = RequestError.serviceUnavailable
        XCTAssertNil(try error.bodyData(.json))
    }

    // Check bodyData() throws EncodingError if Codable object cannot be
    // encoded
    func testRequestErrorWithBodyThatCannotBeEncodedThrowsEncodingError() throws {
        let bogusBody = "Codable but not encodable to JSON"
        let error = RequestError(.serviceUnavailable, body: bogusBody)
        XCTAssertThrowsError(try error.bodyData(.json)) { XCTAssert($0 is EncodingError, "threw error: \($0)") }
    }

    // Test construction of error instances with body data
    func testRequestErrorWithBodyDataHasExpectedErrorCodeAndReason() throws {
        let baseError = RequestError.serviceUnavailable
        let customErrorBodyData = try JSONEncoder().encode(Status(value: .BROKEN))
        let error = try RequestError(baseError, bodyData: customErrorBodyData, format: .json)
        XCTAssertEqual(baseError.rawValue, error.rawValue)
        XCTAssertEqual(baseError.httpCode, error.httpCode)
        XCTAssertEqual(baseError.reason, error.reason)
        XCTAssertEqual(baseError.description, error.description)
    }

    // Test error instances created with body data can be decoded to a Codable
    // object (with the correct type)
    func testRequestErrorWithBodyDataReturnsCorrectBodyObject() throws {
        let customErrorBody = Status(value: .BROKEN)
        let customErrorBodyData = try JSONEncoder().encode(customErrorBody)
        let error = try RequestError(.serviceUnavailable, bodyData: customErrorBodyData, format: .json)
        XCTAssertNoThrow(try error.bodyAs(Status.self))

        let body = (try? error.bodyAs(Status.self)) ?? nil
        XCTAssertNotNil(body)
        if let errorBody = body {
            XCTAssertEqual(errorBody, customErrorBody)
        }
    }

    // Test that bodyAs() returns nil if RequestError not created with
    // `RequestError.init(_:bodyData:format:)`
    func testRequestErrorWithoutBodyDataReturnsNilBody() {
        let error = RequestError(.serviceUnavailable, body: Status(value: .BROKEN))
        XCTAssertNoThrow(try error.bodyAs(Status.self))
        XCTAssertNil(try error.bodyAs(Status.self))
    }

    // Test that bodyAs() returns nil if error has no body
    func testRequestErrorWithoutBodyOrBodyDataReturnsNilBody() {
        let error = RequestError.serviceUnavailable
        XCTAssertNil(try error.bodyAs(Status.self))
    }

    // Test that bodyAs() throws DecodingError if Data cannot be decoded
    func testRequestErrorWithBodyDataThatCannotBeDecodedThrowsDecodingError() throws {
        let bogusData = "{\"bogus\": \"because schema doesn't match Status object\"}".data(using: .utf8)!
        let error = try RequestError(.serviceUnavailable, bodyData: bogusData, format: .json)
        XCTAssertThrowsError(try error.bodyAs(Status.self)) { XCTAssert($0 is DecodingError, "threw error: \($0)") }
    }
}
