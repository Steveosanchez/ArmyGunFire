//
//  ScanTableViewController.swift
//  Army Gun Fire Display
//
//  Created by Steven Sanchez on 10/26/16.
//  Copyright © 2016 Apargo. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanTableViewController: UITableViewController {

    let data: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var scanButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AGFCoreBluetoothManager.sharedInstance.registerForUpdates(delegate: self)
        AGFCoreBluetoothManager.sharedInstance.setup()
        scanButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let peripheral = data[indexPath.row] as? CBPeripheral {
            cell.textLabel?.text = peripheral.name
        }

        return cell
    }

    @IBAction func didSelectScan(_ sender: AnyObject) {
        
        if let error = AGFCoreBluetoothManager.sharedInstance.findDevices() {
        }
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let peripheral = data[indexPath.row] as? CBPeripheral {
            AGFCoreBluetoothManager.sharedInstance.connectToDevice(peripheral: peripheral)
        }
    }
}

extension ScanTableViewController : AFGCoreBluetoothManagerDelegate {
    func didFindDevcies(peripheral: CBPeripheral) {
        data.add(peripheral)
        tableView.reloadData()
    }
    
    func coreBluetoothState(state: CBManagerState) {
        switch state {
        case .poweredOff:
            break
        case .poweredOn:
            scanButton.isEnabled = true
            break
        case .unauthorized:
            break
        case .unsupported:
            break
        case .resetting:
            break
        default:
            break
        }
    }
    
    func didDiscoverCharacteristics() {
        self.navigationController?.performSegue(withIdentifier: "", sender: <#T##Any?#>)
    }
}
