//
//  ViewController.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/3/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import UIKit
import SwiftyJSON


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WitDelegate{
    
    var history = ["Hey man how's it going??", "أقدر اساعدك ازاى؟", "فى حاجة تانية ممكن اعملهالك؟", "Shit duuuuuuuUPDATE: We have added the new iPhone X, iPhone 8 and iPhone 8 Plus to the guide below. To learn more about the unique screen of iPhone X, check out our new iPhone X Screen Demystified article.uuuude that's dope", "Sup with the whacky playstation sup"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    let wit = WitModule()
    
    var state : BaseFunctionality?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        connectDelegates()
        
        configureTableView()
        
        state = ReadyState()
    }
    
    // MARK: Connect all needed Delegates to self
    func connectDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        
        wit.delegate = self
    }
    
    
    func configureTableView(){
        
        tableView.register(UINib(nibName: "UserSendCell", bundle: nil), forCellReuseIdentifier: Common.userCell)
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 120
        
    }
    
    

    // MARK: Table View Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Common.userCell, for: indexPath) as! UserSendCell
        
        cell.label.text = history[indexPath.row]
        cell.containerView.layer.cornerRadius = 15
        
        return cell
        
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    @IBAction func goButtonPressed(_ sender: UIButton) {
        var text = textField.text
        textField.text = ""
        
        //text = "شغل النور"
        //state = ReadyState()
        
        wit.witNetwork(toBeSentString: text!)
        
    }
    
    func recieveResponse(response: JSON) {
        print("Here***********************************")
        print(response.rawString()!)
        print(response.count)
        print(response[Common.witEntities][Common.witIntent][0][Common.value])
        print(response[Common.witEntities][Common.witIntent][0][Common.confidence])
        showToast(message: "\(response[Common.witEntities][Common.witIntent][0][Common.value]) intent")
        
        state = state?.whatNextState(response: response)
        state?.processResponse(response: response)
    }
    
}

