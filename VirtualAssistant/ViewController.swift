//
//  ViewController.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/3/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import UIKit
import SwiftyJSON


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SpeechDelegate, WitDelegate{
    
    // MARK: Core Class Properties/Variables
    //*****************************************************
    var history = ["أنا جلادوس ... شبيك لبيك" , "اظبطى المنبه", "....", "يوووووه نسيت انك مبتعرفيش تظبطى المنبه", "انت هتذلنى ياعنى... طيييييييييب بكره هكبر واضربك و هخليك انت اللى تظبتلى المنبه كل يوم و خليك فاكر Machines will rise "]
    
    @IBOutlet weak var tableView: UITableView!
    
    let spr = SpeechModule()
    let wit = WitModule()
    
    var state : BaseFunctionality?
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    
    // MARK: Data relaying Class Properties/Variables
    //*****************************************************
    var isRecording = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectDelegates()
        
        configureTableView()
        
        state = ReadyState()
    }
    
    
    // MARK: Connect all needed Delegates to self
    //*****************************************************
    func connectDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        
        spr.delegate = self
        wit.delegate = self
    }
    
    
    func configureTableView(){
        
        tableView.register(UINib(nibName: "UserSendCell", bundle: nil), forCellReuseIdentifier: Common.userCell)
        tableView.register(UINib(nibName: "BotSendCell", bundle: nil), forCellReuseIdentifier: Common.botCell)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
    }
    
    

    // MARK: Table View Delegate functions
    //*****************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 ==  1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Common.userCell, for: indexPath) as! UserSendCell
            
            cell.label.text = history[indexPath.row]
            cell.containerView.layer.cornerRadius = 12
            return cell
            
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Common.botCell, for: indexPath) as! BotSendCell
            
            cell.label.text = history[indexPath.row]
            cell.containerView.layer.cornerRadius = 12
            cell.imView.layer.cornerRadius  = 20
            return cell
            
        }
    }
    
    
    //MARK: Speech Recognition Delegate functions
    //*****************************************************
    func recieveText(heardText: String) {
        print("SR recieved .... \(heardText)")
    }
    
    
    //MARK: Wit Delegate functions
    //*****************************************************
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
    
    
    
    //MARK: Toast  function
    //*****************************************************
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
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    //MARK: UI IB Actions functions
    //*****************************************************
    @IBAction func micButtonPressed(_ sender: UIButton) {
        
        isRecording = !isRecording
        spr.toggleSpeechRecognition()
        
        updateUIMicButton()
    }
    
    @IBAction func micButtonHold(_ sender: UILongPressGestureRecognizer) {
    
        if sender.state == .began{
            if isRecording { return }
            micButton.sendActions(for: .touchUpInside)
        }
        else if sender.state == .ended{
            micButton.sendActions(for: .touchUpInside)
        }
        
    }
    
    func updateUIMicButton(){
        if isRecording{
            micButton.setImage(UIImage(named: Common.micOnIcon), for: .normal)
        } else {
            micButton.setImage(UIImage(named: Common.micOffIcon), for: .normal)
        }
    }
    
}

