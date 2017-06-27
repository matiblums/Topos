//
//  GaleriaMusicaViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
//import SwiftySound
import KDEAudioPlayer

private let reuseIdentifier = "Cell"

class GaleriaMusicaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, AudioPlayerDelegate {
    
    var items = ["cancion_transparente", "cancion_transparente", "cancion_transparente", "cancion_transparente", "cancion_transparente", "cancion_transparente", "cancion_transparente", "cancion_transparente"]
    
    var itemsSounds = ["ta1", "ta2", "ta3", "ta4", "ta5", "ta6", "ta7", "ta8"]

    var tocado = ""
    
    var playerFondo = AudioPlayer()
    
    @IBOutlet var miProgress: UIProgressView!
    
    @IBOutlet var miFondo: UIImageView!
    @IBOutlet var miTopo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        playerFondo.delegate = self
        
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        
        //Sound.play(file: tocado)
        let playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: tocado, ofType: "wav")!)
        let itemFondo = AudioItem(mediumQualitySoundURL: playYoda as URL)
        
        playerFondo.play(item: itemFondo!)
        playerFondo.volume = 1.0
    }
    
    @IBAction func btnPausa(_ sender: Any) {
        
        
        //Sound.stop(file: tocado)
        //Sound.stopAll()
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        
        playerFondo.stop()
        dismiss(animated: true, completion: nil)
        
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! GaleriaMusicaCollectionViewCell
        
        
         
        let image: UIImage = UIImage(named: self.items[indexPath.item])!
        
        cell.imgGaleria.image = image
        
        
        
        return cell
    }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Sound.stop(file: tocado)
        
        tocado = itemsSounds[indexPath.row]
        
        //Sound.play(file: tocado)
        
        let playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: tocado, ofType: "wav")!)
        let itemFondo = AudioItem(mediumQualitySoundURL: playYoda as URL)
        
        playerFondo.play(item: itemFondo!)
        playerFondo.volume = 1.0
        
        UserDefaults.standard.set(tocado, forKey: "musica")
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
    
    
}
