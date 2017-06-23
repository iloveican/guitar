//
//  Bluetooth.swift
//  guitar
//
//  Created by lazycal on 2017/5/26.
//  Copyright © 2017年 lazycal. All rights reserved.
//

import UIKit
protocol BluetoothDelegate: class {
    func readData(_ hexBytes: [UInt8])
    func didConnect()
}

class Bluetooth: NSObject, CBCentralManagerDelegate,CBPeripheralDelegate {
    
    //MARK: Public
    func connect() {
        print("扫描设备。。。。 ");
        myCentralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    func sendData(_ bytes:[UInt8]) {
        print("sendData: \(bytes)")
        writeToPeripheral(bytes)
        
    }
    //MARK: Properties
    weak var delegate: BluetoothDelegate?
    var  myCentralManager:CBCentralManager!
    var  myPeripheral:CBPeripheral!
    var writeCharacteristic:CBCharacteristic!
    //设备名
    var DEVICENAME:String
    //特征名
    var CHARACTERISTIC:String = "2AF1"
    //发送获取数据的指令
    var SECRETKEY:String = "938E0400080410"
    /// 存储最终拼到一起的结果
    var result:String = ""
    
    var lable:UILabel!
    
    init(deviceName: String) {
        DEVICENAME = deviceName
        super.init()
        myCentralManager = CBCentralManager()
        myCentralManager.delegate = self
    }
    
    
    func buttonTag(_ btn:UIButton) {
        
        switch btn.tag {
        case 10:
            break
        case 20:
            //向设备发送指令
            break
        default:
            break
        }
        
    }
    
    
    /**
     发送指令到设备
     */
    func writeToPeripheral(_ bytes:[UInt8]) {
        if writeCharacteristic != nil {
            let data1:Data = dataWithHexstring(bytes)
            
            self.myPeripheral.writeValue(data1, for: writeCharacteristic, type: CBCharacteristicWriteType.withResponse)
            
        } else{
            
            
        }
    }
    
    /**
     将[UInt8]数组转换为NSData
     
     - parameter bytes: <#bytes description#>
     
     - returns: <#return value description#>
     */
    
    func dataWithHexstring(_ bytes:[UInt8]) -> Data {
        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        return data
    }
    
    /**
     <#Description#>
     
     - parameter central:    <#central description#>
     - parameter peripheral: <#peripheral description#>
     - parameter error:      <#error description#>
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        switch (central.state) {
        case .poweredOn:
            print("蓝牙已打开, 请扫描外设!");
            break;
        case .poweredOff:
            print("蓝牙关闭，请先打开蓝牙");
        default:
            break;
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("-----centralManagerDidUpdateState----------")
        print(central.state)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("--didFailToConnectPeripheral--")
    }
    //发现设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        print("--didDiscoverPeripheral-\(name),target:\(DEVICENAME)")
        
        if name == DEVICENAME{
            self.myPeripheral = peripheral;
            self.myCentralManager = central;
            central.connect(self.myPeripheral, options: nil)
            print(self.myPeripheral);
        }
        
    }
    
    //设备已经接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("---------didConnectPeripheral-")
        print(central)
        print(peripheral)
        //关闭扫描
        self.myCentralManager.stopScan()
        self.myPeripheral.delegate = self
        self.myPeripheral.discoverServices(nil)
        print("扫描服务...");
    }
    
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
        print("---------willRestoreState---------")
        
        
    }
    /**
     发现服务调用次方法
     
     - parameter peripheral: <#peripheral description#>
     - parameter error:      <#error description#>
     */
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("---发现服务调用次方法-")
        
        for s in peripheral.services!{
            peripheral.discoverCharacteristics(nil, for: s)
            print(s.uuid.uuidString)
        }
    }
    /**
     根据服务找特征
     
     - parameter peripheral: <#peripheral description#>
     - parameter service:    <#service description#>
     - parameter error:      <#error description#>
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("----发现特征------")
        for c in service.characteristics! {
            print(c.uuid.uuidString)
            
            if c.uuid.uuidString == "FFE1"{
                print(c.uuid.uuidString)
                peripheral.setNotifyValue(true, for: c)
                self.writeCharacteristic = c
                print("特征FFE1配对完毕")
            }
            
            
            if c.uuid.uuidString == "2AF1"{
                print(c.uuid.uuidString)
                self.writeCharacteristic = c
                print("特征2AF1配对完毕")
            }
        }
    }
    
    
    
    
    
    /**
     写入后的回掉方法
     
     - parameter peripheral:     <#peripheral description#>
     - parameter characteristic: <#characteristic description#>
     - parameter error:          <#error description#>
     */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didWriteValueForCharacteristic")
    }
    
    /**
     <#Description#>
     
     - parameter peripheral:     <#peripheral description#>
     - parameter characteristic: <#characteristic description#>
     - parameter error:          <#error description#>
     */
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("-----didUpdateNotificationStateForCharacteristic-----")
        if (error != nil) {
            print(error.customMirror);
        }
        //Notification has started
        if(characteristic.isNotifying){
            peripheral.readValue(for: characteristic);
            print(characteristic.uuid.uuidString);
        }
    }
    
    /**
     获取外设的数据
     
     - parameter peripheral:     <#peripheral description#>
     - parameter characteristic: <#characteristic description#>
     - parameter error:          <#error description#>
     */
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("----didUpdateValueForCharacteristic---")
        
        if  characteristic.uuid.uuidString == "FFE1"  {
            let data:Data = characteristic.value!
            print(data)
            let d  = Array(UnsafeBufferPointer(start: (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), count: data.count))
            print(d)
            guard let delegate = delegate else {
                fatalError("Delegate does not exist!")
            }
            delegate.readData(d)
//            
//            let s:String =  HexUtil.encodeToString(d)
//            if s != "00" {
//                result = s
//                print(result )
//                print(result.characters.count )
//            }
//            
//            if result.characters.count == 38 || true {
//                lable.text = result
//            }
            
        }
    }
    

}
