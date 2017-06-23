//
//  ViewController.swift
//  guitar
//
//  Created by lazycal on 2017/5/26.
//  Copyright © 2017年 lazycal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        let myView = self.view as! MyView
        // Unsubscribe from a characteristic value
        if let c = myView.bluetooth.writeCharacteristic {
            print("c=\(c)")
            myView.bluetooth.myPeripheral.setNotifyValue(false, for: c)
        
        // Disconnect from the device
            myView.bluetooth.myCentralManager.cancelPeripheralConnection(myView.bluetooth.myPeripheral)
        }
        super.viewWillDisappear(animated)
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
