//
//  PeliculaViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
//import SwiftySound
//import AudioPlayer
import AVFoundation
import Foundation
import KDEAudioPlayer
import SwiftySound

class PeliculaViewController: UIViewController, AudioPlayerDelegate {
    
    @IBOutlet var miProgress: UIProgressView!
    
    @IBOutlet var miFondo: UIImageView!
    @IBOutlet var miTopo: UIImageView!
    
    @IBOutlet var tiempoRestante: UILabel!
    
    
    //var player = AudioPlayer()
    var playerFondo = AudioPlayer()
    var playerGrabado = AudioPlayer()
    
    
    //var sound1: AudioPlayer?
    //var sound2: AudioPlayer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
       // do {
         //  sound1 = try AudioPlayer(contentsOf: self.directoryURL()! as URL )
         //} catch {
           // print("Sound initialization failed")
        //}
        
        //do {
          //  let playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: "ta7", ofType: "wav")!)
           // sound2 = try AudioPlayer(contentsOf: playYoda as URL )
        //} catch {
          //  print("Sound initialization failed")
       // }

        
       // player.delegate = self
        //playerFondo.delegate = self
        playerGrabado.delegate = self
        
        
       // let sonidoMicrofono = self.directoryURL()! as URL
       // let sonidoFondo = "ta8.wav"
        
        
        
        
        
        
        //Sound.play(url: sonidoMicrofono)
        //Sound.play(file: sonidoFondo)
        
        //sound1?.play()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(self.hola), name: AudioPlayer.SoundDidFinishPlayingNotification, object: nil)

        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

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
    
    //************************************************
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateEmptyMetadataOn item: AudioItem, withData data: Metadata) {
        
        
        
    }
    
    
    func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
        
        

        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didLoad range: TimeRange, for item: AudioItem) {
        
        
        
        
        
    }
    
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
        
        print(from)
        print(state)
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        
        
        
        
        miProgress.setProgress(percentageRead / 100, animated: true)
        
       
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didFindDuration duration: TimeInterval, for item: AudioItem) {
        
        
        
        //print(player.currentItemDuration!)
        
        
        
    }
        
    
    //**************************************************
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    

    @IBAction func btnPlay(_ sender: Any) {
        
        let musicaGuardada = UserDefaults.standard.string(forKey: "musica")
        
        let playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: musicaGuardada, ofType: "wav")!)
        //let itemFondo = AudioItem(mediumQualitySoundURL: playYoda as URL)
        //playerFondo.play(item: itemFondo!)
        //playerFondo.volume = 0.5
        //playerFondo.audio
        
        Sound.play(url: playYoda as URL, numberOfLoops: 10)
        
        let itemGrabado = AudioItem(mediumQualitySoundURL: self.directoryURL()! as URL)
        playerGrabado.play(item: itemGrabado!)
        playerGrabado.volume = 1.0
        
        
        //sound1?.play()
        
        
        //sound2?.play()
        
                
    }
    
    @IBAction func btnStop(_ sender: Any) {
        
        //player.stop()
        miProgress.setProgress(0, animated: false)
        
    }
    
    func directoryURL() -> NSURL? {
        let sonidoGuardado = UserDefaults.standard.string(forKey: "audio")
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(sonidoGuardado!)
        //print(soundURL as Any)
        return soundURL as NSURL?
    }
    
    
}











