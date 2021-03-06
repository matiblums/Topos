//
//  GaleriaTapasViewController.swift
//  Topos
//
//  Created by Matias Blum on 1/7/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GaleriaTapasViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var miGaleria: UICollectionView!
    
    var items = ["tapa1","tapa2","tapa3","tapa4","tapa5","tapa6","tapa7","tapa8","tapa9","tapa10"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func elijeSalir(_ sender: Any) {
        
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
                                                      for: indexPath) as! GaleriaTapasCollectionViewCell
        
        
        let imgSel = self.items[indexPath.item]
        let image: UIImage = UIImage(named: imgSel)!
        
        cell.imgGaleria.image = image
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let miAncho = self.view.frame.size.width / 3 - 10
        let miAlto = miAncho / 2;
        
        
        
        return CGSize(width: miAncho, height: miAlto);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imgSel = self.items[indexPath.item]
        //let image: UIImage = UIImage(named: imgSel)!
        //miFondo.image = image
        
        //miGaleria.isHidden = true
        //miFondoBotonera.isHidden = false
        //miFondo.isHidden = false
        
        
        UserDefaults.standard.set(imgSel, forKey: "tapa")
        
        dismiss(animated: true, completion: nil)
        
        //let cell = collectionView.cellForItem(at: indexPath)
        //cell?.layer.borderWidth = 2.0
        //cell?.layer.borderColor = UIColor.white.cgColor
 
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }



}
