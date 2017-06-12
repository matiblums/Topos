//
//  PeliculaViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import SwiftySound
import AudioPlayer

class PeliculaViewController: UIViewController {
    
    
    @IBOutlet var miFondo: UIImageView!
    @IBOutlet var miTopo: UIImageView!
    
    var sound1: AudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            sound1 = try AudioPlayer(contentsOf: self.directoryURL()! as URL )
        } catch {
            print("Sound initialization failed")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        
        //Sound.stopAll()
       print( sound1?.currentTime)
        
    }
    

    @IBAction func btnPlay(_ sender: Any) {
        
        let sonidoMicrofono = self.directoryURL()! as URL
        let sonidoFondo = "ta1.wav"
        let imgFondo = "fondo3.jpg"
        let imgTopo = "topos1.png"
        let pointTopo = CGPoint(x: 0, y: 0)
        
        
        //Sound.play(url: sonidoMicrofono)
        //Sound.play(file: sonidoFondo)
        
        sound1?.play()
        
        let imageFondo: UIImage = UIImage(named: imgFondo)!
        miFondo.image = imageFondo
        
        let imageTopo: UIImage = UIImage(named: imgTopo)!
        miTopo.image = imageTopo
 
        miTopo.frame.origin = pointTopo
        
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound2.m4a")
        print(soundURL as Any)
        return soundURL as NSURL?
    }
    
    
}
