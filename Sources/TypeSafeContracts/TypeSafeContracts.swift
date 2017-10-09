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

 public enum TypeError: Error {
    case invalidIdentifier
    case unknown
}

public protocol Identifier {
    init(value: String) throws
    var value: String { get }
}

public struct IntId: Identifier {
    public let id: Int
    public let value: String
    public init(value: String) throws {
        if let id = Int(value) {
            self.id = id
            self.value = value
        } else {
            throw TypeError.invalidIdentifier
        }
    }
}

public protocol Persistable {
    // Related types
    associatedtype Model: Codable = Self
    associatedtype Id: Identifier

    // Create
    static func create(model: Model, respondWith: @escaping (Model?, Error?) -> Void)
    // Read
    static func read(id: Id, respondWith: @escaping (Model?, Error?) -> Void)
    // Read all
    static func read(respondWith: @escaping ([Model]?, Error?) -> Void)
    // Update
    static func update(id: Id, model: Model, respondWith: @escaping (Model?, Error?) -> Void)
    // Delete
    static func delete(id: Id, respondWith: @escaping (Error?) -> Void)
    // Delete all
    static func delete(respondWith: @escaping (Error?) -> Void)
}
