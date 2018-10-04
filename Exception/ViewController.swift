//
//  ViewController.swift
//  Exception
//
//  Created by Kare on 2018/10/4.
//  Copyright © 2018 xxxxxxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signalAction() {
        let mac = malloc(1024)
        defer {
            free(mac)
            free(mac)
        }
    }
    
    @IBAction func execptionAction() {
        let ary = [Int]()
        print(ary[100])
    }
}

