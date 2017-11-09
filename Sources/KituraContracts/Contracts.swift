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

// MARK

/**
 An error representing a failed request.
 This definition is intended to be used by both the client side (eg KituraKit)
 and server side (eg Kitura) of the request (typically a HTTP REST request).

 ### Usage Example: ###
 ````
 router.get("/users") { (id: Int, respondWith: (User?, RequestError?) -> Void) in
     ...
     respondWith(nil, RequestError.notFound)
     ...
 }
 ````
 In this example the `RequestError` is used in a Kitura server Codable route handler to
 indicate the request has failed because the requested record was not found.
 */
public struct RequestError: RawRepresentable, Equatable, Hashable, Comparable, Error, CustomStringConvertible {
    public typealias RawValue = Int

    // MARK: Creating a RequestError from a numeric code

    /// Creates an error representing the given error code.
    public init(rawValue: Int) {
        self.rawValue = rawValue
        self.reason = "error_\(rawValue)"
    }

    /// Creates an error representing the given error code and reason string.
    public init(rawValue: Int, reason: String) {
        self.rawValue = rawValue
        self.reason = reason
    }

    /// Creates an error representing a HTTP status code.
    /// - Parameter httpCode: a standard HTTP status code
    /// - Parameter reason: a textual representation of the HTTTP status code.
    public init(httpCode: Int, reason: String) {
        self.init(rawValue: httpCode, reason: reason)
    }

    // MARK: Accessing information about the error type

    /// An error code representing the type of error that has occurred.
    /// The range of error codes from 100 up to 599 are reserved for HTTP status codes.
    /// Custom error codes may be used and must not conflict with this range.
    public let rawValue: Int

    /// A human-readable description of the error code.
    public let reason: String

    /// The HTTP status code for the error.
    /// This value should be a valid HTTP status code if inside the range 100 to 599,
    /// however, it may take a value outside that range when representing other types
    /// of error.
    public var httpCode: Int {
        return rawValue
    }

    // MARK: Comparing RequestErrors

    /// Returns a Boolean value indicating whether the value of the first argument is less than that of the second argument.
    public static func <(lhs: RequestError, rhs: RequestError) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    /// Indicates whether two URLs are the same.
    public static func ==(lhs: RequestError, rhs: RequestError) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    // MARK: Describing a RequestError

    /// A textual description of the error containing the error code and reason.
    public var description: String {
        return "\(rawValue) : \(reason)"
    }

    /// The computed hash value for the error.
    public var hashValue: Int {
        return rawValue
    }

    // MARK: Accessing constants representing HTTP status codes
    /// HTTP code 100 - Continue
    public static let `continue` = RequestError(httpCode: 100, reason: "Continue")
    /// HTTP code 101 - Switching Protocols
    public static let switchingProtocols = RequestError(httpCode: 101, reason: "Switching Protocols")
    /// HTTP code 200 - OK
    public static let ok = RequestError(httpCode: 200, reason: "OK")
    /// HTTP code 201 - Created
    public static let created = RequestError(httpCode: 201, reason: "Created")
    /// HTTP code 202 - Accepted
    public static let accepted = RequestError(httpCode: 202, reason: "Accepted")
    /// HTTP code 203 - Non Authoritative Information
    public static let nonAuthoritativeInformation = RequestError(httpCode: 203, reason: "Non-Authoritative Information")
    /// HTTP code 204 - No Content
    public static let noContent = RequestError(httpCode: 204, reason: "No Content")
    /// HTTP code 205 - Reset Content
    public static let resetContent = RequestError(httpCode: 205, reason: "Reset Content")
    /// HTTP code 206 - Partial Content
    public static let partialContent = RequestError(httpCode: 206, reason: "Partial Content")
    /// HTTP code 207 - Multi Status
    public static let multiStatus = RequestError(httpCode: 207, reason: "Multi-Status")
    /// HTTP code 208 - Already Reported
    public static let alreadyReported = RequestError(httpCode: 208, reason: "Already Reported")
    /// HTTP code 226 - IM Used
    public static let imUsed = RequestError(httpCode: 226, reason: "IM Used")
    /// HTTP code 300 - Multiple Choices           
    public static let multipleChoices = RequestError(httpCode: 300, reason: "Multiple Choices")
    /// HTTP code 301 - Moved Permanently
    public static let movedPermanently = RequestError(httpCode: 301, reason: "Moved Permanently")
    /// HTTP code 302 - Found
    public static let found = RequestError(httpCode: 302, reason: "Found")
    /// HTTP code 303 - See Other
    public static let seeOther = RequestError(httpCode: 303, reason: "See Other")
    /// HTTP code 304 - Not Modified
    public static let notModified = RequestError(httpCode: 304, reason: "Not Modified")
    /// HTTP code 305 - Use Proxy
    public static let useProxy = RequestError(httpCode: 305, reason: "Use Proxy")
    /// HTTP code 307 - Temporary Redirect
    public static let temporaryRedirect = RequestError(httpCode: 307, reason: "Temporary Redirect")
    /// HTTP code 308 - Permanent Redirect
    public static let permanentRedirect = RequestError(httpCode: 308, reason: "Permanent Redirect")
    /// HTTP code 400 - Bad Request
    public static let badRequest = RequestError(httpCode: 400, reason: "Bad Request")
    /// HTTP code 401 - Unauthorized
    public static let unauthorized = RequestError(httpCode: 401, reason: "Unauthorized")
    /// HTTP code 402 - Payment Required
    public static let paymentRequired = RequestError(httpCode: 402, reason: "Payment Required")
    /// HTTP code 403 - Forbidden
    public static let forbidden = RequestError(httpCode: 403, reason: "Forbidden")
    /// HTTP code 404 - Not Found
    public static let notFound = RequestError(httpCode: 404, reason: "Not Found")
    /// HTTP code 405 - Method Not Allowed
    public static let methodNotAllowed = RequestError(httpCode: 405, reason: "Method Not Allowed")
    /// HTTP code 406 - Not Acceptable
    public static let notAcceptable = RequestError(httpCode: 406, reason: "Not Acceptable")
    /// HTTP code 407 - Proxy Authentication Required
    public static let proxyAuthenticationRequired = RequestError(httpCode: 407, reason: "Proxy Authentication Required")
    /// HTTP code 408 - Request Timeout
    public static let requestTimeout = RequestError(httpCode: 408, reason: "Request Timeout")
    /// HTTP code 409 - Conflict
    public static let conflict = RequestError(httpCode: 409, reason: "Conflict")
    /// HTTP code 410 - Gone
    public static let gone = RequestError(httpCode: 410, reason: "Gone")
    /// HTTP code 411 - Length Required
    public static let lengthRequired = RequestError(httpCode: 411, reason: "Length Required")
    /// HTTP code 412 - Precondition Failed
    public static let preconditionFailed = RequestError(httpCode: 412, reason: "Precondition Failed")
    /// HTTP code 413 - Payload Too Large
    public static let payloadTooLarge = RequestError(httpCode: 413, reason: "Payload Too Large")
    /// HTTP code 414 - URI Too Long
    public static let uriTooLong = RequestError(httpCode: 414, reason: "URI Too Long")
    /// HTTP code 415 - Unsupported Media Type
    public static let unsupportedMediaType = RequestError(httpCode: 415, reason: "Unsupported Media Type")
    /// HTTP code 416 - Range Not Satisfiable
    public static let rangeNotSatisfiable = RequestError(httpCode: 416, reason: "Range Not Satisfiable")
    /// HTTP code 417 - Expectation Failed
    public static let expectationFailed = RequestError(httpCode: 417, reason: "Expectation Failed")
    /// HTTP code 421 - Misdirected Request
    public static let misdirectedRequest = RequestError(httpCode: 421, reason: "Misdirected Request")
    /// HTTP code 422 - Unprocessable Entity
    public static let unprocessableEntity = RequestError(httpCode: 422, reason: "Unprocessable Entity")
    /// HTTP code 423 - Locked
    public static let locked = RequestError(httpCode: 423, reason: "Locked")
    /// HTTP code 424 - Failed Dependency
    public static let failedDependency = RequestError(httpCode: 424, reason: "Failed Dependency")
    /// HTTP code 426 - Upgrade Required
    public static let upgradeRequired = RequestError(httpCode: 426, reason: "Upgrade Required")
    /// HTTP code 428 - Precondition Required
    public static let preconditionRequired = RequestError(httpCode: 428, reason: "Precondition Required")
    /// HTTP code 429 - Too Many Requests
    public static let tooManyRequests = RequestError(httpCode: 429, reason: "Too Many Requests")
    /// HTTP code 431 - Request Header Fields Too Large
    public static let requestHeaderFieldsTooLarge = RequestError(httpCode: 431, reason: "Request Header Fields Too Large")
    /// HTTP code 451 - Unavailable For Legal Reasons
    public static let unavailableForLegalReasons = RequestError(httpCode: 451, reason: "Unavailable For Legal Reasons")
    /// HTTP code 500 - Internal Server Error
    public static let internalServerError = RequestError(httpCode: 500, reason: "Internal Server Error")
    /// HTTP code 501 - Not Implemented
    public static let notImplemented = RequestError(httpCode: 501, reason: "Not Implemented")
    /// HTTP code 502 - Bad Gateway
    public static let badGateway = RequestError(httpCode: 502, reason: "Bad Gateway")
    /// HTTP code 503 - Service Unavailable
    public static let serviceUnavailable = RequestError(httpCode: 503, reason: "Service Unavailable")
    /// HTTP code 504 - Gateway Timeout
    public static let gatewayTimeout = RequestError(httpCode: 504, reason: "Gateway Timeout")
    /// HTTP code 505 - HTTP Version Not Supported
    public static let httpVersionNotSupported = RequestError(httpCode: 505, reason: "HTTP Version Not Supported")
    /// HTTP code 506 - Variant Also Negotiates
    public static let variantAlsoNegotiates = RequestError(httpCode: 506, reason: "Variant Also Negotiates")
    /// HTTP code 507 - Insufficient Storage
    public static let insufficientStorage = RequestError(httpCode: 507, reason: "Insufficient Storage")
    /// HTTP code 508 - Loop Detected
    public static let loopDetected = RequestError(httpCode: 508, reason: "Loop Detected")
    /// HTTP code 510 - Not Extended
    public static let notExtended = RequestError(httpCode: 510, reason: "Not Extended")
    /// HTTP code 511 - Network Authentication Required
    public static let networkAuthenticationRequired = RequestError(httpCode: 511, reason: "Network Authentication Required")
}

/**
 An error representing a failure to create an `Identifier`.
 */
public enum IdentifierError: Error {
    /// Represents a failure to create an `Identifier` from a given `String` representation.
    case invalidValue
}

/**
 An identifier for an entity with a string representation.
 */
public protocol Identifier {
    /// Creates an identifier from a given string value.
    /// - Throws: An IdentifierError.invalidValue if the given string is not a valid representation.
    init(value: String) throws

    /// The string representation of the identifier.
    var value: String { get }
}

/**
 Extends `String` to comply to the `Identifier` protocol.
 */
extension String: Identifier {
    /// Creates a string identifier from a given string value.
    public init(value: String) {
        self.init(value)
    }

    /// The string representation of the identifier.
    public var value: String {
        return self
    }
}

/**
 Extends `Int` to comply to the `Identifier` protocol.
 */
extension Int: Identifier {
    /// Creates an integer identifier from a given string representation.
    /// - Throws: An `IdentifierError.invalidValue` if the given string cannot be converted to an integer.
    public init(value: String) throws {
        if let id = Int(value) {
            self = id
        } else {
            throw IdentifierError.invalidValue
        }
    }

    /// The string representation of the identifier.
    public var value: String {
        return String(describing: self)
    }
}

//public protocol Persistable: Codable {
//    // Related types
//    associatedtype Id: Identifier
//
//    // Create
//    static func create(model: Self, respondWith: @escaping (Self?, RequestError?) -> Void)
//    // Read
//    static func read(id: Id, respondWith: @escaping (Self?, RequestError?) -> Void)
//    // Read all
//    static func read(respondWith: @escaping ([Self]?, RequestError?) -> Void)
//    // Update
//    static func update(id: Id, model: Self, respondWith: @escaping (Self?, RequestError?) -> Void)
//    // How about returning Identifer instances for the delete operations?
//    // Delete
//    static func delete(id: Id, respondWith: @escaping (RequestError?) -> Void)
//    // Delete all
//    static func delete(respondWith: @escaping (RequestError?) -> Void)
//}
//
//// Provides utility methods for getting the type  and routes for the class
//// conforming to Persistable
//public extension Persistable {
//    // Set up name space based on name of model (e.g. User -> user(s))
//    static var type: String {
//        let kind = String(describing: Swift.type(of: self))
//        return String(kind.characters.dropLast(5))
//    }
//    static var typeLowerCased: String { return "\(type.lowercased())" }
//    static var route: String { return "/\(typeLowerCased)s" }
//}
