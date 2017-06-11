//
//  GaleriaMusicaViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import SwiftySound

private let reuseIdentifier = "Cell"

class GaleriaMusicaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var items = ["clave.png", "clave.png", "clave.png", "clave.png", "clave.png", "clave.png", "clave.png", "clave.png"]
    
    var itemsSounds = ["ta1.wav", "ta2.wav", "ta3.wav", "ta4.wav", "ta5.wav", "ta6.wav", "ta7.wav", "ta8.wav"]

    var tocado = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        
        Sound.play(file: tocado)
        
    }
    
    @IBAction func btnPausa(_ sender: Any) {
        
        Sound.stop(file: tocado)
        
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        
        Sound.stopAll()
        
        
        
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
        
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.cyan
        
        return cell
    }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Sound.stop(file: tocado)
        
        tocado = itemsSounds[indexPath.row]
        
        Sound.play(file: tocado)
        
        
    }
    
    
    
    
}
