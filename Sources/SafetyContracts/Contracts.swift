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

public struct ProcessHandlerError: RawRepresentable, Equatable, Hashable, Comparable, Error {
    public typealias RawValue = Int
    public let rawValue: Int

    //MARK: Hashable
    public var hashValue: Int {
        return rawValue
    }

    //MARK: Comparable
    public static func <(lhs: ProcessHandlerError, rhs: ProcessHandlerError) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    //MARK: Equatable
    public static func ==(lhs: ProcessHandlerError, rhs: ProcessHandlerError) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(httpCode: Int) {
        rawValue = httpCode
    }

    // HTTP status codes
    public static let `continue` = ProcessHandlerError(httpCode: 100)
    public static let switchingProtocols = ProcessHandlerError(httpCode: 101)
    public static let ok = ProcessHandlerError(httpCode: 200)
    public static let created = ProcessHandlerError(httpCode: 201)
    public static let accepted = ProcessHandlerError(httpCode: 202)
    public static let nonAuthoritativeInformation = ProcessHandlerError(httpCode: 203)
    public static let noContent = ProcessHandlerError(httpCode: 204)
    public static let resetContent = ProcessHandlerError(httpCode: 205)
    public static let partialContent = ProcessHandlerError(httpCode: 206)
    public static let multiStatus = ProcessHandlerError(httpCode: 207)
    public static let alreadyReported = ProcessHandlerError(httpCode: 208)
    public static let imUsed = ProcessHandlerError(httpCode: 226)
    public static let multipleChoices = ProcessHandlerError(httpCode: 300)
    public static let movedPermanently = ProcessHandlerError(httpCode: 301)
    public static let found = ProcessHandlerError(httpCode: 302)
    public static let seeOther = ProcessHandlerError(httpCode: 303)
    public static let notModified = ProcessHandlerError(httpCode: 304)
    public static let useProxy = ProcessHandlerError(httpCode: 305)
    public static let temporaryRedirect = ProcessHandlerError(httpCode: 307)
    public static let permanentRedirect = ProcessHandlerError(httpCode: 308)
    public static let badRequest = ProcessHandlerError(httpCode: 400)
    public static let unauthorized = ProcessHandlerError(httpCode: 401)
    public static let paymentRequired = ProcessHandlerError(httpCode: 402)
    public static let forbidden = ProcessHandlerError(httpCode: 403)
    public static let notFound = ProcessHandlerError(httpCode: 404)
    public static let methodNotAllowed = ProcessHandlerError(httpCode: 405)
    public static let notAcceptable = ProcessHandlerError(httpCode: 406)
    public static let proxyAuthenticationRequired = ProcessHandlerError(httpCode: 407)
    public static let requestTimeout = ProcessHandlerError(httpCode: 408)
    public static let conflict = ProcessHandlerError(httpCode: 409)
    public static let gone = ProcessHandlerError(httpCode: 410)
    public static let lengthRequired = ProcessHandlerError(httpCode: 411)
    public static let preconditionFailed = ProcessHandlerError(httpCode: 412)
    public static let payloadTooLarge = ProcessHandlerError(httpCode: 413)
    public static let uriTooLong = ProcessHandlerError(httpCode: 414)
    public static let unsupportedMediaType = ProcessHandlerError(httpCode: 415)
    public static let rangeNotSatisfiable = ProcessHandlerError(httpCode: 416)
    public static let expectationFailed = ProcessHandlerError(httpCode: 417)
    public static let misdirectedRequest = ProcessHandlerError(httpCode: 421)
    public static let unprocessableEntity = ProcessHandlerError(httpCode: 422)
    public static let locked = ProcessHandlerError(httpCode: 423)
    public static let failedDependency = ProcessHandlerError(httpCode: 424)
    public static let upgradeRequired = ProcessHandlerError(httpCode: 426)
    public static let preconditionRequired = ProcessHandlerError(httpCode: 428)
    public static let tooManyRequests = ProcessHandlerError(httpCode: 429)
    public static let requestHeaderFieldsTooLarge = ProcessHandlerError(httpCode: 431)
    public static let unavailableForLegalReasons = ProcessHandlerError(httpCode: 451)
    public static let internalServerError = ProcessHandlerError(httpCode: 500)
    public static let notImplemented = ProcessHandlerError(httpCode: 501)
    public static let badGateway = ProcessHandlerError(httpCode: 502)
    public static let serviceUnavailable = ProcessHandlerError(httpCode: 503)
    public static let gatewayTimeout = ProcessHandlerError(httpCode: 504)
    public static let httpVersionNotSupported = ProcessHandlerError(httpCode: 505)
    public static let variantAlsoNegotiates = ProcessHandlerError(httpCode: 506)
    public static let insufficientStorage = ProcessHandlerError(httpCode: 507)
    public static let loopDetected = ProcessHandlerError(httpCode: 508)
    public static let notExtended = ProcessHandlerError(httpCode: 510)
    public static let networkAuthenticationRequired = ProcessHandlerError(httpCode: 511)
}

public enum IdentifierError: Error {
    case invalidValue // String representation of identifier could not be converted to the concrete Identifier subtype
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
    static func create(model: Self, respondWith: @escaping (Self?, ProcessHandlerError?) -> Void)
    // Read
    static func read(id: Id, respondWith: @escaping (Self?, ProcessHandlerError?) -> Void)
    // Read all
    static func read(respondWith: @escaping ([Self]?, ProcessHandlerError?) -> Void)
    // Update
    static func update(id: Id, model: Self, respondWith: @escaping (Self?, ProcessHandlerError?) -> Void)
    // How about returning Identifer instances for the delete operations?
    // Delete
    static func delete(id: Id, respondWith: @escaping (ProcessHandlerError?) -> Void)
    // Delete all
    static func delete(respondWith: @escaping (ProcessHandlerError?) -> Void)
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
