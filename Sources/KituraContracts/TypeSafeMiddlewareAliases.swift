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

// MARK: Type-Safe Middleware Aliases

// Used by PUT and PATCH with identifier
public typealias MiddlewareIdentifierCodableClosure<T: TypeSafeMiddleware, Id: Identifier, I: Codable, O: Codable> = (T, Id, I, @escaping CodableResultClosure<O>) -> Void

public typealias TwoMiddlewareIdentifierCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, Id: Identifier, I: Codable, O: Codable> = (T1, T2, Id, I, @escaping CodableResultClosure<O>) -> Void

public typealias ThreeMiddlewareIdentifierCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware, Id: Identifier, I: Codable, O: Codable> = (T1, T2, T3, Id, I, @escaping CodableResultClosure<O>) -> Void

// Used by POST
public typealias MiddlewareCodableClosure<T: TypeSafeMiddleware, I: Codable, O: Codable> = (T, I, @escaping CodableResultClosure<O>) -> Void

public typealias TwoMiddlewareCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, I: Codable, O: Codable> = (T1, T2, I, @escaping CodableResultClosure<O>) -> Void

public typealias ThreeMiddlewareCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware, I: Codable, O: Codable> = (T1, T2, T3, I, @escaping CodableResultClosure<O>) -> Void

// Used by POST with identifier
public typealias MiddlewareCodableIdentifierClosure<T: TypeSafeMiddleware, I: Codable, Id: Identifier, O: Codable> = (T, I, @escaping IdentifierCodableResultClosure<Id, O>) -> Void

public typealias TwoMiddlewareCodableIdentifierClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, I: Codable, Id: Identifier, O: Codable> = (T1, T2, I, @escaping IdentifierCodableResultClosure<Id, O>) -> Void

public typealias ThreeMiddlewareCodableIdentifierClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware, I: Codable, Id: Identifier, O: Codable> = (T1, T2, T3, I, @escaping IdentifierCodableResultClosure<Id, O>) -> Void

// Used by DELETE
public typealias MiddlewareNonCodableClosure<T: TypeSafeMiddleware> = (T, @escaping ResultClosure) -> Void

public typealias TwoMiddlewareNonCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware> = (T1, T2, @escaping ResultClosure) -> Void

public typealias ThreeMiddlewareNonCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware> = (T1, T2, T3, @escaping ResultClosure) -> Void

// Used by DELETE with identifier
public typealias MiddlewareIdentifierNonCodableClosure<T: TypeSafeMiddleware, Id: Identifier> = (T, Id, @escaping ResultClosure) -> Void

public typealias TwoMiddlewareIdentifierNonCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, Id: Identifier> = (T1, T2, Id, @escaping ResultClosure) -> Void

public typealias ThreeMiddlewareIdentifierNonCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware, Id: Identifier> = (T1, T2, T3, Id, @escaping ResultClosure) -> Void

// Used by GET returning array
public typealias MiddlewareCodableArrayClosure<T: TypeSafeMiddleware, O: Codable> = (T, @escaping CodableArrayResultClosure<O>) -> Void

public typealias TwoMiddlewareCodableArrayClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, O: Codable> = (T1, T2, @escaping CodableArrayResultClosure<O>) -> Void

public typealias ThreeMiddlewareCodableArrayClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware, O: Codable> = (T1, T2, T3, @escaping CodableArrayResultClosure<O>) -> Void

// Used by GET with identifier returning array
public typealias MiddlewareIdentifierCodableArrayClosure<T: TypeSafeMiddleware, Id: Identifier, O: Codable> = (T, @escaping IdentifierCodableArrayResultClosure<Id, O>) -> Void

public typealias TwoMiddlewareIdentifierCodableArrayClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, Id: Identifier, O: Codable> = (T1, T2, @escaping IdentifierCodableArrayResultClosure<Id, O>) -> Void

public typealias ThreeMiddlewareIdentifierCodableArrayClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware, Id: Identifier, O: Codable> = (T1, T2, T3, @escaping IdentifierCodableArrayResultClosure<Id, O>) -> Void

// Used by GET returning single codable
public typealias MiddlewareSimpleCodableClosure<T: TypeSafeMiddleware, O: Codable> = (T, @escaping CodableResultClosure<O>) -> Void

public typealias TwoMiddlewareSimpleCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, O: Codable> = (T1, T2, @escaping CodableResultClosure<O>) -> Void

public typealias ThreeMiddlewareSimpleCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware, O: Codable> = (T1, T2, T3, @escaping CodableResultClosure<O>) -> Void

// Used by GET with identifier returning single codable
public typealias MiddlewareIdentifierSimpleCodableClosure<T: TypeSafeMiddleware, Id: Identifier, O: Codable> = (T, Id, @escaping CodableResultClosure<O>) -> Void

public typealias TwoMiddlewareIdentifierSimpleCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, Id: Identifier, O: Codable> = (T1, T2, Id, @escaping CodableResultClosure<O>) -> Void

public typealias ThreeMiddlewareIdentifierSimpleCodableClosure<T1: TypeSafeMiddleware, T2: TypeSafeMiddleware, T3: TypeSafeMiddleware, Id: Identifier, O: Codable> = (T1, T2, T3, Id, @escaping CodableResultClosure<O>) -> Void

