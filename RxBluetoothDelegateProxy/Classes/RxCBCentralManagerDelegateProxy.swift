//
//  RxCBCentralManagerDelegateProxy.swift
//  Pods
//
//  Created by Kazuya Shida on 2017/07/04.
//
//

import CoreBluetooth
import RxSwift
import RxCocoa

class RxCBCentralManagerDelegateProxy: DelegateProxy, DelegateProxyType, CBCentralManagerDelegate {
    
    internal lazy var subject = PublishSubject<CBCentralManager>()
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        _forwardToDelegate?.centralManagerDidUpdateState(central)
        subject.onNext(central)
    }
    
    deinit {
        subject.on(.completed)
    }
    
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let centralManager = object as? CBCentralManager
        return centralManager?.delegate
    }
    
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let centralManager = object as? CBCentralManager
        centralManager?.delegate = delegate as? CBCentralManagerDelegate
    }
}
