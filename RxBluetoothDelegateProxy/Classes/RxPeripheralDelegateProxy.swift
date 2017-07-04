//
//  RxPeripheralDelegateProxy.swift
//  Pods
//
//  Created by Kazuya Shida on 2017/07/04.
//
//

import CoreBluetooth
import RxSwift
import RxCocoa

class CBPeripheralDelegateProxy: DelegateProxy, DelegateProxyType, CBPeripheralDelegate {
    
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let peripheral = object as? CBPeripheral
        return peripheral?.delegate
    }
    
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let peripheral = object as? CBPeripheral
        peripheral?.delegate = delegate as? CBPeripheralDelegate
    }
}

extension Reactive where Base: CBPeripheral {

    internal var delegate: CBPeripheralDelegateProxy {
        return CBPeripheralDelegateProxy.proxyForObject(base)
    }
    
    public var discoveredServices: Observable<CBPeripheral> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverServices:)))
            .map { a in
                if let error = a[1] as? Error {
                    throw error
                } else {
                    return a[0] as! CBPeripheral
                }
            }
    }
    
    public var discoveredCharacteristics: Observable<CBPeripheral> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverCharacteristicsFor:error:)))
            .map { a in
                if let error = a[2] as? Error {
                    throw error
                } else {
                    return a[0] as! CBPeripheral
                }
        }
    }
    
    public var wroteValue: Observable<CBCharacteristic> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didWriteValueFor:error:) as ((CBPeripheralDelegate) -> (CBPeripheral, CBCharacteristic, Error?) -> Void)?))
            .map { a in
                if let error = a[2] as? Error {
                    throw error
                } else {
                    return a[0] as! CBCharacteristic
                }
        }
    }
}
