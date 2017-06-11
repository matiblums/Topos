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



class GaleriaToposViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, DDViewDelegate {
    
    @IBOutlet weak var miTopo: DDImageView!
    
    
    var items = ["topos1.png", "topos2.png", "topos3.png", "topos4.png", "topos5.png", "topos6.png", "topos7.png", "topos8.png", "topos9.png", "topos10.png", "topos11.png", "topos12.png", "topos13.png", "topos14.png", "topos15.png", "topos16.png", "topos17.png", "topos18.png", "topos19.png"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        miTopo.ddDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func viewWasDragged(view: UIView, draggedPoint: CGPoint) {
        print("Dragged Point : ", draggedPoint)
    }
    
    func viewWasDropped(view: UIView, droppedPoint: CGPoint) {
        print("Dropped Point : ", droppedPoint)
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
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! GaleriaToposCollectionViewCell
        
        
        let image: UIImage = UIImage(named: self.items[indexPath.item])!
        
        cell.imgGaleria.image = image
        
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.cyan
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let image: UIImage = UIImage(named: self.items[indexPath.item])!
        miTopo.image = image
        
    }
    
    
    

}
