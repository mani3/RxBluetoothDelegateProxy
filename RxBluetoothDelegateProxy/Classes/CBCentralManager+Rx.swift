//
//  CBCentralManager+Rx.swift
//  Pods
//
//  Created by Kazuya Shida on 2017/07/04.
//
//

import CoreBluetooth
import RxSwift
import RxCocoa

extension Reactive where Base: CBCentralManager {
    
    internal var delegate: RxCBCentralManagerDelegateProxy {
        return RxCBCentralManagerDelegateProxy.proxyForObject(base)
    }
    
    public var updatedState: Observable<CBCentralManager> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManagerDidUpdateState(_:)))
            .map { a in try castOrThrow(CBCentralManager.self, a[0]) }
    }
    
    public var didDiscover: Observable<(peripheral: CBPeripheral, data: [String: Any], rssi: NSNumber)> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDiscover:advertisementData:rssi:)))
            .map { (a) in
                let peripheral = try castOrThrow(CBPeripheral.self, a[1])
                let data = try castOrThrow([String: Any].self, a[2])
                let rssi = try castOrThrow(NSNumber.self, a[3])
                return (peripheral: peripheral, data: data, rssi: rssi)
            }
    }
    
    public var didConnect: Observable<CBPeripheral> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didConnect:)))
            .map { a in try castOrThrow(CBPeripheral.self, a[1]) }
    }
    
    public var didFailToConnect: Observable<(peripheral: CBPeripheral, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didFailToConnect:error:)))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, error: error)
            }
    }
    
    public var didDisconnect: Observable<(peripheral: CBPeripheral, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDisconnectPeripheral:error:)))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, error: error)
            }
    }
}

extension Reactive where Base: CBCentralManager {
    
    public var state: Observable<CBCentralManager> {
        return delegate.subject.asObservable()
            .map { (manager) in manager }
    }
    
    public func scan(timeout: Double) -> Observable<CBPeripheral> {
        return Observable<CBPeripheral>.create { (observer) -> Disposable in
            self.base.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                self.base.stopScan()
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
