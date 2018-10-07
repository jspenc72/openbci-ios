//
//  ViewController.swift
//  OpenBCI
//
//  Created by Jesse Spencer on 10/3/18.
//  Copyright © 2018 cindt. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    var centralManager: CBCentralManager!
    var openBCIBoard: CBPeripheral?
    var serviceUUID = CBUUID(string: "780A")            //Need to obtain correct values for uuid
    var characteristicUUID = CBUUID(string: "8AA2")     //Need to obtain correct values for uuid
    @IBOutlet weak var connectivityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        centralManager = CBCentralManager(delegate: self, queue: nil, options: opts)
        print("viewDidLoad()")
    }
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        switch (central.state) {
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
            connectivityLabel.text = "Scanning for bluetooth devices..."
            print("bluetooth Powered ON")
            break
        case .poweredOff:
            print("bluetooth Powered OFF")
            let url = URL(string: UIApplication.openSettingsURLString)
            let app = UIApplication.shared
            app.open(url!, options: [:], completionHandler: nil)
            break
        case .unsupported:
            print("bluetooth not supported")
            break
        case .unknown:
            print("bluetooth not unknown")
            break
        case .resetting:
            print("bluetooth not resetting")
            break
        case .unauthorized:
            print("bluetooth not unauthorized")
            break
        default:
            print("did not handle bluetooth state.")
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectivityLabel.text = "Device Connected!"
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        connectivityLabel.text = "BLE Device Discovered... "
        centralManager.stopScan()
        openBCIBoard = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        connectivityLabel.text = "Failed to Connect"
    }
    
    
    
}

extension ViewController: CBPeripheralDelegate {
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }
}

