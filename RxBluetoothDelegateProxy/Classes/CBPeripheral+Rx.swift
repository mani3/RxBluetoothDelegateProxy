//
//  CBPeripheral+Rx.swift
//  Pods
//
//  Created by Kazuya Shida on 2017/07/06.
//
//

import CoreBluetooth
import RxSwift
import RxCocoa

extension Reactive where Base: CBPeripheral {
    
    internal var delegate: CBPeripheralDelegateProxy {
        return CBPeripheralDelegateProxy.proxyForObject(base)
    }
    
    public var didUpdateName: Observable<CBPeripheral> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheralDidUpdateName(_:)))
            .map { a in try castOrThrow(CBPeripheral.self, a[0]) }
    }
    
    public var didDiscoverServices: Observable<(peripheral: CBPeripheral, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverServices:)))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[0])
                let error = try castOptionalOrThrow(Error.self, a[1])
                return (peripheral: peripheral, error: error)
        }
    }
    
    public var didDiscoverCharacteristics: Observable<(peripheral: CBPeripheral, service: CBService, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverCharacteristicsFor:error:)))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[0])
                let service = try castOrThrow(CBService.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, service: service, error: error)
        }
    }
    
    public var didWriteValue: Observable<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didWriteValueFor:error:) as ((CBPeripheralDelegate) -> (CBPeripheral, CBCharacteristic, Error?) -> Void)?))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[0])
                let characteristic = try castOrThrow(CBCharacteristic.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, characteristic: characteristic, error: error)
        }
    }
    
    
    public var didUpdateValue: Observable<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didUpdateValueFor:error:) as ((CBPeripheralDelegate) -> (CBPeripheral, CBCharacteristic, Error?) -> Void)?))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[0])
                let characteristic = try castOrThrow(CBCharacteristic.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, characteristic: characteristic, error: error)
        }
    }
    
    public var didUpdateNotificationState: Observable<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didUpdateNotificationStateFor:error:)))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[0])
                let characteristic = try castOrThrow(CBCharacteristic.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, characteristic: characteristic, error: error)
        }
    }
    
    public var didDiscoverDescriptors: Observable<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverDescriptorsFor:error:)))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[0])
                let characteristic = try castOrThrow(CBCharacteristic.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, characteristic: characteristic, error: error)
        }
    }
    
    public var didWriteValueForDescriptor: Observable<(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didWriteValueFor:error:) as ((CBPeripheralDelegate) -> (CBPeripheral, CBDescriptor, Error?) -> Void)?))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[0])
                let descriptor = try castOrThrow(CBDescriptor.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, descriptor: descriptor, error: error)
        }
    }
    
    
    public var didUpdateValueForDescriptor: Observable<(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)> {
        return delegate
            .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didUpdateValueFor:error:) as ((CBPeripheralDelegate) -> (CBPeripheral, CBDescriptor, Error?) -> Void)?))
            .map { a in
                let peripheral = try castOrThrow(CBPeripheral.self, a[0])
                let descriptor = try castOrThrow(CBDescriptor.self, a[1])
                let error = try castOptionalOrThrow(Error.self, a[2])
                return (peripheral: peripheral, descriptor: descriptor, error: error)
        }
    }
}
