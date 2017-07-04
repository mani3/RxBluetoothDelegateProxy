//
//  ViewController.swift
//  RxBluetoothDelegateProxy
//
//  Created by mani-mani on 06/11/2017.
//  Copyright (c) 2017 mani-mani. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxSwift
import RxBluetoothDelegateProxy

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    var peripheral = Variable<CBPeripheral?>(nil)
    
    let manager = CBCentralManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.rx.state
            .flatMap { (manager) -> Observable<CBPeripheral> in
                print(manager.state.rawValue, manager.state == .poweredOn)
                return manager.rx.scan(timeout: 5)
            }
            .subscribe()
            .addDisposableTo(disposeBag)
        
        manager.rx.discovered
            .map { (peripheral, data, rssi) -> CBPeripheral in
                print(peripheral.debugDescription, data.debugDescription, rssi.debugDescription)
                return peripheral
            }
            .bind(to: peripheral)
            .addDisposableTo(disposeBag)
        
        peripheral.asObservable()
            .subscribe(
                onNext: { (peripheral) in
                    print(peripheral.debugDescription, "見つかった")
//                    peripheral?.delegate = self
//                    peripheral?.discoverServices(<#T##serviceUUIDs: [CBUUID]?##[CBUUID]?#>)
                }
            )
            .addDisposableTo(disposeBag)
        
//        manager.rx.connected
//            .map { peripheral in
//                print(peripheral.debugDescription)
//                return peripheral
//            }
//            .bind(to: peripheral)
//            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

