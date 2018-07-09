//
//  SpeechModule.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/7/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import Foundation
import Speech

protocol SpeechDelegate {
    func recieveText(heardText:String)
}


class SpeechModule : NSObject, SFSpeechRecognizerDelegate{
    
    var delegate : SpeechDelegate?
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ar-EG"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var speechEnabled = false
    var isRunning = false
    var outputString = ""
    
    
    override init() {
        super.init()
        
        speechRecognizer.delegate = self
        authorize()
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            speechEnabled = true
        } else {
            speechEnabled = false
        }
    }
    
    func authorize(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isEnabled = false
            switch authStatus {
            case .authorized:
                isEnabled = true
            case .denied:
                isEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isEnabled = false
                print("Speech recognition not yet authorized")
            }
            self.speechEnabled = isEnabled
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            print("Noooooooooooooooooo")
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = false
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                print(result?.bestTranscription.formattedString ?? "")
                print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
                self.outputString = (result?.bestTranscription.formattedString)!
                isFinal = (result?.isFinal)!
                
                self.delegate?.recieveText(heardText: self.outputString)
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.isRunning = false
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    func toggleSpeechRecognition() {
        print("speech toggle function .... \(speechEnabled)")
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            isRunning = false
            print("Second Press")
        } else {
            isRunning = true
            startRecording()
            print("First Press")
        }
    }
  
}
