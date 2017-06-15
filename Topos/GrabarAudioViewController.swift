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
//import KDEAudioPlayer

import CoreMedia
import Foundation




class GrabarAudioViewController: UIViewController ,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    var audioPlayer : AVAudioPlayer!
    //var playerGrabado = AudioPlayer()
    
    @IBOutlet var botonRecOn: UIButton!
    @IBOutlet var botonPlay: UIButton!
    @IBOutlet var myProgress: UIProgressView!
    var updater : CADisplayLink! = nil
    
    
    @IBOutlet var miFondo: UIImageView!
    @IBOutlet var miTopo: UIImageView!
    
    
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
                        //print("Allow")
                    } else {
                        //print("Dont Allow")
                    }
                }
            }
        } catch {
            //print("failed to record!")
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        botonPlay.isHidden = true
        
        
        let imgFondo = UserDefaults.standard.string(forKey: "fondo")
        let imgTopo = UserDefaults.standard.string(forKey: "topo")
        let topoxGuardada = UserDefaults.standard.integer(forKey: "topox")
        let topoyGuardada = UserDefaults.standard.integer(forKey: "topoy")
        let pointTopo = CGPoint(x: topoxGuardada, y: topoyGuardada)
        let imageFondo: UIImage = UIImage(named: imgFondo!)!
        miFondo.image = imageFondo
        
        let imageTopo: UIImage = UIImage(named: imgTopo!)!
        miTopo.image = imageTopo
        
        miTopo.frame.origin = pointTopo
        
    }
    
    @IBAction func btnGraba(_ sender: Any) {
        
        self.startRecording()
        
        botonPlay.isHidden = true
        
        myProgress.setProgress(0, animated: false)
        
    }
    
    @IBAction func btnGrabaStop(_ sender: Any) {
        
        self.finishRecording(success: true)
        
        botonPlay.isHidden = false
        
    }
    
    
    
    @IBAction func btnPlay(_ sender: Any) {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        
       // audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,settings: settings)
        
        if !audioRecorder.isRecording {
            //audioPlayer = try! AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer = try! AVAudioPlayer(contentsOf: self.directoryURL()! as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.play()
        }
        
        updater = CADisplayLink(target: self,
                                        selector: #selector(step))
        
        updater.add(to: .current,
                        forMode: .defaultRunLoopMode)
        
        myProgress.setProgress(0, animated: false)
        
        botonPlay.isHidden = true
    }
    
 
    
    func step(updater: CADisplayLink) {
        //print(updater.timestamp)
        let normalizedTime = Float(audioPlayer.currentTime * 1.0 / audioPlayer.duration)
        
        myProgress.setProgress(normalizedTime, animated: true)
        
        
       print( myProgress.progress)
        
        
        
    }
    
    
    @IBAction func btnSalir(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    //***************************************************************************
    func directoryURL() -> NSURL? {
        
        let nombreArchivo = "sound2.m4a"
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(nombreArchivo)
        
        UserDefaults.standard.set(nombreArchivo, forKey: "audio")
        
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
            //print(success)
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
        
        updater.invalidate()
        myProgress.setProgress(1, animated: true)
        botonPlay.isHidden = false
    }
   
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print(player.debugDescription)
    }
    
    //***************************************************************************
}

