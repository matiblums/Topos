//
//  GaleriaFondosViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GaleriaFondosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    

    @IBOutlet weak var miFondo: UIImageView!
    @IBOutlet weak var miGaleria: UICollectionView!
    
    @IBOutlet weak var miTopo: UIImageView!
    
    @IBOutlet weak var miFondoBotonera: UIView!

    var items = ["fondo1.jpg", "fondo2.jpg", "fondo3.jpg", "fondo4.jpg", "fondo5.jpg", "fondo6.jpg", "fondo7.jpg", "fondo8.jpg", "fondo9.jpg", "fondo10.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if((UserDefaults.standard.string(forKey: "topo")) != nil){
            
            let imgTopo = UserDefaults.standard.string(forKey: "topo")
            let topoxGuardada = UserDefaults.standard.integer(forKey: "topox")
            let topoyGuardada = UserDefaults.standard.integer(forKey: "topoy")
            let pointTopo = CGPoint(x: topoxGuardada, y: topoyGuardada)
            let imageTopo: UIImage = UIImage(named: imgTopo!)!
            miTopo.image = imageTopo
            miTopo.frame.origin = pointTopo
            
        }
        
        let imgSel = self.items[0]
        let image: UIImage = UIImage(named: imgSel)!
        miFondo.image = image
        
        miGaleria.isHidden = false
        //miFondoBotonera.isHidden = true
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
        //miFondoBotonera.isHidden = true
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let miAncho = self.view.frame.size.width / 3 - 10
        let miAlto = miAncho / 2;
        
        
        
        return CGSize(width: miAncho, height: miAlto);
    }
 
    


    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imgSel = self.items[indexPath.item]
       // let image: UIImage = UIImage(named: imgSel)!
       // miFondo.image = image
        
       // miGaleria.isHidden = true
       // miFondoBotonera.isHidden = false
       // miFondo.isHidden = false
        
        UserDefaults.standard.set(imgSel, forKey: "fondo")
        
        
               
        dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }

}



