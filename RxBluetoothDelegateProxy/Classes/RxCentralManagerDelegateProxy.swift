//
//  RxCentralManagerDelegateProxy.swift
//  Pods
//
//  Created by Kazuya Shida on 2017/06/11.
//
//

import CoreBluetooth
import RxSwift
import RxCocoa

class CBCentralManagerDelegateProxy: DelegateProxy, DelegateProxyType, CBCentralManagerDelegate {
    
    fileprivate var _subject: PublishSubject<CBCentralManager>?
    
    var subject: PublishSubject<CBCentralManager> {
        if let subject = _subject {
            return subject
        }
        let subject = PublishSubject<CBCentralManager>()
        _subject = subject
        return subject
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        subject.onNext(central)
    }
    
    deinit {
        subject.onCompleted()
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

extension Reactive where Base: CBCentralManager {
    
    @available(iOS 10.0, *)
    var state: Observable<CBManagerState> {
        return (delegate as! CBCentralManagerDelegateProxy).subject
            .asObservable()
            .map { (manager) -> CBManagerState in
                return manager.state
        }
    }
    
    func scan(timeout: Double) -> Observable<CBPeripheral> {
        return Observable<CBPeripheral>.create { (observer) -> Disposable in
            if !self.base.isScanning {
                self.base.scanForPeripherals(withServices: nil, options: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                    self.base.stopScan()
                    observer.onCompleted()
                }
            } else {
                observer.onError(NSError())
            }
            return Disposables.create()
        }
    }
    
    internal var delegate: DelegateProxy {
        return CBCentralManagerDelegateProxy.proxyForObject(base)
    }
    
    var updatedState: Observable<CBCentralManager> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManagerDidUpdateState(_:)))
            .map { a in return a[0] as! CBCentralManager }
    }
    
    var discovered: Observable<CBPeripheral> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDiscover:advertisementData:rssi:)))
            .map { (a) in a[1] as! CBPeripheral }
    }
    
    var connected: Observable<CBPeripheral> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didConnect:)))
            .map { a in return a[1] as! CBPeripheral }
    }
    
    var failedToConnect: Observable<CBPeripheral> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didFailToConnect:error:)))
            .map { a in return a[1] as! CBPeripheral }
    }
    
    var disconnected: Observable<CBPeripheral> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDisconnectPeripheral:error:)))
            .map { a in return a[1] as! CBPeripheral }
    }
}
