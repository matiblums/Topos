//
//  BibliotecaViewController.swift
//  Topos
//
//  Created by Matias Blum on 1/7/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BibliotecaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var miGaleria: UICollectionView!
    var items = ["libro"]
    
    var masPaginas = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        return items.count + masPaginas
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! BibliotecaCollectionViewCell
        
        
        if(indexPath.row < items.count){
            
            
            let imgSel = self.items[indexPath.item]
            let image: UIImage = UIImage(named: imgSel)!
            
            cell.imgGaleria.image = image
            
        }
        else{
            
            let image: UIImage = UIImage(named: "agregar_pagina")!
            
            cell.imgGaleria.image = image
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let myIndex = indexPath.row
        print(myIndex)
        
        if(indexPath.row < items.count){
            
            let storyboard = UIStoryboard(name: "Video", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Video")
            controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(controller, animated: true, completion: nil)
            
        }
        else{
            
            let storyboard = UIStoryboard(name: "Seleccion", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Seleccion")
            
            controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(controller, animated: true, completion: nil)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    
    
}
