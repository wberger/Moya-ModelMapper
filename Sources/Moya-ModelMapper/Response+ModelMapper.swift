//
//  Response+ModelMapper.swift
//  Pods
//
//  Created by sunshinejr on 02.02.2016.
//  Copyright © 2016 sunshinejr. All rights reserved.
//

import Foundation
import Moya
import Mapper

public extension Response {
    
    public func mapObject<T: Mappable>() throws -> T {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MoyaError.jsonMapping(self)
        }

        do {
            return try T(map: Mapper(JSON: jsonDictionary))
        } catch {
            throw MoyaError.underlying(error)
        }
    }
    
    public func mapObject<T: Mappable>(withKeyPath keyPath: String?) throws -> T {
        guard let keyPath = keyPath else { return try mapObject() }
        
        guard let jsonDictionary = try mapJSON() as? NSDictionary,
            let objectDictionary = jsonDictionary.value(forKeyPath:keyPath) as? NSDictionary else {
                throw MoyaError.jsonMapping(self)
        }

        do {
            return try T(map: Mapper(JSON: objectDictionary))
        } catch {
            throw MoyaError.underlying(error)
        }
    }
    
    public func mapArray<T: Mappable>() throws -> [T] {
        guard let jsonArray = try mapJSON() as? [NSDictionary] else {
            throw MoyaError.jsonMapping(self)
        }

        do {
            return try jsonArray.map { try T(map: Mapper(JSON: $0)) }
        } catch {
            throw MoyaError.underlying(error)
        }
    }
    
    public func mapArray<T: Mappable>(withKeyPath keyPath: String?) throws -> [T] {
        guard let keyPath = keyPath else { return try mapArray() }
        
        guard let jsonDictionary = try mapJSON() as? NSDictionary,
            let objectArray = jsonDictionary.value(forKeyPath:keyPath) as? [NSDictionary] else {
                throw MoyaError.jsonMapping(self)
        }

        do {
            return try objectArray.map { try T(map: Mapper(JSON: $0)) }
        } catch {
            throw MoyaError.underlying(error)
        }
    }
}