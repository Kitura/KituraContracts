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

class QueryCoderTests: XCTestCase {

    static var allTests: [(String, (QueryCoderTests) -> () throws -> Void)] {
        return [
            ("testQueryDecoder", testQueryDecoder),
            ("testQueryEncoder", testQueryEncoder),
            ("testCycle", testCycle),
            ("testIllegalInt", testIllegalInt)
        ]
    }

    struct SimpleStruct: QueryParams, Equatable {
      let intField: Int
      public static func ==(lhs: SimpleStruct, rhs: SimpleStruct) -> Bool {
          return lhs.intField == rhs.intField
      }
    }

    struct MyInts: QueryParams, Equatable {
        let intField: Int
        let int8Field: Int8
        let int16Field: Int16
        let int32Field: Int32
        let int64Field: Int64
        let uintField: UInt
        let uint8Field: UInt8
        let uint16Field: UInt16
        let uint32Field: UInt32
        let uint64Field: UInt64

        public static func ==(lhs: MyInts, rhs: MyInts) -> Bool {
            return  lhs.intField == rhs.intField &&
                    lhs.int8Field == rhs.int8Field &&
                    lhs.int16Field == rhs.int16Field &&
                    lhs.int32Field == rhs.int32Field &&
                    lhs.int64Field == rhs.int64Field &&
                    lhs.uintField == rhs.uintField &&
                    lhs.uint8Field == rhs.uint8Field &&
                    lhs.uint16Field == rhs.uint16Field &&
                    lhs.uint32Field == rhs.uint32Field &&
                    lhs.uint64Field == rhs.uint64Field
        }
    }

    struct MyIntArrays: QueryParams, Equatable {
        let intField: [Int]
        let int8Field: [Int8]
        let int16Field: [Int16]
        let int32Field: [Int32]
        let int64Field: [Int64]
        let uintField: [UInt]
        let uint8Field: [UInt8]
        let uint16Field: [UInt16]
        let uint32Field: [UInt32]
        let uint64Field: [UInt64]

        public static func ==(lhs: MyIntArrays, rhs: MyIntArrays) -> Bool {
            return  lhs.intField == rhs.intField &&
                lhs.int8Field == rhs.int8Field &&
                lhs.int16Field == rhs.int16Field &&
                lhs.int32Field == rhs.int32Field &&
                lhs.int64Field == rhs.int64Field &&
                lhs.uintField == rhs.uintField &&
                lhs.uint8Field == rhs.uint8Field &&
                lhs.uint16Field == rhs.uint16Field &&
                lhs.uint32Field == rhs.uint32Field &&
                lhs.uint64Field == rhs.uint64Field
        }
    }

    struct MyQuery: QueryParams, Equatable {
        public let intField: Int
        public let optionalIntField: Int?
        public let stringField: String
        public let intArray: [Int]
        public let dateField: Date
        public let optionalDateField: Date?
        public let nested: Nested

        public static func ==(lhs: MyQuery, rhs: MyQuery) -> Bool {
            return  lhs.intField == rhs.intField &&
                    lhs.optionalIntField == rhs.optionalIntField &&
                    lhs.stringField == rhs.stringField &&
                    lhs.intArray == rhs.intArray &&
                    lhs.dateField == rhs.dateField &&
                    lhs.optionalDateField == rhs.optionalDateField &&
                    lhs.nested == rhs.nested
        }
    }

    struct Nested: Codable, Equatable {
        public let nestedIntField: Int
        public let nestedStringField: String

        public static func ==(lhs: Nested, rhs: Nested) -> Bool {
            return lhs.nestedIntField == rhs.nestedIntField && lhs.nestedStringField == rhs.nestedStringField
        }
    }

    let expectedDict = ["intField": "23", "stringField": "a string", "intArray": "1,2,3", "dateField": "2017-10-31T16:15:56+0000", "optionalDateField": "2017-10-31T16:15:56+0000", "nested": "{\"nestedIntField\":333,\"nestedStringField\":\"nested string\"}" ]

    let expectedQueryString = "?intArray=1%2C2%2C3&stringField=a%20string&intField=23&dateField=2017-12-07T21:42:06%2B0000&nested=%7B\"nestedStringField\":\"nested%20string\"%2C\"nestedIntField\":333%7D"

    let expectedDateStr = "2017-10-31T16:15:56+0000"
    let expectedDate = Coder().dateFormatter.date(from: "2017-10-31T16:15:56+0000")!

    let expectedMyQuery = MyQuery(intField: 23,
                                  optionalIntField: nil,
                                  stringField: "a string",
                                  intArray: [1, 2, 3],
                                  dateField: Coder().dateFormatter.date(from: "2017-10-31T16:15:56+0000")!,
                                  optionalDateField: Coder().dateFormatter.date(from: "2017-10-31T16:15:56+0000")!,
                                  nested: Nested(nestedIntField: 333, nestedStringField: "nested string"))

    func testQueryDecoder() {
        guard let query = try? QueryDecoder(dictionary: expectedDict).decode(MyQuery.self) else {
            XCTFail("Failed to decode query to MyQuery Object")
            return
        }

        XCTAssertEqual(query, expectedMyQuery)

    }

    func testQueryEncoder() {

        let query = MyQuery(intField: -1, optionalIntField: 282, stringField: "a string", intArray: [1, -1, 3], dateField: expectedDate, optionalDateField: expectedDate, nested: Nested(nestedIntField: 333, nestedStringField: "nested string"))

        let myInts = SimpleStruct(intField: 1)

        guard let myQueryDict: [String: String] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to [String: String]")
            return
        }

        guard let myQueryStr: String = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        guard let myURLQueryItems: [URLQueryItem] = try? QueryEncoder().encode(myInts) else {
            XCTFail("Failed to encode query to String")
            return
        }

        let queryItems = [ URLQueryItem(name: "intField", value: "1") ]
        XCTAssertEqual(queryItems, myURLQueryItems)

        XCTAssertEqual(myQueryDict["intField"], "-1")
        XCTAssertEqual(myQueryDict["optionalIntField"], "282")
        XCTAssertEqual(myQueryDict["stringField"], "a string")
        XCTAssertEqual(myQueryDict["intArray"], "1,-1,3")
        XCTAssertEqual(myQueryDict["dateField"], expectedDateStr)
        XCTAssertEqual(myQueryDict["optionalDateField"], expectedDateStr)

        /// Ordering of encoded JSON is differnt on Darwin and Linux
        XCTAssert(myQueryDict["nested"] == "{\"nestedStringField\":\"nested string\",\"nestedIntField\":333}" ||
                  myQueryDict["nested"] == "{\"nestedIntField\":333,\"nestedStringField\":\"nested string\"}"
        )

        func createDict(_ str: String) -> [String: String] {
            return myQueryStr.components(separatedBy: "&").reduce([String: String]()) { acc, val in
                var acc = acc
                let split = val.components(separatedBy: "=")
                acc[split[0]] = split[1]
                return acc
            }
        }
        let myQueryStrSplit1: [String: String] = createDict(myQueryStr)
        let myQueryStrSplit2: [String: String] = createDict(expectedQueryString)

        XCTAssertEqual(myQueryStrSplit1["intField"], myQueryStrSplit2["intField"])
        XCTAssertEqual(myQueryStrSplit1["optionalIntField"], myQueryStrSplit2["optionalIntField"])
        XCTAssertEqual(myQueryStrSplit1["stringField"], myQueryStrSplit2["stringField"])
        XCTAssertEqual(myQueryStrSplit1["intArray"], myQueryStrSplit2["intArray"])
        XCTAssertEqual(myQueryStrSplit1["dateField"], myQueryStrSplit2["dateField"])
        XCTAssertEqual(myQueryStrSplit1["optionalDateField"], myQueryStrSplit2["optionalDateField"])
        XCTAssertEqual(myQueryStrSplit1["nested"], myQueryStrSplit2["nested"])

    }

    func testCycle() {
        let myInts = MyInts(intField: 1, int8Field: 2, int16Field: 3, int32Field: 4, int64Field: 5, uintField: 6, uint8Field: 7, uint16Field: 8, uint32Field: 9, uint64Field: 10)
        let myIntArrays = MyIntArrays(intField: [1,2,3],
                                 int8Field: [3,4,5],
                                 int16Field: [6,7,8],
                                 int32Field: [9,10,11],
                                 int64Field: [12,13,14],
                                 uintField: [15,16,17],
                                 uint8Field: [18,19,20],
                                 uint16Field: [21,22,23],
                                 uint32Field: [24,25,26],
                                 uint64Field: [27,28,29])
        cycleTester(expectedMyQuery)
        cycleTester(myInts)
        cycleTester(myIntArrays)
    }

    func testIllegalInt() {
        let outOfBoundsDict = ["int8Field": "128", /// Out of bounds
                              "uintField": "6", "uint8Field": "7", "intField": "1", "uint64Field": "10", "int32Field": "4",
                              "int64Field": "5", "int16Field": "3", "uint32Field": "9", "uint16Field": "8"]

        let negativeDict = ["int8Field": "1", "uintField": "-1", // Can't be negative
                            "uint8Field": "255", "intField": "1", "uint64Field": "10", "int32Field": "4",
                            "int64Field": "5", "int16Field": "3", "uint32Field": "9", "uint16Field": "8"]

        malformedDictTester(outOfBoundsDict)
        malformedDictTester(negativeDict)
    }

    private func malformedDictTester(_ dict: [String: String]) {
        guard let _ = try? QueryDecoder(dictionary: dict).decode(MyInts.self) else {
            return
        }

        XCTFail("Decoded a malformed dictionary to codable object")
    }

    private func cycleTester<T: QueryParams&Equatable>(_ obj: T) {

        guard let myQueryDict: [String : String] = try? QueryEncoder().encode(obj) else {
            XCTFail("Failed to encode query to [String: String]")
            return
        }

        guard let myQuery2 = try? QueryDecoder(dictionary: myQueryDict).decode(T.self) else {
            XCTFail("Failed to decode query to MyQuery object")
            return
        }

        XCTAssertEqual(myQuery2, obj)
    }
}
