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
