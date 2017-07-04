//
//  RxBluetoothDelegateProxy.swift
//  Pods
//
//  Created by Kazuya Shida on 2017/07/04.
//
//

import RxCocoa

internal func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

internal func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
