//
//  GaleriaToposViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import DragDropUI

private let reuseIdentifier = "Cell"



class GaleriaToposViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DDViewDelegate {
    
    @IBOutlet weak var miTopo: DDImageView!
    
    @IBOutlet weak var miFondo: UIImageView!
    
    @IBOutlet weak var miGaleria: UICollectionView!
    
    @IBOutlet weak var miFondoBotonera: UIButton!
    
    @IBOutlet weak var viewFondo: UIView!
    
    
    
    
    var items = ["topos1.png", "topos2.png", "topos3.png", "topos4.png", "topos5.png", "topos6.png", "topos7.png", "topos8.png", "topos9.png", "topos10.png", "topos11.png", "topos12.png", "topos13.png", "topos14.png", "topos15.png", "topos16.png", "topos17.png", "topos18.png", "topos19.png"]
    
    var itemsChico = ["topos1Chico.png", "topos2Chico.png", "topos3Chico.png", "topos4Chico.png", "topos5Chico.png", "topos6Chico.png", "topos7Chico.png", "topos8Chico.png", "topos9Chico.png", "topos10Chico.png", "topos11Chico.png", "topos12Chico.png", "topos13Chico.png", "topos14Chico.png", "topos15Chico.png", "topos16Chico.png", "topos17Chico.png", "topos18Chico.png", "topos19Chico.png"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        miTopo.ddDelegate = self
        
        // Do any additional setup after loading the view.
        if((UserDefaults.standard.string(forKey: "fondo")) != nil){
            
            let fondoGuardado = UserDefaults.standard.string(forKey: "fondo")
            let image: UIImage = UIImage(named: fondoGuardado!)!
            miFondo.image = image
            
        }
        
        
        //let imgSel = self.items[0]
        //let imageTopo: UIImage = UIImage(named: imgSel)!
        //miTopo.image = imageTopo
        //let pointTopo = CGPoint(x: 100, y: 100)
        //miTopo.frame.origin = pointTopo
        
        
        miGaleria.isHidden = false
        miFondoBotonera.isHidden = true
        miTopo.isHidden = true
        
        viewFondo.isHidden = false
        
        
    }
    
    func viewWasDragged(view: UIView, draggedPoint: CGPoint) {
        print("Dragged Point : ", draggedPoint)
    }
    
    func viewWasDropped(view: UIView, droppedPoint: CGPoint) {
        print("Dropped Point : ", droppedPoint)
        
        
        self.view.bringSubview(toFront: miFondoBotonera)
        
        
       
    }
    
    @IBAction func btnSalir(_ sender: Any) {
       // let miY = miTopo.frame.origin.y
       // let miX = miTopo.frame.origin.x
        
        
        UserDefaults.standard.set(miTopo.frame.origin.x, forKey: "topox")
        UserDefaults.standard.set(miTopo.frame.origin.y, forKey: "topoy")
        
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func muestraTopos(_ sender: Any) {
        
        miGaleria.isHidden = false
        viewFondo.isHidden = false
        miFondoBotonera.isHidden = true
        miTopo.isHidden = true
        
    }
    
    @IBAction func scaleImage(_ sender: UIPinchGestureRecognizer) {
        miTopo.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let miAncho = self.view.frame.size.width / 2 - 0
        let miAlto = miAncho / 2;
        
        
        
        return CGSize(width: miAncho, height: miAlto);
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! GaleriaToposCollectionViewCell
        
        let imgSel = self.itemsChico[indexPath.item]
        let image: UIImage = UIImage(named: imgSel)!
        
        cell.imgGaleria.image = image
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imgSel = self.items[indexPath.item]
        let image: UIImage = UIImage(named: imgSel)!
        miTopo.image = image
        
        miGaleria.isHidden = true
        viewFondo.isHidden = true
        miFondoBotonera.isHidden = false
        miTopo.isHidden = false
        
        UserDefaults.standard.set(imgSel, forKey: "topo")
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.white.cgColor
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }
    

}
