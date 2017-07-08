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
    @IBOutlet var btnCierraPagina: UIButton!
    
    
    
    @IBOutlet var btnFondoVacio: UIButton!
    @IBOutlet var btnTopoVacio: UIButton!
    @IBOutlet var btnMusicaVacio: UIButton!
    @IBOutlet var btnAudioVacio: UIButton!
    @IBOutlet var btnPeliculaVacio: UIButton!
    
    @IBOutlet var btnPlay: UIButton!
    
    @IBOutlet var btnTapa: UIButton!
    
    var paginas : [Pagina] = []
    var fetchResultsControllerPagina : NSFetchedResultsController<Pagina>!
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
    
    @IBAction func cerrarPagina(_ sender: Any) {
        grabar()
        borraDatos()
        self.myView?.reloadData()
        let miLibro = self.libro
        let paginasTotales = (miLibro?.paginas?.count)! + masPaginas
        
        myView?.scrollToItem(at: IndexPath(item: paginasTotales - 2, section: 0), at: .centeredHorizontally, animated: true)
        
        
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
            
            if((UserDefaults.standard.string(forKey: "fondo")) != nil){
                
                let image: UIImage = UIImage(named: UserDefaults.standard.string(forKey: "fondo")!)!
                cell.imgGaleria.image = image
                
            }
            else{
                
                let image: UIImage = UIImage(named: "fondo0")!
                cell.imgGaleria.image = image
                
            }
            
            
        }
        
        if(indexPath.row == 0 || indexPath.row == paginasTotales - 1){
            
            //let image: UIImage = UIImage(named: "fondo0")!
            cell.imgGaleria.image = nil
            
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
        
        
       // btnFondo.isHidden = false
       // btnTopo.isHidden = false
       // btnMusica.isHidden = false
      //  btnAudio.isHidden = false
        
    }
    
    func borraDatos(){
        
        btnPlay.isEnabled = false
        
        UserDefaults.standard.removeObject(forKey: "fondo")
        UserDefaults.standard.removeObject(forKey: "topo")
        UserDefaults.standard.removeObject(forKey: "topox")
        UserDefaults.standard.removeObject(forKey: "topoy")
        UserDefaults.standard.removeObject(forKey: "musica")
        UserDefaults.standard.removeObject(forKey: "audio")
        
        //btnFondo.isHidden = true
        //btnTopo.isHidden = true
        //btnMusica.isHidden = true
        //btnAudio.isHidden = true
        
       // btnPelicula.isHidden = true
        
        //btnFondoVacio.isEnabled = false
        //btnTopoVacio.isEnabled = false
        //btnMusicaVacio.isEnabled = false
        //btnAudioVacio.isEnabled = false
        
        //btnFondoVacio.isEnabled = true
        
        //cargaBotones ()
    }
    
   func cargaBotones (){
    
        if((UserDefaults.standard.string(forKey: "fondo")) != nil){
            
            if((UserDefaults.standard.string(forKey: "topo")) != nil){
                
                if((UserDefaults.standard.string(forKey: "musica")) != nil){
                    
                    if((UserDefaults.standard.string(forKey: "audio")) != nil){
                        
                        btnCierraPagina.isEnabled = true
        
                    }
                }
    
            }
        }
        else{
            
          btnCierraPagina.isEnabled = false
            
        }
    
        self.myView?.reloadData()
    }
    
    //***************************************************************************
    
    func grabar() {
        
        
        let topo = UserDefaults.standard.string(forKey: "topo")
        let topox = UserDefaults.standard.integer(forKey: "topox")
        let topoy = UserDefaults.standard.integer(forKey: "topoy")
        let fondo = UserDefaults.standard.string(forKey: "fondo")
        let musica = UserDefaults.standard.string(forKey: "musica")
        let audio = UserDefaults.standard.string(forKey: "audio")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        _ = formatter.string(from: date)
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.pagina = NSEntityDescription.insertNewObject(forEntityName: "Pagina", into: context) as? Pagina
            
            
            
            self.pagina?.topo = topo!
            self.pagina?.topox = "\(topox)"
            self.pagina?.topoy = "\(topoy)"
            self.pagina?.fondo = fondo!
            self.pagina?.musica = musica!
            self.pagina?.audio = audio!
            self.pagina?.fecha = date
            
            
            
            
            // let fitEntity = NSEntityDescription.entity(forEntityName: "FitSession", in: managedContext)
            // let fitSession = FitSession(entity: fitEntity!, insertInto: managedContext)
            // fitSession.date = Date()
            
            
            let fitnessSessions = self.libro?.paginas!.mutableCopy() as! NSMutableOrderedSet
            fitnessSessions.add(self.pagina as Any)
            
            self.libro?.paginas = fitnessSessions.copy() as? NSOrderedSet
            
            
            
            
            
            do {
                try context.save()
                print("Grabo OK")
                
                
                
                //let sincronizarcaso = SincronizarCaso()
                //sincronizarcaso.Iniciar()
                
            } catch {
                print("Ha habido un error al guardar el lugar en Core Data")
            }
            
            
        }
        
    }

}
