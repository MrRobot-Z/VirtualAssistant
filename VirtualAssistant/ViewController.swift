//
//  ViewController.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/3/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController ,WitDelegate{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    let wit = WitModule()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        wit.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goButtonPressed(_ sender: UIButton) {
        var text = textField.text
        textField.text = ""
        
        text = "صحينى بكره الساعة خامسة"
        
        wit.witNetwork(toBeSentString: text!)
        
    }
    
    func recieveResponse(response: JSON) {
        print("Here***********************************")
        print(response.rawString()!)
        print(response.count)
        print(response["entities"]["intent"][0]["value"])
        print(response["entities"]["intent"][0]["confidence"])
    }
    
}

