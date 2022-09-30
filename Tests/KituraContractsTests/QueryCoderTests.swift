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

@available(OSX 10.12, *)
class QueryCoderTests: XCTestCase {

    static var allTests: [(String, (QueryCoderTests) -> () throws -> Void)] {
        return [
            ("testQueryDecoder", testQueryDecoder),
            ("testQueryEncoder", testQueryEncoder),
            ("test1970Decode", test1970Decode),
            ("test1970Encode", test1970Encode),
            ("testISODecode", testISODecode),
            ("testISOEncode", testISOEncode),
            ("testCustomDecode", testCustomDecode),
            ("testCustomEncode", testCustomEncode),
            ("testFormattedDecode", testFormattedDecode),
            ("testFormattedEncode", testFormattedEncode),
            ("testCustomArrayDecode", testCustomArrayDecode),
            ("testCustomArrayEncode", testCustomArrayEncode),
            ("testCycle", testCycle),
            ("testIllegalInt", testIllegalInt),
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
        public let boolField: Bool
        public let intField: Int
        public let optionalIntField: Int?
        public let stringField: String
        public let emptyStringField: String
        public let optionalStringField: String?
        public let intArray: [Int]
        public let dateField: Date
        public let optionalDateField: Date?
        public let nested: Nested

        public static func ==(lhs: MyQuery, rhs: MyQuery) -> Bool {
            return  lhs.boolField == rhs.boolField &&
                    lhs.intField == rhs.intField &&
                    lhs.optionalIntField == rhs.optionalIntField &&
                    lhs.stringField == rhs.stringField &&
                    lhs.emptyStringField == rhs.emptyStringField &&
                    lhs.optionalStringField == rhs.optionalStringField &&
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

    struct MyFilters: QueryParams, Equatable {
        public let greaterThan: GreaterThan<Int>
        public let greaterThanOrEqual: GreaterThanOrEqual<Int>
        public let lowerThan: LowerThan<Double>
        public let lowerThanOrEqual: LowerThanOrEqual<Double>
        public let inclusiveRange: InclusiveRange<UInt>
        public let exclusiveRange: ExclusiveRange<UInt>
        public let ordering: Ordering
        public let pagination: Pagination

        public static func ==(lhs: MyFilters, rhs: MyFilters) -> Bool {
            return  lhs.greaterThan.getValue() == rhs.greaterThan.getValue() &&
                    lhs.greaterThanOrEqual.getValue() == rhs.greaterThanOrEqual.getValue() &&
                    lhs.lowerThan.getValue() == rhs.lowerThan.getValue() &&
                    lhs.lowerThanOrEqual.getValue() == rhs.lowerThanOrEqual.getValue() &&
                    lhs.inclusiveRange.getValue() == rhs.inclusiveRange.getValue() &&
                    lhs.exclusiveRange.getValue() == rhs.exclusiveRange.getValue() &&
                    lhs.ordering.getStringValue() == rhs.ordering.getStringValue() &&
                    lhs.pagination.getStringValue() == rhs.pagination.getStringValue()
        }
    }

    struct Query1970: QueryParams, Equatable {
        public let dateField: Date
        static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970
        static let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .secondsSince1970
        public static func ==(lhs: Query1970, rhs: Query1970) -> Bool {
            return lhs.dateField == rhs.dateField
        }
    }

    struct QueryISO: QueryParams, Equatable {
        public let dateField: Date
        static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
        static let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
        public static func ==(lhs: QueryISO, rhs: QueryISO) -> Bool {
            return lhs.dateField == rhs.dateField
        }
    }

    struct QueryCustom: QueryParams, Equatable {
        public let dateField: Date
        static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .custom { decoder in
            // pull out the number of days from Codable
            let container = try decoder.singleValueContainer()
            let numberOfDays = try container.decode(Int.self)

            // create a start date of Jan 1st 1970, then a DateComponents instance for our JSON days
            let startDate = Date(timeIntervalSince1970: 0)
            var components = DateComponents()
            components.day = numberOfDays

            // create a Calendar and use it to measure the difference between the two
            let calendar = Calendar(identifier: .gregorian)
            return calendar.date(byAdding: components, to: startDate) ?? Date()
        }
        static let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .custom { (date, encoder) in

            let calendar = Calendar(identifier: .gregorian)
            let startDate = Date(timeIntervalSince1970: 0)
            let endDate = date
            let components = calendar.dateComponents([.day], from: startDate, to: endDate)
            let days = components.day
            let intData = Int(days!)
            var container = encoder.singleValueContainer()
            try container.encode(intData)

        }
        public static func ==(lhs: QueryCustom, rhs: QueryCustom) -> Bool {
            return lhs.dateField == rhs.dateField
        }

    }

    class AlternateFormatter {
        public let altFormatter: DateFormatter

        public init() {
            self.altFormatter = DateFormatter()
            self.altFormatter.timeZone = TimeZone(identifier: "UTC")
            self.altFormatter.dateFormat = "yyyy-MM-dd"
        }
    }

    struct QueryFormatted: QueryParams, Equatable {

        public let dateField: Date
        static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .formatted(AlternateFormatter().altFormatter)
        static let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .formatted(AlternateFormatter().altFormatter)
        public static func ==(lhs: QueryFormatted, rhs: QueryFormatted) -> Bool {
            return lhs.dateField == rhs.dateField
        }
    }

    struct QueryCustomArray: QueryParams, Equatable {

        public let dateField: [Date]
        static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .custom { decoder in
            // pull out the number of days from Codable
            let container = try decoder.singleValueContainer()
            let numberOfDaysArray = try container.decode([Int].self)
            let numberOfDays = numberOfDaysArray[0]

            // create a start date of Jan 1st 1970, then a DateComponents instance for our JSON days
            let startDate = Date(timeIntervalSince1970: 0)
            var components = DateComponents()
            components.day = numberOfDays

            // create a Calendar and use it to measure the difference between the two
            let calendar = Calendar(identifier: .gregorian)
            return calendar.date(byAdding: components, to: startDate) ?? Date()
        }
        static let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .custom { (date, encoder) in

            let calendar = Calendar(identifier: .gregorian)
            let startDate = Date(timeIntervalSince1970: 0)
            let endDate = date
            let components = calendar.dateComponents([.day], from: startDate, to: endDate)
            let days = components.day
            let intData = Int(days!)
            var container = encoder.singleValueContainer()
            try container.encode(intData)

        }
        public static func ==(lhs: QueryCustomArray, rhs: QueryCustomArray) -> Bool {
            return lhs.dateField == rhs.dateField
        }
    }

    let expectedDict = ["boolField": "true", "intField": "23", "stringField": "a string", "emptyStringField": "", "optionalStringField": "", "intArray": "1,2,3", "dateField": "2017-10-31T16:15:56+0000", "optionalDateField": "", "nested": "{\"nestedIntField\":333,\"nestedStringField\":\"nested string\"}" ]

    let expectedQueryString = "?boolField=true&intArray=1%2C2%2C3&stringField=a%20string&emptyStringField=&optionalStringField=&intField=23&dateField=2017-10-31T16:15:56%2B0000&nested=%7B\"nestedStringField\":\"nested%20string\"%2C\"nestedIntField\":333%7D"
    
    var expectedData: Data {
        let droppedQuestionMark = String(expectedQueryString.dropFirst())
        return droppedQuestionMark.data(using: .utf8)!
    }

    let expectedDateStr = "2017-10-31T16:15:56+0000"
    let expectedDate = Coder.defaultDateFormatter.date(from: "2017-10-31T16:15:56+0000")!

    let expectedMyQuery = MyQuery(boolField: true,
                                  intField: 23,
                                  optionalIntField: nil,
                                  stringField: "a string",
                                  emptyStringField: "",
                                  optionalStringField: nil,
                                  intArray: [1, 2, 3],
                                  dateField: Coder.defaultDateFormatter.date(from: "2017-10-31T16:15:56+0000")!,
                                  optionalDateField: nil,
                                  nested: Nested(nestedIntField: 333, nestedStringField: "nested string"))

    let expectedFiltersDict = ["greaterThan": "8", "greaterThanOrEqual": "10", "lowerThan": "7.0", "lowerThanOrEqual": "12.0", "inclusiveRange": "0,5", "exclusiveRange": "4,15", "ordering": "asc(name),desc(age)", "pagination": "8,14"]
    let expectedQueryFiltersString = "?greaterThan=8&greaterThanOrEqual=10&lowerThan=7.0&lowerThanOrEqual=12.0&inclusiveRange=0,5&exclusiveRange=4,15&ordering=asc(name),desc(age)&pagination=8,14"

    let expectedFilterQuery = MyFilters(
      greaterThan: GreaterThan(value: 8),
      greaterThanOrEqual: GreaterThanOrEqual(value: 10),
      lowerThan: LowerThan(value: 7.0),
      lowerThanOrEqual: LowerThanOrEqual(value: 12.0),
      inclusiveRange: InclusiveRange(start: 0, end: 5),
      exclusiveRange: ExclusiveRange(start: 4, end: 15),
      ordering: Ordering(by: .asc("name"), .desc("age")),
      pagination: Pagination(start: 8, size: 14)
    )

    let expected1970Dict = ["dateField": "1567684372.1"]
    let expected1970String = "?dateField=1567684372.1"
    var expectedData1970: Data {
        let droppedQuestionMark = String(expected1970String.dropFirst())
        return droppedQuestionMark.data(using: .utf8)!
        }
    let expected1970DateStr = "1567684372.1"
    let expected1970Date = Date(timeIntervalSince1970: 1567684372.1)
    let expectedQuery1970 = Query1970(dateField: Date(timeIntervalSince1970: 1567684372.1))

    let expectedISODict = ["dateField": "2019-09-06T10:14:41+0000"]
    let expectedISOString = "?dateField=2019-09-06T10:14:41%2B0000"
    var expectedDataISO: Data {
        let droppedQuestionMark = String(expectedISOString.dropFirst())
        return droppedQuestionMark.data(using: .utf8)!
        }
    let expectedISODateStr = "2019-09-06T10:14:41+0000"
    let expectedISODate = _iso8601Formatter.date(from: "2019-09-06T10:14:41+0000")
    let expectedQueryISO = QueryISO(dateField: _iso8601Formatter.date(from: "2019-09-06T10:14:41+0000")!)

    let expectedCustomDict = ["dateField": "10650"]
    let expectedCustomString = "?dateField=10650"
    var expectedDataCustom: Data {
        let droppedQuestionMark = String(expectedCustomString.dropFirst())
        return droppedQuestionMark.data(using: .utf8)!
        }
    let expectedCustomDateStr = "10650"
    var expectedCustomDate: Date {
        let numberOfDays = 10650
        let startDate = Date(timeIntervalSince1970: 0)
        var components = DateComponents()
           components.day = numberOfDays
           // create a Calendar and use it to measure the difference between the two
           let calendar = Calendar(identifier: .gregorian)
           return calendar.date(byAdding: components, to: startDate) ?? Date()
    }

    let expectedFormattedDict = ["dateField": "2017-10-31"]
    let expectedFormattedString = "?dateField=2017-10-31"
    var expectedDataFormatted: Data {
        let droppedQuestionMark = String(expectedFormattedString.dropFirst())
        return droppedQuestionMark.data(using: .utf8)!
        }
    let expectedFormattedDateStr = "2017-10-31"
    let expectedFormattedDate = AlternateFormatter().altFormatter.date(from: "2017-10-31")!
    let expectedQueryFormatted = QueryFormatted(dateField: AlternateFormatter().altFormatter.date(from: "2017-10-31")!)

    let expectedCustomArrayDict = ["dateField": "10650,10650,10650"]
    let expectedCustomArrayString = "?dateField=10650%2C10650%2C10650"
    var expectedDataCustomArray: Data {
        let droppedQuestionMark = String(expectedCustomArrayString.dropFirst())
        return droppedQuestionMark.data(using: .utf8)!
        }
    let expectedCustomArrayDateStr = "10650"
    var expectedCustomArrayDate: Date {
        let numberOfDays = 10650
        let startDate = Date(timeIntervalSince1970: 0)
        var components = DateComponents()
           components.day = numberOfDays
           // create a Calendar and use it to measure the difference between the two
           let calendar = Calendar(identifier: .gregorian)
           return calendar.date(byAdding: components, to: startDate) ?? Date()
    }

    func testQueryDecoder() {
        guard let query = try? QueryDecoder(dictionary: expectedDict).decode(MyQuery.self) else {
            XCTFail("Failed to decode query to MyQuery Object")
            return
        }

        XCTAssertEqual(query, expectedMyQuery)

        guard let filterQuery = try? QueryDecoder(dictionary: expectedFiltersDict).decode(MyFilters.self) else {
            XCTFail("Failed to decode query to MyQuery Object")
            return
        }

        XCTAssertEqual(filterQuery, expectedFilterQuery)
        
        guard let dataQuery = try? QueryDecoder().decode(MyQuery.self, from: expectedData.self) else {
            XCTFail("Failed to decode query to MyQuery Object")
            return
        }
        
        XCTAssertEqual(dataQuery, expectedMyQuery)
    }


    func testQueryEncoder() {

        let query = MyQuery(boolField: true, intField: -1, optionalIntField: 282, stringField: "a string", emptyStringField: "", optionalStringField: "", intArray: [1, -1, 3], dateField: expectedDate, optionalDateField: expectedDate, nested: Nested(nestedIntField: 333, nestedStringField: "nested string"))

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
        
        guard let _: Data = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to Data")
            return
        }

        let queryItems = [ URLQueryItem(name: "intField", value: "1") ]
        XCTAssertEqual(queryItems, myURLQueryItems)

        XCTAssertEqual(myQueryDict["boolField"], "true")
        XCTAssertEqual(myQueryDict["intField"], "-1")
        XCTAssertEqual(myQueryDict["optionalIntField"], "282")
        XCTAssertEqual(myQueryDict["stringField"], "a string")
        XCTAssertEqual(myQueryDict["emptyStringField"], "")
        XCTAssertEqual(myQueryDict["optionalStringField"], "")
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

        XCTAssertEqual(myQueryStrSplit1["boolField"], myQueryStrSplit2["boolField"])
        XCTAssertEqual(myQueryStrSplit1["intField"], myQueryStrSplit2["intField"])
        XCTAssertEqual(myQueryStrSplit1["optionalIntField"], myQueryStrSplit2["optionalIntField"])
        XCTAssertEqual(myQueryStrSplit1["stringField"], myQueryStrSplit2["stringField"])
        XCTAssertEqual(myQueryStrSplit1["intArray"], myQueryStrSplit2["intArray"])
        XCTAssertEqual(myQueryStrSplit1["dateField"], myQueryStrSplit2["dateField"])
        XCTAssertEqual(myQueryStrSplit1["optionalDateField"], myQueryStrSplit2["optionalDateField"])
        XCTAssertEqual(myQueryStrSplit1["nested"], myQueryStrSplit2["nested"])

        let filterQuery = MyFilters(
          greaterThan: GreaterThan(value: 8),
          greaterThanOrEqual: GreaterThanOrEqual(value: 10),
          lowerThan: LowerThan(value: 7.0),
          lowerThanOrEqual: LowerThanOrEqual(value: 12.0),
          inclusiveRange: InclusiveRange(start: 0, end: 5),
          exclusiveRange: ExclusiveRange(start: 4, end: 15),
          ordering: Ordering(by: .asc("name"), .desc("age")),
          pagination: Pagination(start: 8, size: 14)
        )

        guard let myFilterQueryDict: [String: String] = try? QueryEncoder().encode(filterQuery) else {
            XCTFail("Failed to encode query to [String: String]")
            return
        }

        guard let myFilterQueryStr: String = try? QueryEncoder().encode(filterQuery) else {
            XCTFail("Failed to encode query to String")
            return
        }

        XCTAssertEqual(myFilterQueryDict["greaterThan"], "8")
        XCTAssertEqual(myFilterQueryDict["greaterThanOrEqual"], "10")
        XCTAssertEqual(myFilterQueryDict["lowerThan"], "7.0")
        XCTAssertEqual(myFilterQueryDict["lowerThanOrEqual"], "12.0")
        XCTAssertEqual(myFilterQueryDict["inclusiveRange"], "0,5")
        XCTAssertEqual(myFilterQueryDict["exclusiveRange"], "4,15")
        XCTAssertEqual(myFilterQueryDict["ordering"], "asc(name),desc(age)")
        XCTAssertEqual(myFilterQueryDict["pagination"], "8,14")

        let myFilterQueryStrSplit1: [String: String] = createDict(myFilterQueryStr)
        let myFilterQueryStrSplit2: [String: String] = createDict(expectedQueryFiltersString)

        XCTAssertEqual(myFilterQueryStrSplit1["greaterThan"], myFilterQueryStrSplit2["greaterThan"])
        XCTAssertEqual(myFilterQueryStrSplit1["greaterThanOrEqual"], myFilterQueryStrSplit2["greaterThanOrEqual"])
        XCTAssertEqual(myFilterQueryStrSplit1["lowerThan"], myFilterQueryStrSplit2["lowerThan"])
        XCTAssertEqual(myFilterQueryStrSplit1["lowerThanOrEqual"], myFilterQueryStrSplit2["lowerThanOrEqual"])
        XCTAssertEqual(myFilterQueryStrSplit1["inclusiveRange"], myFilterQueryStrSplit2["inclusiveRange"])
        XCTAssertEqual(myFilterQueryStrSplit1["exlusiveRange"], myFilterQueryStrSplit2["exlusiveRange"])
        XCTAssertEqual(myFilterQueryStrSplit1["ordering"], myFilterQueryStrSplit2["ordering"])
        XCTAssertEqual(myFilterQueryStrSplit1["pagination"], myFilterQueryStrSplit2["pagination"])

    }

    func test1970Decode() {

        guard let query = try? QueryDecoder(dictionary: expected1970Dict).decode(Query1970.self) else {
            XCTFail("Failed to decode query to Query1970 Object")
            return
        }

        XCTAssertEqual(query, expectedQuery1970)

        guard let dataQuery = try? QueryDecoder().decode(Query1970.self, from: expectedData1970.self) else {
            XCTFail("Failed to decode query to Query1970 Object")
            return
        }

        XCTAssertEqual(dataQuery, expectedQuery1970)

    }

    func test1970Encode() {

        let query = Query1970(dateField: Date(timeIntervalSince1970: 1567684372.1))

        guard let myQueryDict: [String: String] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to [String: String]")
            return
        }

        XCTAssertEqual(myQueryDict["dateField"], "1567684372.1")

        guard let myQueryStr: String = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        func createDict(_ str: String) -> [String: String] {
            return myQueryStr.components(separatedBy: "&").reduce([String: String]()) { acc, val in
                var acc = acc
                let split = val.components(separatedBy: "=")
                acc[split[0]] = split[1]
                return acc
            }
        }

        let myQueryStrSplit1: [String: String] = createDict(myQueryStr)
        let myQueryStrSplit2: [String: String] = createDict(expected1970String)

        XCTAssertEqual(myQueryStrSplit1["dateField"], myQueryStrSplit2["dateField"])

        guard let myURLQueryItems: [URLQueryItem] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        let queryItems = [ URLQueryItem(name: "dateField", value: "1567684372.1")]
        XCTAssertEqual(queryItems, myURLQueryItems)

    }

    func testISODecode() {

        guard let query = try? QueryDecoder(dictionary: expectedISODict).decode(QueryISO.self) else {
            XCTFail("Failed to decode query to QueryISO Object")
            return
        }

        XCTAssertEqual(query, expectedQueryISO)

        guard let dataQuery = try? QueryDecoder().decode(QueryISO.self, from: expectedDataISO.self) else {
            XCTFail("Failed to decode query to QueryISO Object")
            return
        }

        XCTAssertEqual(dataQuery, expectedQueryISO)

    }

    func testISOEncode() {

        guard let dateString = _iso8601Formatter.date(from: "2019-09-06T10:14:41+0000") else {
            return XCTFail("Date could not be formatted")
        }
        let query = QueryISO(dateField: dateString)

        guard let myQueryDict: [String: String] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to [String: String]")
            return
        }

        XCTAssertEqual(myQueryDict["dateField"], "2019-09-06T10:14:41Z")

        guard let myQueryStr: String = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        func createDict(_ str: String) -> [String: String] {
            return myQueryStr.components(separatedBy: "&").reduce([String: String]()) { acc, val in
                var acc = acc
                let split = val.components(separatedBy: "=")
                acc[split[0]] = split[1]
                return acc
            }
        }

        let myQueryStrSplit1: [String: String] = createDict(myQueryStr)
        let myQueryStrSplit2: [String: String] = createDict(expectedISOString)

        XCTAssertEqual(myQueryStrSplit1["dateField"], myQueryStrSplit2["dateField"])

        guard let myURLQueryItems: [URLQueryItem] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        let queryItems = [ URLQueryItem(name: "dateField", value: "2019-09-06T10:14:41Z")]
        XCTAssertEqual(queryItems, myURLQueryItems)

    }

    func testCustomDecode() {

        let expectedQueryCustom = QueryCustom(dateField: expectedCustomDate)

        guard let query = try? QueryDecoder(dictionary: expectedCustomDict).decode(QueryCustom.self) else {
            XCTFail("Failed to decode query to QueryCustom Object")
            return
        }

        XCTAssertEqual(query, expectedQueryCustom)

        guard let dataQuery = try? QueryDecoder().decode(QueryCustom.self, from: expectedDataCustom.self) else {
            XCTFail("Failed to decode query to QueryCustom Object")
            return
        }

        XCTAssertEqual(dataQuery, expectedQueryCustom)
    }

    func testCustomEncode() {

        let query = QueryCustom(dateField: expectedCustomDate)

        guard let customQueryDict: [String: String] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to [String: String]")
            return
        }

        XCTAssertEqual(customQueryDict["dateField"], "10650")

        guard let customQueryStr: String = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        func createDict(_ str: String) -> [String: String] {
            return customQueryStr.components(separatedBy: "&").reduce([String: String]()) { acc, val in
                var acc = acc
                let split = val.components(separatedBy: "=")
                acc[split[0]] = split[1]
                return acc
            }
        }

        let customQueryStrSplit1: [String: String] = createDict(customQueryStr)
        let customQueryStrSplit2: [String: String] = createDict(expectedCustomString)

        XCTAssertEqual(customQueryStrSplit1["dateField"], customQueryStrSplit2["dateField"])

        guard let customURLQueryItems: [URLQueryItem] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        let queryItems = [ URLQueryItem(name: "dateField", value: "10650")]
        XCTAssertEqual(queryItems, customURLQueryItems)

    }

    func testFormattedDecode() {

        let expectedQueryFormatted = QueryFormatted(dateField: expectedFormattedDate)

        guard let query = try? QueryDecoder(dictionary: expectedFormattedDict).decode(QueryFormatted.self) else {
            XCTFail("Failed to decode query to QueryFormatted Object")
            return
        }

        XCTAssertEqual(query, expectedQueryFormatted)

        guard let dataQuery = try? QueryDecoder().decode(QueryFormatted.self, from: expectedDataFormatted.self) else {
            XCTFail("Failed to decode query to QueryFormatted Object")
            return
        }

        XCTAssertEqual(dataQuery, expectedQueryFormatted)
    }

    func testFormattedEncode() {

        let query = QueryFormatted(dateField: expectedFormattedDate)

        guard let formattedQueryDict: [String: String] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to [String: String]")
            return
        }

        XCTAssertEqual(formattedQueryDict["dateField"], "2017-10-31")

        guard let formattedQueryStr: String = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        func createDict(_ str: String) -> [String: String] {
            return formattedQueryStr.components(separatedBy: "&").reduce([String: String]()) { acc, val in
                var acc = acc
                let split = val.components(separatedBy: "=")
                acc[split[0]] = split[1]
                return acc
            }
        }

        let formattedQueryStrSplit1: [String: String] = createDict(formattedQueryStr)
        let formattedQueryStrSplit2: [String: String] = createDict(expectedFormattedString)

        XCTAssertEqual(formattedQueryStrSplit1["dateField"], formattedQueryStrSplit2["dateField"])

        guard let formattedURLQueryItems: [URLQueryItem] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        let queryItems = [ URLQueryItem(name: "dateField", value: "2017-10-31")]
        XCTAssertEqual(queryItems, formattedURLQueryItems)

    }

    func testCustomArrayDecode() {

        let expectedQueryCustomArray = QueryCustomArray(dateField: [expectedCustomArrayDate,expectedCustomArrayDate,expectedCustomArrayDate])

        guard let query = try? QueryDecoder(dictionary: expectedCustomArrayDict).decode(QueryCustomArray.self) else {
            XCTFail("Failed to decode query to QueryCustomArray Object")
            return
        }

        XCTAssertEqual(query, expectedQueryCustomArray)

        guard let dataQuery = try? QueryDecoder().decode(QueryCustomArray.self, from: expectedDataCustomArray.self) else {
            XCTFail("Failed to decode query to QueryCustomArray Object")
            return
        }

        XCTAssertEqual(dataQuery, expectedQueryCustomArray)
    }

    func testCustomArrayEncode() {

        let query = QueryCustomArray(dateField: [expectedCustomArrayDate,expectedCustomArrayDate,expectedCustomArrayDate])

        guard let customArrayQueryDict: [String: String] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to [String: String]")
            return
        }

        XCTAssertEqual(customArrayQueryDict["dateField"], "10650,10650,10650")

        guard let customArrayQueryStr: String = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        func createDict(_ str: String) -> [String: String] {
            return customArrayQueryStr.components(separatedBy: "&").reduce([String: String]()) { acc, val in
                var acc = acc
                let split = val.components(separatedBy: "=")
                acc[split[0]] = split[1]
                return acc
            }
        }

        let customArrayQueryStrSplit1: [String: String] = createDict(customArrayQueryStr)
        let customArrayQueryStrSplit2: [String: String] = createDict(expectedCustomArrayString)

        XCTAssertEqual(customArrayQueryStrSplit1["dateField"], customArrayQueryStrSplit2["dateField"])

        guard let customURLQueryItems: [URLQueryItem] = try? QueryEncoder().encode(query) else {
            XCTFail("Failed to encode query to String")
            return
        }

        let queryItems = [ URLQueryItem(name: "dateField", value: "10650,10650,10650")]
        XCTAssertEqual(queryItems, customURLQueryItems)

    }

    //This tests the first code example in the QueryParams struct
    func testExample1() {
        struct MyQuery: QueryParams {
           let date: Date
           static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
           static let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
        }

        let queryParams = ["date": "2019-09-06T10:14:41+0000"]

        XCTAssertNoThrow(try QueryDecoder(dictionary: queryParams).decode(MyQuery.self))
    }

    //This tests the second code example in the QueryParams struct
    func testExample2() {
        do {
            struct MyQuery: QueryParams {
                let date: Date
                static let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
                static let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
            }

            let query = MyQuery(date: Date(timeIntervalSinceNow: 0))

            let myQueryDict: [String: String] = try QueryEncoder().encode(query)
            XCTAssertNotNil(myQueryDict["date"])
        } catch {
            XCTFail("\(error)")
        }

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
        dataCycleTester(expectedMyQuery)
        dataCycleTester(myInts)
        dataCycleTester(myIntArrays)
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
    
    private func dataCycleTester<T: QueryParams&Equatable>(_ obj: T) {
        
        guard let myQueryDict: Data = try? QueryEncoder().encode(obj) else {
            XCTFail("Failed to encode query to Data")
            return
        }
        
        guard let myQuery2 = try? QueryDecoder().decode(T.self, from: myQueryDict) else {
            XCTFail("Failed to decode query to MyQuery object")
            return
        }
        
        XCTAssertEqual(myQuery2, obj)
    }
    
}
