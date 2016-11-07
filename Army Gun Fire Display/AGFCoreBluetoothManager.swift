//
//  AGFCoreBluetoothManager.swift
//  Army Gun Fire Display
//
//  Created by Steven Sanchez on 10/22/16.
//  Copyright © 2016 Apargo. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit


//// RBL Service
//#define RBL_SERVICE_UUID                         "713D0000-503E-4C75-BA94-3148F18D941E"
//#define RBL_CHAR_TX_UUID                         "713D0002-503E-4C75-BA94-3148F18D941E"
//#define RBL_CHAR_RX_UUID                         "713D0003-503E-4C75-BA94-3148F18D941E"

enum RBLUUIDs : String {
    case RBLServiceUUID = "713D0000-503E-4C75-BA94-3148F18D941E"
    case RBLCharTXUUID = "713D0002-503E-4C75-BA94-3148F18D941E"
    case RBLCharRXUUID = "713D0003-503E-4C75-BA94-3148F18D941E"
}

class AGFCoreBluetoothManager : NSObject {
    static let sharedInstance = AGFCoreBluetoothManager()
    
    var manager: CBCentralManager?
    
    var responderMap: NSHashTable <AnyObject> = NSHashTable.weakObjects()
    
    func setup() {
        manager = CBCentralManager.init(delegate: self, queue: nil)
    }
    
    func registerForUpdates(delegate: AFGCoreBluetoothManagerDelegate) {
        responderMap.add(delegate)
    }
    
    func unregisterForUpdates(delegate: AFGCoreBluetoothManagerDelegate) {
        responderMap.remove(delegate)
    }
    
    func findDevices() -> NSError? {
        if let localManager = manager {
            localManager.scanForPeripherals(withServices: nil, options: nil)
            return nil
        } else {
            return NSError(domain: "com.AFG.CoreBluetooth", code: 100, userInfo: ["reason" : "manager not properly initialized"])
        }
    }
    
    func connectToDevice(peripheral: CBPeripheral) {
        peripheral.delegate = self
        manager?.connect(peripheral, options: nil)
    }
    
    func writeDateToPeripheral(peripheral: CBPeripheral, data: Data) {
        let serviceUUID = CBUUID(string: RBLUUIDs.RBLServiceUUID.rawValue)
        let characteristicUUID = CBUUID(string: RBLUUIDs.RBLCharRXUUID.rawValue)
        
        guard let service = findService(peripheral: peripheral, serviceUUID: serviceUUID) else {
            return
        }
        
        guard let characteristic = findCharacteristic(service: service, characteristicUUID: characteristicUUID) else {
            return
        }
        
        
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }
    
    func findService(peripheral: CBPeripheral, serviceUUID: CBUUID) -> CBService? {
        guard let services = peripheral.services else {
            return nil
        }
        
        for service in services {
            if service.uuid == serviceUUID {
                return service
            }
        }
        
        return nil
    }
    
    func findCharacteristic(service: CBService, characteristicUUID: CBUUID) -> CBCharacteristic? {
        guard let characteristics = service.characteristics else  {
            return nil
        }
        
        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                return characteristic
            }
        }
        
        return nil
    }
}

extension AGFCoreBluetoothManager : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard let delegates = responderMap.allObjects as? [AFGCoreBluetoothManagerDelegate] else {
            return
        }
        
        for updateDelegates in delegates {
            updateDelegates.coreBluetoothState(state: central.state)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let delegates = responderMap.allObjects as? [AFGCoreBluetoothManagerDelegate] else {
            return
        }
        
        for updateDelegates in delegates {
            updateDelegates.didFindDevcies(peripheral: peripheral)
        }
    }
}

extension AGFCoreBluetoothManager : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            NSLog("Found Services : \(services)")
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
    
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
    
    }
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
    
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
    
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        NSLog("Found Characteristics : \(service.characteristics) for service \(service)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
}
