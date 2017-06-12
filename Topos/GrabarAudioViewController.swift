//
//  ViewController.swift
//  FDSoundActivatedRecorder
//
//  Created by William Entriken on 1/30/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SwiftySound


var recordingSession : AVAudioSession!
var audioRecorder    :AVAudioRecorder!
var settings         = [String : Int]()

var audioPlayer : AVAudioPlayer!
class GrabarAudioViewController: UIViewController ,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //***************************************************************************
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Allow")
                    } else {
                        print("Dont Allow")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
        
        // Audio Settings
        
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        //***************************************************************************
        //self.directoryURL()
    }
    
    @IBAction func btnGraba(_ sender: Any) {
        
        self.startRecording()
        
    }
    
    @IBAction func btnGrabaStop(_ sender: Any) {
        
        self.finishRecording(success: true)
        
    }
    
    
    
    @IBAction func btnPlay(_ sender: Any) {
        
       // audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,settings: settings)
        
        if !audioRecorder.isRecording {
            //audioPlayer = try! AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer = try! AVAudioPlayer(contentsOf: self.directoryURL()! as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.play()
        }
    }
    
    @IBAction func btnPlay2(_ sender: Any) {
        
        /*
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: self.directoryURL()! as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.play()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        catch {
            print("AVAudioPlayer init failed")
        }
         */
        
        Sound.play(url: self.directoryURL()! as URL)
    
    }
    
  
    
    //***************************************************************************
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound2.m4a")
        print(soundURL as Any)
        return soundURL as NSURL?
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success {
            print(success)
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print(player.debugDescription)
    }
    
    //***************************************************************************
}

