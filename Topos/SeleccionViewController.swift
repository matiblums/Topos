//
//  SeleccionViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import LNICoverFlowLayout
import CoreData

private let reuseIdentifier = "Cell"

class SeleccionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var items = ["fondo1"]
    @IBOutlet var myView: UICollectionView?
    @IBOutlet var flowLayout: LNICoverFlowLayout?
    
    @IBOutlet var btnAgrega: UIButton!
    
    @IBOutlet var btnFondo: UIImageView!
    @IBOutlet var btnTopo: UIImageView!
    @IBOutlet var btnMusica: UIImageView!
    @IBOutlet var btnAudio: UIImageView!
    @IBOutlet var btnPelicula: UIButton!
    
    @IBOutlet var btnFondoVacio: UIButton!
    @IBOutlet var btnTopoVacio: UIButton!
    @IBOutlet var btnMusicaVacio: UIButton!
    @IBOutlet var btnAudioVacio: UIButton!
    @IBOutlet var btnPeliculaVacio: UIButton!
    
    var paginas : [Pagina] = []
    var fetchResultsController : NSFetchedResultsController<Pagina>!
    var pagina : Pagina?
    
    var masPaginas = 0
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cargaBotones ()
        Ver ()
        self.myView?.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    @IBAction func agregaPagina(_ sender: Any) {
        
        masPaginas = 1
        self.myView?.reloadData()
        borraDatos()
        btnFondoVacio.isEnabled = true
        
        if(paginas.count>2){
            myView?.scrollToItem(at: IndexPath(item: paginas.count, section: 0), at: .left, animated: true)
        }
        
        btnAgrega.isEnabled = false
        
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
    
    @IBAction func elijeVideo(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Video", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Video")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    @IBAction func elijeTapa(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Tapa", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Tapa")
        
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
        return paginas.count + masPaginas
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SeleccionCollectionViewCell
        
        if(indexPath.row < paginas.count){
            
            let pagina : Pagina!
            pagina = self.paginas[indexPath.row]
            let imgSel = pagina.fondo
            let image: UIImage = UIImage(named: imgSel)!
            cell.imgGaleria.image = image
            
            let image2: UIImage = UIImage(named: "play_pagina")!
            cell.imgPlay.image = image2
        }
        else{
            
            
            let image: UIImage = UIImage(named: "fondo0")!
            cell.imgGaleria.image = image
            
            let image2: UIImage = UIImage(named: "agregar_pagina")!
            cell.imgPlay.image = image2
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let myIndex = indexPath.row
        print(myIndex)
        //myView?.scrollToItem(at: IndexPath(item: myIndex, section: 0), at: .right, animated: true)
        
        
        if(indexPath.row < paginas.count){
            
            let pagina : Pagina!
            pagina = self.paginas[myIndex]
            
            
            
            let storyboard = UIStoryboard(name: "Pelicula", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Pelicula") as! PeliculaViewController
            controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(controller, animated: true, completion: nil)
            controller.pagina = pagina
            
            
        }
        else{
            
            //cargaBotones()
            
            //borraDatos()
            //btnFondo.isHidden = false
            
        }
        
        
        //let cell = collectionView.cellForItem(at: indexPath)
        //cell?.layer.borderWidth = 2.0
        //cell?.layer.borderColor = UIColor.white.cgColor
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)
        //cell?.layer.borderWidth = 2.0
        //cell?.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    func borraDatos(){
        
        UserDefaults.standard.removeObject(forKey: "fondo")
        UserDefaults.standard.removeObject(forKey: "topo")
        UserDefaults.standard.removeObject(forKey: "topox")
        UserDefaults.standard.removeObject(forKey: "topoy")
        UserDefaults.standard.removeObject(forKey: "musica")
        UserDefaults.standard.removeObject(forKey: "audio")
        
        btnFondo.isHidden = true
        btnTopo.isHidden = true
        btnMusica.isHidden = true
        btnAudio.isHidden = true
        
       // btnPelicula.isHidden = true
        
        btnFondoVacio.isEnabled = false
        btnTopoVacio.isEnabled = false
        btnMusicaVacio.isEnabled = false
        btnAudioVacio.isEnabled = false
        
        
        
        cargaBotones ()
    }
    
   func cargaBotones (){
    
    
    
        if((UserDefaults.standard.string(forKey: "fondo")) != nil){
            btnFondo.isHidden = false
            btnTopoVacio.isEnabled = true
        }
    
        if((UserDefaults.standard.string(forKey: "topo")) != nil){
            btnTopo.isHidden = false
            btnMusicaVacio.isEnabled = true
        }
    
        if((UserDefaults.standard.string(forKey: "musica")) != nil){
            btnMusica.isHidden = false
            btnAudioVacio.isEnabled = true
        }
    
        if((UserDefaults.standard.string(forKey: "audio")) != nil){
            btnAudio.isHidden = false
            
            //btnPelicula.isHidden = false
            masPaginas = 0
            btnAgrega.isEnabled = true
        }
    
    
    }
    
    func Ver (){
        let fetchRequest : NSFetchRequest<Pagina> = NSFetchRequest(entityName: "Pagina")
        let sortDescriptor = NSSortDescriptor(key: "fecha", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            self.fetchResultsController.delegate = self as? NSFetchedResultsControllerDelegate
            
            
            do {
                try fetchResultsController.performFetch()
                self.paginas = fetchResultsController.fetchedObjects!
                
                //let dolencia = dolencias[3]
                
                // for name in casos {
                
                //   let caso = name
                //print (caso.caso)
                
                
                // }
                
                //self.tableView.refreshControl?.endRefreshing()
                //tableView.reloadData()
                
                //print("---: \(dolencia.nombre) ---: \(dolencias.count)")
                
                
            } catch {
                print("Error: \(error)")
            }
            
        }
        
    }
}
