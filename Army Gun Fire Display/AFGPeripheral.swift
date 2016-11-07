//
//  AFGPeripheral.swift
//  Army Gun Fire Display
//
//  Created by Steven Sanchez on 10/26/16.
//  Copyright © 2016 Apargo. All rights reserved.
//

import Foundation
import CoreBluetooth

class AFGPeripheral {
    
    var name: String?
    var identifier: String?
    
    init(peripheral: CBPeripheral) {
        name = peripheral.name
        identifier = peripheral.identifier.uuidString
    }
}
