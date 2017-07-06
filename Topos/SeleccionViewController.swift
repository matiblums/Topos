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
    
    @IBOutlet var btnPlay: UIButton!
    
    @IBOutlet var btnTapa: UIButton!
    
    var paginas : [Pagina] = []
    //var fetchResultsController : NSFetchedResultsController<Pagina>!
    var pagina : Pagina?
    
    var libros : [Libro] = []
    var fetchResultsController : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    var masPaginas = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView?.dataSource = self
        //myView?.backgroundColor = UIColor.white
        
        //flowLayout?.maxCoverDegree = 0
        //flowLayout?.coverDensity = 0.25
        //flowLayout?.minCoverScale = 0.20
        //flowLayout?.minCoverOpacity = 0.7
        
        //borraDatos()
        //borraDatos()
        btnPlay.isEnabled = false
        
        
        let miLibro = self.libro
        
        let paginasTotales = (miLibro?.paginas?.count)! + masPaginas
       
        myView?.scrollToItem(at: IndexPath(item: paginasTotales - 2, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Ver ()
        self.myView?.reloadData()
        
        let miLibro = self.libro
        
        if((miLibro!.paginas?.count)! > 0){
            btnTapa.isHidden = false
        }
        else{
            btnTapa.isHidden = true
        }
        
        cargaBotones()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    @IBAction func agregaPagina(_ sender: Any) {
        /*
        masPaginas = 1
        self.myView?.reloadData()
        borraDatos()
        btnFondoVacio.isEnabled = true
        
        let miLibro = self.libro
        
        
        
        if((miLibro!.paginas?.count)!>2){
            myView?.scrollToItem(at: IndexPath(item: paginas.count, section: 0), at: .left, animated: true)
        }
        
        btnAgrega.isEnabled = false
        */
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
        let controller = storyboard.instantiateViewController(withIdentifier: "GrabarAudio")  as! GrabarAudioViewController
        controller.libro = self.libro
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
        let controller = storyboard.instantiateViewController(withIdentifier: "Tapa") as! TapaViewController
        controller.libro = self.libro
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
         UserDefaults.standard.removeObject(forKey: "tapa")
    }
    
    
    @IBAction func playPagina(_ sender: Any) {
        
        
        let indexPaths : NSArray = self.myView!.indexPathsForSelectedItems! as NSArray
        let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
        
        let miLibro = self.libro
        let miPagina = miLibro!.paginas![indexPath.row] as! Pagina
        
        let storyboard = UIStoryboard(name: "Pelicula", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Pelicula") as! PeliculaViewController
        controller.pagina = miPagina
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
        //return paginas.count + masPaginas
        let miLibro = self.libro
        let cantPaginas = miLibro!.paginas?.count
        
        return cantPaginas! + masPaginas
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SeleccionCollectionViewCell
        
        let miLibro = self.libro
        
        let paginasTotales = (miLibro?.paginas?.count)! + masPaginas
        
        
        if(indexPath.row == paginasTotales - 2){
            
            let image: UIImage = UIImage(named: "fondo0")!
            cell.imgGaleria.image = image
            
        }
        
        if(indexPath.row == 0 || indexPath.row == paginasTotales - 1){
            
            
        }
            
        if(indexPath.row > 0 && indexPath.row < paginasTotales - 2){
            
            let miPagina =  miLibro?.paginas![indexPath.row - 1] as! Pagina
            
            let imgSel = miPagina.fondo
            let image: UIImage = UIImage(named: imgSel)!
            cell.imgGaleria.image = image
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let myIndex = indexPath.row
        print(myIndex)
        
        let miLibro = self.libro
        
        let paginasTotales = (miLibro?.paginas?.count)! + masPaginas
        
        
        
        if(indexPath.row == paginasTotales - 2){
            
            borraDatos()
            myView?.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        }
            
        if(indexPath.row == 0 || indexPath.row == paginasTotales - 1){
            
            
        }
            
        if(indexPath.row > 0 && indexPath.row < paginasTotales - 2){
            
            muestraDatos()
            myView?.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
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
    
    func muestraDatos(){
        btnPlay.isEnabled = true
        
        
        btnFondo.isHidden = false
        btnTopo.isHidden = false
        btnMusica.isHidden = false
        btnAudio.isHidden = false
        
    }
    
    func borraDatos(){
        
        btnPlay.isEnabled = false
        
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
        
        btnFondoVacio.isEnabled = true
        
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
            self.myView?.reloadData()
            //btnPelicula.isHidden = false
            //masPaginas = 0
            //btnAgrega.isEnabled = true
        }
    
    
    }
    /*
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
    */
    
    /*
    func Ver (){
        let fetchRequest : NSFetchRequest<Libro> = NSFetchRequest(entityName: "Libro")
        let sortDescriptor = NSSortDescriptor(key: "fecha", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            self.fetchResultsController.delegate = self as? NSFetchedResultsControllerDelegate
            
            
            do {
                try fetchResultsController.performFetch()
                self.libros = fetchResultsController.fetchedObjects!
                
               // let dolencia = libros[0]
          
               // let fitSession =  dolencia.paginas![0] as! Pagina
                
               // self.paginas = dolencia.paginas
                
                //print(dolencia.paginas?.count)
                
                
                // cell.textLabel!.text = dateFormatter.string(from: fitSession.date! as Date)
                
                //let pagina = libros[0].paginas
                //let resultado = pagina.topo
                
                
                
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
    */
}
