//
//  SeleccionViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import LNICoverFlowLayout

private let reuseIdentifier = "Cell"

class SeleccionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var items = ["fondo1", "fondo2", "fondo3", "fondo4", "fondo5", "fondo6"]
    @IBOutlet var myView: UICollectionView?
    @IBOutlet var flowLayout: LNICoverFlowLayout?
    
    @IBOutlet var btnFondo: UIButton!
    @IBOutlet var btnTopo: UIButton!
    @IBOutlet var btnMusica: UIButton!
    @IBOutlet var btnAudio: UIButton!
    @IBOutlet var btnPelicula: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView?.dataSource = self
        //myView?.backgroundColor = UIColor.white
        
        flowLayout?.maxCoverDegree = 0
        flowLayout?.coverDensity = 0.25
        flowLayout?.minCoverScale = 0.50
        flowLayout?.minCoverOpacity = 0.7
        
        borraDatos()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cargaBotones ()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func agregaPagina(_ sender: Any) {
        
        items.append("fondo0")
        
        self.myView?.reloadData()
        
        if(items.count>2){
            myView?.scrollToItem(at: IndexPath(item: items.count-1, section: 0), at: .left, animated: true)
        }
        
        
        
        
        
      
    }
    
    //*****************************************************************************************
    @IBAction func elijeFondo(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "GaleriaFondos", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GaleriaFondos")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func elijeTopo(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "GaleriaTopos", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GaleriaTopos")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func elijeMusica(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "GaleriaMusica", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GaleriaMusica")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func elijeAudio(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "GrabarAudio", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GrabarAudio")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func elijePelicula(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Pelicula", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Pelicula")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    //*****************************************************************************************
    
    
    
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
                                                      for: indexPath) as! SeleccionCollectionViewCell
        
        
        let imgSel = self.items[indexPath.item]
        let image: UIImage = UIImage(named: imgSel)!
        
        cell.imgGaleria.image = image
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let imgSel = self.items[indexPath.item]
        //let image: UIImage = UIImage(named: imgSel)!
       // miFondo.image = image
        
       // UserDefaults.standard.set(imgSel, forKey: "fondo")
        
        
        borraDatos()
        
    }

    func borraDatos(){
        
        UserDefaults.standard.removeObject(forKey: "fondo")
        UserDefaults.standard.removeObject(forKey: "topo")
        UserDefaults.standard.removeObject(forKey: "topox")
        UserDefaults.standard.removeObject(forKey: "topoy")
        UserDefaults.standard.removeObject(forKey: "musica")
        UserDefaults.standard.removeObject(forKey: "audio")
        
        btnFondo.isHidden = false
        
        btnTopo.isHidden = true
        btnMusica.isHidden = true
        btnAudio.isHidden = true
        btnPelicula.isHidden = true
        
        cargaBotones ()
    }
    
   func cargaBotones (){
    
    
    
        if((UserDefaults.standard.string(forKey: "fondo")) != nil){
            btnTopo.isHidden = false
        }
    
        if((UserDefaults.standard.string(forKey: "topo")) != nil){
            btnMusica.isHidden = false
        }
    
        if((UserDefaults.standard.string(forKey: "musica")) != nil){
            btnAudio.isHidden = false
        }
    
        if((UserDefaults.standard.string(forKey: "audio")) != nil){
            btnPelicula.isHidden = false
        }
    
    
    }
    
    
}
