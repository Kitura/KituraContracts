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

class StringExtensionsTests: XCTestCase {

    static var allTests: [(String, (StringExtensionsTests) -> () throws -> Void)] {
        return [
            ("testStringExtensions", testStringExtensions)
        ]
    }

    func testStringExtensions() {
        let fm = DateFormatter()
        fm.locale = Locale(identifier: "en_US_POSIX")
        fm.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        fm.timeZone = TimeZone(secondsFromGMT: 0)

        let d1 = fm.string(from: Date())
        let d2 = fm.string(from: Date())
        let d3 = fm.string(from: Date())

        /// Assert object string -> T conversion
        XCTAssertEqual("string".string, "string")
        XCTAssertEqual("1".int, Int(1))
        XCTAssertEqual("1".int8, Int8(1))
        XCTAssertEqual("1".int16, Int16(1))
        XCTAssertEqual("1".int32, Int32(1))
        XCTAssertEqual("1".int64, Int64(1))
        XCTAssertEqual("2".uInt, UInt(2))
        XCTAssertEqual("2".uInt8, UInt8(2))
        XCTAssertEqual("2".uInt16, UInt16(2))
        XCTAssertEqual("2".uInt32, UInt32(2))
        XCTAssertEqual("2".uInt64, UInt64(2))
        XCTAssertEqual("3.0".double, Double(3.0))
        XCTAssertEqual("4.0".float, Float(4.0))
        XCTAssertEqual("true".boolean, true)
        XCTAssertEqual(d1.date(fm), fm.date(from: d1))

        let strArray = "string1,string2,string3"
        let intArray = "1,2,3"
        let pointIntArray = "1.0,2.0,3.0"

        /// Assert object array string -> [T] conversion
        XCTAssertEqual(strArray.stringArray, ["string1", "string2", "string3"])
        XCTAssertEqual(intArray.intArray!, [Int(1), Int(2), Int(3)])
        XCTAssertEqual(intArray.int8Array!, [Int8(1), Int8(2), Int8(3)])
        XCTAssertEqual(intArray.int16Array!, [Int16(1), Int16(2), Int16(3)])
        XCTAssertEqual(intArray.int32Array!, [Int32(1), Int32(2), Int32(3)])
        XCTAssertEqual(intArray.int64Array!, [Int64(1), Int64(2), Int64(3)])
        XCTAssertEqual(intArray.uIntArray!, [UInt(1), UInt(2), UInt(3)])
        XCTAssertEqual(intArray.uInt8Array!, [UInt8(1), UInt8(2), UInt8(3)])
        XCTAssertEqual(intArray.uInt16Array!, [UInt16(1), UInt16(2), UInt16(3)])
        XCTAssertEqual(intArray.uInt32Array!, [UInt32(1), UInt32(2), UInt32(3)])
        XCTAssertEqual(intArray.uInt64Array!, [UInt64(1), UInt64(2), UInt64(3)])
        XCTAssertEqual(pointIntArray.doubleArray!, [Double(1.0), Double(2.0), Double(3.0)])
        XCTAssertEqual(pointIntArray.floatArray!, [Float(1.0), Float(2.0), Float(3.0)])
        XCTAssertEqual("true,false,true".booleanArray!, [true, false, true])
        XCTAssertEqual("\(d1),\(d2),\(d3)".dateArray(fm)!, [fm.date(from: d1)!, fm.date(from: d2)!, fm.date(from: d3)!])
    }
}
