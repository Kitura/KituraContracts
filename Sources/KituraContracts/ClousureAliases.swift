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