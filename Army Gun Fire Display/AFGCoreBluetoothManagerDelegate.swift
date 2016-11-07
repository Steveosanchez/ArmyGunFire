//
//  AFGCoreBluetoothManagerDelegate.swift
//  Army Gun Fire Display
//
//  Created by Steven Sanchez on 10/22/16.
//  Copyright © 2016 Apargo. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol AFGCoreBluetoothManagerDelegate : class {
    func didFindDevcies(peripheral: CBPeripheral)
    func coreBluetoothState(state: CBManagerState)
    func didDiscoverCharacteristics(peripheral: CBPeripheral)
}
