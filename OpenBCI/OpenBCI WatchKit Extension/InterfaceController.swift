//
//  InterfaceController.swift
//  OpenBCI WatchKit Extension
//
//  Created by Jesse Spencer on 10/3/18.
//  Copyright © 2018 cindt. All rights reserved.
//

import WatchKit
import Foundation
import CoreBluetooth

class InterfaceController: WKInterfaceController {
    var centralManager: CBCentralManager!
    var openBCIBoard: CBPeripheral?
    var serviceUUID = CBUUID(string: "780A")            //Need to obtain correct values for uuid
    var characteristicUUID = CBUUID(string: "8AA2")     //Need to obtain correct values for uuid
    @IBOutlet weak var connectivityLabel: WKInterfaceLabel!
    
    
    private override init() {
        super.init()
        print("init()")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("awake()")
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("willActivate()")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("didDeactivate()")
    }

}

extension InterfaceController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        centralManager.stopScan()
        openBCIBoard = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        connectivityLabel.setText("Failed to Connect")
    }
    

    
}

extension InterfaceController: CBPeripheralDelegate {
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }
}
