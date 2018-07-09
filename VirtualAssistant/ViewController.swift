//
//  ViewController.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/3/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SpeechDelegate, WitDelegate, ChatDelegate{
    
    // MARK: Core Class Properties/Variables
    //*****************************************************
    
    var history : [Message] = [Message]()
    
    @IBOutlet weak var tableView: UITableView!
    
    let spr = SpeechModule()
    let wit = WitModule()
    
    var state : BaseFunctionality?
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomPinningConstraint: NSLayoutConstraint!
    
    // MARK: Data relaying Class Properties/Variables
    //*****************************************************
    var isRecording = false
    
    var isVoiceMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectDelegates()
        
        configureTableView()
        
        state = ReadyState()
        
        presentInChat(text: "إزايك ؟ أقدر اساعدك إزاى؟؟", fromUser: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: .UIKeyboardWillHide, object: nil)
        
        //sendButton.layer.cornerRadius = 3
    }
    
    
    
    // MARK: Connect all needed Delegates to self
    // Except Delegate for Chat is set on the fly
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
        
        if history[indexPath.row].isUserSender{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Common.userCell, for: indexPath) as! UserSendCell
            
            cell.label.text = history[indexPath.row].messageText
            cell.containerView.layer.cornerRadius = 12
            return cell
            
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Common.botCell, for: indexPath) as! BotSendCell
            
            cell.label.text = history[indexPath.row].messageText
            cell.containerView.layer.cornerRadius = 12
            cell.imView.layer.cornerRadius  = 20
            return cell
            
        }
    }
    
    
    //MARK: Speech Recognition Delegate functions
    //*****************************************************
    func recieveText(heardText: String) {
        print("SR recieved .... \(heardText)")
        
        sendTextToWit(incomingText: heardText)
    }
    
    
    //MARK: Wit Delegate functions
    //*****************************************************
    func recieveResponse(response: JSON) {
        SVProgressHUD.dismiss()
        print("Here***********************************")
        print(response.rawString()!)
        print(response[Common.witEntities][Common.witIntent][0][Common.value])
        print(response[Common.witEntities][Common.witIntent][0][Common.confidence])
        
        state?.delegate = self
        state = state?.whatNextState(response: response)
        state?.delegate = self
        state = state?.processResponse(response: response)
    }
    
    func sendTextToWit(incomingText: String){
        presentInChat(text: incomingText, fromUser: true)
        
        SVProgressHUD.show()
        print("showing hud .... \(incomingText)")
        wit.witNetwork(toBeSentString: incomingText)
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
    
    //MARK: Keyboard Notification Handling Function
    //*****************************************************
    @objc func keyboardHandler(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            
            self.bottomPinningConstraint.constant = isKeyboardShowing ? -1 * keyboardSize.height : 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            //            { (isSuccess) in
            //
            //                if isKeyboardShowing{
            //                    let indexPath = IndexPath(row: self.history.count - 1, section: 0)
            //                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            //                }
            //            }
        }
    }
    
    
    //MARK: Chat Delegate Functions
    //*****************************************************
    func presentInChat(text: String, fromUser: Bool) {
        print("Drawing a new bubble")
        let newMessage = Message(text: text, isUser: fromUser)
        
        history.append(newMessage)
        print(history)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func presentInToast(text: String) {
        showToast(message: text)
    }
    
    
    //MARK: UI IB Actions functions
    //*****************************************************
    @IBAction func micButtonPressed(_ sender: UIButton) {
        isRecording = !isRecording
        updateUIMicButton()
        spr.toggleSpeechRecognition()
        
        
        // Test:
        //        var text = ""
        //        if isRecording{
        //            text = "افتح الفيسبوك"
        //        }
        //        else{
        //            text = "افتحيلى الواتس"
        //        }
        //        sendTextToWit(incomingText: text)
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
        
        DispatchQueue.main.async {
            if self.isRecording{
                self.micButton.setImage(UIImage(named: Common.micOnIcon), for: .normal)
                print("mic on icon")
            } else {
                self.micButton.setImage(UIImage(named: Common.micOffIcon), for: .normal)
                print("mic off icon")
            }
        }
    }
    
    
    @IBAction func keyboardButtonPressed(_ sender: UIButton) {
        isVoiceMode = !isVoiceMode
        
        DispatchQueue.main.async {
            print("in here .... \(self.isVoiceMode)")
            
            if self.isVoiceMode {
                
                self.keyboardButton.setImage(UIImage(named: Common.showKeyboard), for: .normal)
                
                self.keyboardView.isHidden = true
                self.micButton.isHidden = false
                
                self.micButton.setImage(UIImage(named: Common.micOffIcon), for: .normal)
                
                self.textField.endEditing(true)
                
            } else {
                self.keyboardButton.setImage(UIImage(named: Common.dismissKeyboard), for: .normal)
                
                self.keyboardView.isHidden = false
                self.micButton.isHidden = true
                
            }
            
        }
        
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if textField.text!.isEmpty {return}
        
        let text = textField.text!
        textField.text = ""
        sendTextToWit(incomingText: text)
        
        keyboardButton.sendActions(for: .touchUpInside)
    }
    
}

