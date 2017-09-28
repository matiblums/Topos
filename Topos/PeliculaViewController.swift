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
import CoreData

class PeliculaViewController: UIViewController, AudioPlayerDelegate {
    
    //@IBOutlet var miProgress: UIProgressView!
    
    @IBOutlet var miFondo: UIImageView!
    @IBOutlet var miTopo: UIImageView!
    
    @IBOutlet var tiempoRestante: UILabel!
    
    
    //var player = AudioPlayer()
    var playerFondo = AudioPlayer()
    var playerGrabado = AudioPlayer()
    
    
    //var sound1: AudioPlayer?
    //var sound2: AudioPlayer?
    
    
    var paginas : [Pagina] = []
    var fetchResultsControllerPagina : NSFetchedResultsController<Pagina>!
    var pagina: Pagina?
    
    var libros : [Libro] = []
    var fetchResultsController : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerGrabado.delegate = self

        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        Ver ()
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
        
        if(state == AudioPlayerState.stopped){
            
            Sound.stopAll()
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        
        
        
        
        //miProgress.setProgress(percentageRead / 100, animated: true)
        
       
        
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
    
    @IBAction func btnBorrar(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        Borrar ()
        
    }

    @IBAction func btnPlay(_ sender: Any) {
       
        
        
        Sound.stopAll()
        
                
    }
    
    @IBAction func btnStop(_ sender: Any) {
        
        //player.stop()
        //miProgress.setProgress(0, animated: false)
        
    }
    
    func directoryURL() -> NSURL? {
        let sonidoGuardado = self.pagina?.audio
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(sonidoGuardado!)
        //print(soundURL as Any)
        return soundURL as NSURL?
    }
    
    
    func Ver (){
        
        let fondo = self.pagina?.fondo
        let topo = self.pagina?.topo
        let topox = self.pagina?.topox
        let topoy = self.pagina?.topoy
        
        let pointTopo = CGPoint(x: Int(topox!)!, y: Int(topoy!)!)
        let imageFondo: UIImage = UIImage(named: fondo!)!
        miFondo.image = imageFondo
        
        let imageTopo: UIImage = UIImage(named: topo!)!
        miTopo.image = imageTopo
        
        miTopo.frame.origin = pointTopo
    
        
        let musicaGuardada = self.pagina?.musica
        let playYoda = URL(fileURLWithPath: Bundle.main.path(forResource: musicaGuardada, ofType: "mp3")!)
        //Sound.play(url: playYoda as URL, numberOfLoops: 10)
        
        //let mySound = Sound(url: playYoda as URL)!
        //mySound.play()
       // mySound?.volume = 1.0
        
        let itemFondo = AudioItem(mediumQualitySoundURL: playYoda as URL)
        playerFondo.play(item: itemFondo!)
        playerFondo.volume = 1.0
        
        let itemGrabado = AudioItem(mediumQualitySoundURL: self.directoryURL()! as URL)
        playerGrabado.play(item: itemGrabado!)
        playerGrabado.volume = 1.0

    
    }
    
    func Borrar () {
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
        
                
                context.delete(pagina!)
                
                
               
                
                do {
                    try context.save()
                    print("borrado!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
                
                
                
          
            
        }

        
    }

}











