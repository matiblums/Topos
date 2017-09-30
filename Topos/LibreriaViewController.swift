//
//  LibreriaViewController.swift
//  Topos
//
//  Created by Matias Blum on 21/7/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
//import SwiftySound
//import KDEAudioPlayer

import CoreMedia
import Foundation
import CoreData

//import KDEAudioPlayer

class LibreriaViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        let playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: "TA1", ofType: "mp3")!)
        audioPlayer = try! AVAudioPlayer(contentsOf: playYoda as URL)
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        audioPlayer.numberOfLoops = 99
        //audioPlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioPlayer.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func elijeBiblioteca(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Biblioteca", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Biblioteca") as! BibliotecaViewController
         
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func elijeDesc(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Descripcion", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Descripcion") as! DescripcionViewController
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }

}
