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

public struct RequestError: RawRepresentable, Equatable, Hashable, Comparable, Error, CustomStringConvertible {
    public typealias RawValue = Int
    public let rawValue: Int
    public let reason: String

    public var httpCode: Int {
        get {
            return rawValue
        }
    }

    public var description: String {
        return "\(rawValue) : \(reason)"
    }

    //MARK: Hashable
    public var hashValue: Int {
        return rawValue
    }

    //MARK: Comparable
    public static func <(lhs: RequestError, rhs: RequestError) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    //MARK: Equatable
    public static func ==(lhs: RequestError, rhs: RequestError) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public init(rawValue: Int) {
        self.rawValue = rawValue
        self.reason = RequestError.reason(forCode: rawValue)
    }

    public init(httpCode: Int) {
        self.init(rawValue: httpCode)
    }

    // HTTP status codes
    public static let `continue` = RequestError(httpCode: 100)
    public static let switchingProtocols = RequestError(httpCode: 101)
    public static let ok = RequestError(httpCode: 200)
    public static let created = RequestError(httpCode: 201)
    public static let accepted = RequestError(httpCode: 202)
    public static let nonAuthoritativeInformation = RequestError(httpCode: 203)
    public static let noContent = RequestError(httpCode: 204)
    public static let resetContent = RequestError(httpCode: 205)
    public static let partialContent = RequestError(httpCode: 206)
    public static let multiStatus = RequestError(httpCode: 207)
    public static let alreadyReported = RequestError(httpCode: 208)
    public static let imUsed = RequestError(httpCode: 226)
    public static let multipleChoices = RequestError(httpCode: 300)
    public static let movedPermanently = RequestError(httpCode: 301)
    public static let found = RequestError(httpCode: 302)
    public static let seeOther = RequestError(httpCode: 303)
    public static let notModified = RequestError(httpCode: 304)
    public static let useProxy = RequestError(httpCode: 305)
    public static let temporaryRedirect = RequestError(httpCode: 307)
    public static let permanentRedirect = RequestError(httpCode: 308)
    public static let badRequest = RequestError(httpCode: 400)
    public static let unauthorized = RequestError(httpCode: 401)
    public static let paymentRequired = RequestError(httpCode: 402)
    public static let forbidden = RequestError(httpCode: 403)
    public static let notFound = RequestError(httpCode: 404)
    public static let methodNotAllowed = RequestError(httpCode: 405)
    public static let notAcceptable = RequestError(httpCode: 406)
    public static let proxyAuthenticationRequired = RequestError(httpCode: 407)
    public static let requestTimeout = RequestError(httpCode: 408)
    public static let conflict = RequestError(httpCode: 409)
    public static let gone = RequestError(httpCode: 410)
    public static let lengthRequired = RequestError(httpCode: 411)
    public static let preconditionFailed = RequestError(httpCode: 412)
    public static let payloadTooLarge = RequestError(httpCode: 413)
    public static let uriTooLong = RequestError(httpCode: 414)
    public static let unsupportedMediaType = RequestError(httpCode: 415)
    public static let rangeNotSatisfiable = RequestError(httpCode: 416)
    public static let expectationFailed = RequestError(httpCode: 417)
    public static let misdirectedRequest = RequestError(httpCode: 421)
    public static let unprocessableEntity = RequestError(httpCode: 422)
    public static let locked = RequestError(httpCode: 423)
    public static let failedDependency = RequestError(httpCode: 424)
    public static let upgradeRequired = RequestError(httpCode: 426)
    public static let preconditionRequired = RequestError(httpCode: 428)
    public static let tooManyRequests = RequestError(httpCode: 429)
    public static let requestHeaderFieldsTooLarge = RequestError(httpCode: 431)
    public static let unavailableForLegalReasons = RequestError(httpCode: 451)
    public static let internalServerError = RequestError(httpCode: 500)
    public static let notImplemented = RequestError(httpCode: 501)
    public static let badGateway = RequestError(httpCode: 502)
    public static let serviceUnavailable = RequestError(httpCode: 503)
    public static let gatewayTimeout = RequestError(httpCode: 504)
    public static let httpVersionNotSupported = RequestError(httpCode: 505)
    public static let variantAlsoNegotiates = RequestError(httpCode: 506)
    public static let insufficientStorage = RequestError(httpCode: 507)
    public static let loopDetected = RequestError(httpCode: 508)
    public static let notExtended = RequestError(httpCode: 510)
    public static let networkAuthenticationRequired = RequestError(httpCode: 511)

    private static func reason(forCode code: Int) -> String {
        switch code {
            case 100: return "Continue"
            case 101: return "Switching Protocols"
            case 200: return "OK"
            case 201: return "Created"
            case 202: return "Accepted"
            case 203: return "Non-Authoritative Information"
            case 204: return "No Content"
            case 205: return "Reset Content"
            case 206: return "Partial Content"
            case 207: return "Multi-Status"
            case 208: return "Already Reported"
            case 226: return "IM Used"
            case 300: return "Multiple Choices"
            case 301: return "Moved Permanently"
            case 302: return "Found"
            case 303: return "See Other"
            case 304: return "Not Modified"
            case 305: return "Use Proxy"
            case 307: return "Temporary Redirect"
            case 308: return "Permanent Redirect"
            case 400: return "Bad Request"
            case 401: return "Unauthorized"
            case 402: return "Payment Required"
            case 403: return "Forbidden"
            case 404: return "Not Found"
            case 405: return "Method Not Allowed"
            case 406: return "Not Acceptable"
            case 407: return "Proxy Authentication Required"
            case 408: return "Request Timeout"
            case 409: return "Conflict"
            case 410: return "Gone"
            case 411: return "Length Required"
            case 412: return "Precondition Failed"
            case 413: return "Payload Too Large"
            case 414: return "URI Too Long"
            case 415: return "Unsupported Media Type"
            case 416: return "Range Not Satisfiable"
            case 417: return "Expectation Failed"
            case 421: return "Misdirected Request"
            case 422: return "Unprocessable Entity"
            case 423: return "Locked"
            case 424: return "Failed Dependency"
            case 426: return "Upgrade Required"
            case 428: return "Precondition Required"
            case 429: return "Too Many Requests"
            case 431: return "Request Header Fields Too Large"
            case 451: return "Unavailable For Legal Reasons"
            case 500: return "Internal Server Error"
            case 501: return "Not Implemented"
            case 502: return "Bad Gateway"
            case 503: return "Service Unavailable"
            case 504: return "Gateway Timeout"
            case 505: return "HTTP Version Not Supported"
            case 506: return "Variant Also Negotiates"
            case 507: return "Insufficient Storage"
            case 508: return "Loop Detected"
            case 510: return "Not Extended"
            case 511: return "Network Authentication Required"
            default: return "http_\(code)"
        }
    }

}

public enum IdentifierError: Error {
    // String representation of identifier could not be converted to the concrete Identifier subtype
    case invalidValue
}

public protocol Identifier {
    init(value: String) throws
    var value: String { get }
}

extension String: Identifier {
    public init(value: String) {
        self.init(value)
    }

    public var value: String {
        get {
            return self
        }
    }
}

extension Int: Identifier {
    public init(value: String) throws {
        if let id = Int(value) {
            self = id
        } else {
            throw IdentifierError.invalidValue
        }
    }

    public var value: String {
        return String(describing: self)
    }
}

public protocol Persistable: Codable {
    // Related types
    associatedtype Id: Identifier

    // Create
    static func create(model: Self, respondWith: @escaping (Self?, RequestError?) -> Void)
    // Read
    static func read(id: Id, respondWith: @escaping (Self?, RequestError?) -> Void)
    // Read all
    static func read(respondWith: @escaping ([Self]?, RequestError?) -> Void)
    // Update
    static func update(id: Id, model: Self, respondWith: @escaping (Self?, RequestError?) -> Void)
    // How about returning Identifer instances for the delete operations?
    // Delete
    static func delete(id: Id, respondWith: @escaping (RequestError?) -> Void)
    // Delete all
    static func delete(respondWith: @escaping (RequestError?) -> Void)
}

// Provides utility methods for getting the type  and routes for the class
// conforming to Persistable
public extension Persistable {
    // Set up name space based on name of model (e.g. User -> user(s))
    static var type: String {
        let kind = String(describing: Swift.type(of: self))
        return String(kind.characters.dropLast(5))
    }
    static var typeLowerCased: String { return "\(type.lowercased())" }
    static var route: String { return "/\(typeLowerCased)s" }
}
