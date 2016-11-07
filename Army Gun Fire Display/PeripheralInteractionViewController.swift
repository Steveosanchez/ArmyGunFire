//
//  PeripheralInteractionViewController.swift
//  Army Gun Fire Display
//
//  Created by Steven Sanchez on 11/6/16.
//  Copyright © 2016 Apargo. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralInteractionViewController: UIViewController {

    @IBOutlet weak var firstLaserButton: UIButton!
    
    var peripheral: CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectedFireFirstLaser(_ sender: Any) {
        let fireFirstLasers: UInt8 = 0x02
        let data: [UInt8] = [fireFirstLasers]
        
        let dataObject = Data(bytes: data)
        
        guard let lePeripheral = peripheral else {
            return
        }
        AGFCoreBluetoothManager.sharedInstance.writeDateToPeripheral(peripheral: lePeripheral, data: dataObject)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
