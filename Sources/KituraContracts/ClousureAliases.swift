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

// MARK: Codable Type Aliases

/**
The `ResultClosure` takes an optional RequestError as a parameter.
     
### Usage Example: ###
````
public struct User: Codable {
  ...
}
     
router.delete("/users") { (id: Int, respondWith: (RequestError?) -> Void) in
  if databaseConnectionIsOk {
     
    ...
     
    //If everything works as intended you can pass nil to avoid using an error.
    respondWith(nil)
  } else {
     
    ...
     
    //If there has been an error you can use the respondWith call to respond with an appropiate error.
    respondWith(.internalServerError)
  }
}
````
*/
public typealias ResultClosure = (RequestError?) -> Void

/**
The `CodableResultClosure` takes an object conforming to `Codable` and a `RequestError?` as parameters.
The `CodableResultClosure` is used by other Codable closures.
*/
public typealias CodableResultClosure<O: Codable> = (O?, RequestError?) -> Void

/**
The `CodableArrayResultClosure` takes an object conforming to `Codable` and a `RequestError?` as parameters.
The `CodableArrayResultClosure` is used by other Codable closures.
*/
public typealias CodableArrayResultClosure<O: Codable> = ([O]?, RequestError?) -> Void

/**
The `IdentifierCodableResultClosure` takes an object conforming to `Identifier`, an object conforming to `Codable`, and a `RequestError?` as parameters.
The `IdentifierCodableResultClosure` is used by some of the other Codable closures.
*/
public typealias IdentifierCodableResultClosure<Id: Identifier, O: Codable> = (Id?, O?, RequestError?) -> Void

/**
The `IdentifierCodableClosure` takes an object conforming to `Identifier`, an object conforming to `Codable` and a closure of type `CodableResultClosure` as parameters.

### Usage Example: ###
````
public struct User: Codable {
  ...
}

var userStore: [Int, User] = [...]

//By default `Int` has conformity to Identifier
router.put("/users") { (id: Int, user: User, respondWith: (User?, RequestError?) -> Void) in

  guard let oldUser = self.userStore[id] else {

      //If there has been an error you can use the respondWith call to respond with an appropiate error and passing nil for the User?.
      respondWith(nil, .notFound)

      return
  }

  ...

  //If no errors occured and you have a User you can just respond with the user by passing nil as the 'RequestError?' value.
  respondWith(user, nil)
}
````
*/
public typealias IdentifierCodableClosure<Id: Identifier, I: Codable, O: Codable> = (Id, I, @escaping CodableResultClosure<O>) -> Void

/**
The `CodableClosure` takes an object conforming to `Codable` and a closure of type `CodableResultClosure` as parameters.

### Usage Example: ###
````
public struct User: Codable {
  ...
}

router.post("/users") { (user: User, respondWith: (User?, RequestError?) -> Void) in

  if databaseConnectionIsOk {

      ...
      //If no errors occured and you have a User you can just respond with the user by passing nil as the 'RequestError?' value.
      respondWith(user, nil)

  } else {

      ...

      //If there has been an error you can use the respondWith call to respond with an appropiate error and passing nil for the User?.
      respondWith(nil, .internalServerError)
  }
}
````
*/
public typealias CodableClosure<I: Codable, O: Codable> = (I, @escaping CodableResultClosure<O>) -> Void

/**
The `CodableIdentifierClosure` takes an object conforming to `Codable` and a closure of type `IdentifierCodableResultClosure` as parameters.

### Usage Example: ###
````
public struct User: Codable {
  ...
}

router.post("/users") { (user: User, respondWith: (Int?, User?, RequestError?) -> Void) in

  if databaseConnectionIsOk {

      ...
      //If no errors occured and you have a User and the corresponding identifier, you can just respond with the identifier and user, and pass nil as the 'RequestError?' value.
      respondWith(id, user, nil)

  } else {

      ...

      //If there has been an error you can use the respondWith call to respond with an appropiate error and passing nil for Int? and nil for User?.
      respondWith(nil, nil, .internalServerError)
  }
}
````
*/
public typealias CodableIdentifierClosure<I: Codable, Id: Identifier, O: Codable> = (I, @escaping IdentifierCodableResultClosure<Id, O>) -> Void

/**
The `NonCodableClosure` a closure of type `CodableResultClosure` as a parameter.

### Usage Example: ###
````
router.delete("/users") { (respondWith: (RequestError?) -> Void) in

    if databaseConnectionIsOk {

      ...
      //If no errors occured you can just pass nil as the 'RequestError?' value.
      respondWith(nil)

    } else {

      //If there has been an error you can use the respondWith call to respond with an appropiate error.
      respondWith(.internalServerError)

      ...
    }
}
````
*/
public typealias NonCodableClosure = (@escaping ResultClosure) -> Void

/**
The `IdentifierNonCodableClosure` takes an object conforming to `Identifier` and a closure of type `ResultClosure` as parameters.

### Usage Example: ###
````
router.delete("/users") { (id: Int, respondWith: (RequestError?) -> Void) in

  if databaseConnectionIsOk {

      ...

      //If no errors occured you can just pass nil as the 'RequestError?' value.
      respondWith(nil)

  } else {

      ...

      //If there has been an error you can use the respondWith call to respond with an appropiate error.
      respondWith(.internalServerError)
  }
}
````
*/
public typealias IdentifierNonCodableClosure<Id: Identifier> = (Id, @escaping ResultClosure) -> Void

/**

The `CodableArrayClosure` takes a closure of type `CodableArrayResultClosure` as a parameter.

### Usage Example: ###
````
router.get("/users") { (respondWith: ([User]?, RequestError?) -> Void) in

  if databaseConnectionIsOk {

      ...

      //If no errors occured and you have an array of Users you can just respond with the users by passing nil as the 'RequestError?' value.
      respondWith(users, nil)

  } else {

      ...

      //If there has been an error you can use the respondWith call to respond with an appropiate error and passing nil for the [User]?.
      respondWith(nil, .internalServerError)
  }
}
````
*/
public typealias CodableArrayClosure<O: Codable> = (@escaping CodableArrayResultClosure<O>) -> Void

/**
The `IdentifierSimpleCodableClosure` takes an object conforming to `Identifier` and a closure of type `CodableResultClosure` as parameters.

### Usage Example: ###
````
public struct User: Codable {
  ...
}

var userStore: [Int, User] = (...)

router.get("/users") { (id: Int, respondWith: (User?, RequestError?) -> Void) in

  guard let user = self.userStore[id] else {

      //If there has been an error you can use the respondWith call to respond with an appropiate error and passing nil for the User?.
      respondWith(nil, .notFound)

      return
  }

  ...

  //If no errors occured and you have a User you can just respond with the user by passing nil as the 'RequestError?' value.
  respondWith(user, nil)
}
````
*/
public typealias IdentifierSimpleCodableClosure<Id: Identifier, O: Codable> = (Id, @escaping CodableResultClosure<O>) -> Void
