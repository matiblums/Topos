//
//  GaleriaFondosViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GaleriaFondosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var miFondo: UIImageView!
    @IBOutlet weak var miGaleria: UICollectionView!
    
    @IBOutlet weak var miFondoBotonera: UIView!

    var items = ["fondo1", "fondo2", "fondo3", "fondo4", "fondo5", "fondo6", "fondo7", "fondo8", "fondo9", "fondo10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let imgSel = self.items[0]
        let image: UIImage = UIImage(named: imgSel)!
        miFondo.image = image
        
        miGaleria.isHidden = false
        miFondoBotonera.isHidden = true
        miFondo.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func muestraFondo(_ sender: Any) {
        
        miGaleria.isHidden = false
        miFondoBotonera.isHidden = true
        miFondo.isHidden = true
        
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
                                                      for: indexPath) as! GaleriaFondosCollectionViewCell
        
        
        let imgSel = self.items[indexPath.item]
        let image: UIImage = UIImage(named: imgSel)!
        
        cell.imgGaleria.image = image
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imgSel = self.items[indexPath.item]
        let image: UIImage = UIImage(named: imgSel)!
        miFondo.image = image
        
        miGaleria.isHidden = true
        miFondoBotonera.isHidden = false
        miFondo.isHidden = false
        
        UserDefaults.standard.set(imgSel, forKey: "fondo")
    }

}
