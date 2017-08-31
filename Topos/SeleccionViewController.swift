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
    @IBOutlet var btnEliminar: UIButton!
    
    @IBOutlet var btnCerrar: UIButton!
    @IBOutlet var btnSalir: UIButton!
    
    @IBOutlet var lblCerrar: UILabel!
    @IBOutlet var lblSalir: UILabel!
    
    @IBOutlet var btnIzq: UIButton!
    @IBOutlet var btnDer: UIButton!
    
    @IBOutlet var lblPagina: UILabel!
    
    var paginas : [Pagina] = []
    var fetchResultsControllerPagina : NSFetchedResultsController<Pagina>!
    var pagina : Pagina?
    
    var libros : [Libro] = []
    var fetchResultsController : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    var masPaginas = 3
    
    var contPagina = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView?.dataSource = self
        
        //flowLayout?.maxCoverDegree = 0
        //flowLayout?.coverDensity = 0.25
        //flowLayout?.minCoverScale = 0.20
        //flowLayout?.minCoverOpacity = 0.7
        
         //btnCierraPagina.isHidden = false
        
        borraDatos()
        btnPlay.isHidden = true
        btnEliminar.isHidden = true
        
        let miLibro = self.libro
        
        let paginasTotales = (miLibro?.paginas?.count)! + masPaginas
        
        contPagina = paginasTotales - 2
        
        myView?.scrollToItem(at: IndexPath(item: paginasTotales - 2, section: 0), at: .centeredHorizontally, animated: true)
        
        lblPagina.text = ""
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cargaBotones()
        tocaGaleria ()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func elijeBiblioteca(_ sender: Any) {
        
        alerta2 ()
        
    }
    
    func Biblioteca () {
        
        let storyboard = UIStoryboard(name: "Biblioteca", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Biblioteca")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func elijeTapa(_ sender: Any) {
        
        if((UserDefaults.standard.string(forKey: "fondo")) != nil || (UserDefaults.standard.string(forKey: "topo")) != nil || (UserDefaults.standard.string(forKey: "musica")) != nil || (UserDefaults.standard.string(forKey: "fondo")) != nil || (UserDefaults.standard.string(forKey: "audio")) != nil){
            
            alerta ()
        
        }
        else{
            
            Tapa ()
            
        }
        
        
        
    }
    
    
    func Tapa () {
        
        let storyboard = UIStoryboard(name: "Tapa", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Tapa") as! TapaViewController
        controller.libro = self.libro
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
        UserDefaults.standard.removeObject(forKey: "tapa")
        
    }
    
    @IBAction func playPagina(_ sender: Any) {
        
        let miLibro = self.libro
        let miPagina = miLibro!.paginas![contPagina - 1] as! Pagina
        
        let storyboard = UIStoryboard(name: "Pelicula", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Pelicula") as! PeliculaViewController
        controller.pagina = miPagina
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func agregarPagina(_ sender: Any) {
        
        agregar ()
        
    }
    
    @IBAction func borrarPagina(_ sender: Any) {
        
        Borrar ()
        
    }
    
    @IBAction func btnIzq(_ sender: Any) {
        
        if(contPagina > 1){
            
            contPagina -= 1
            tocaGaleria ()
            
        }
        
        
    }
    
    @IBAction func btnDer(_ sender: Any) {
        
        let miLibro = self.libro
        let paginasTotales = (miLibro?.paginas?.count)! + masPaginas
        
        if(contPagina < paginasTotales - 2){
            
            contPagina += 1
            tocaGaleria ()
            
        }
        
        
        
    }
    
    func Borrar () {
        
        let miLibro = self.libro
        let miPagina =  miLibro?.paginas![contPagina - 1] as! Pagina
        
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            context.delete(miPagina)
            
            do {
                try context.save()
                print("borrado!")
                tocaGaleria ()
                self.myView?.reloadData()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        }
        
        
    }

    
    func cerrar () {
        
        grabar()
        
    }
    
    func agregar () {
        
        borraDatos()
        self.myView?.reloadData()
        let miLibro = self.libro
        let paginasTotales = (miLibro?.paginas?.count)! + masPaginas
        
        contPagina = paginasTotales - 2
        
        myView?.scrollToItem(at: IndexPath(item: paginasTotales - 2, section: 0), at: .centeredHorizontally, animated: true)
        cargaBotones ()
        
    }
    
    func tocaGaleria () {
        lblPagina.text = "Página \(contPagina)"
        
        myView?.scrollToItem(at: IndexPath(item: contPagina, section: 0), at: .centeredHorizontally, animated: true)
        let miLibro = self.libro
        let paginasTotales = (miLibro?.paginas?.count)! + masPaginas
        
        if(contPagina == paginasTotales - 2){
            
            cargaBotones ()
            myView?.scrollToItem(at: IndexPath(item: contPagina, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
        if(contPagina > 0 && contPagina < paginasTotales - 2){
            
            
            muestraDatos()
            myView?.scrollToItem(at: IndexPath(item: contPagina, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
        if(contPagina == 1){
            
            btnIzq.isHidden = true
            
        }
        
        else{
            
            btnIzq.isHidden = false
            
        }
        
        
        
        if(contPagina == paginasTotales - 2){
            
            btnDer.isHidden = true
            
        }
        
        else{
            
            btnDer.isHidden = false
            
        }
        
        
        if(contPagina == paginasTotales - 3){
            
            btnDer.setBackgroundImage(UIImage(named: "edicion05_agregar_pg.png"), for: UIControlState.normal)
            
        }
        
        else{
            
            btnDer.setBackgroundImage(UIImage(named: "edicion05_flecha_der.png"), for: UIControlState.normal)
            
        }
        
        
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
                
                let image: UIImage = UIImage(named: "fondo0.png")!
                cell.imgGaleria.image = image
                
            }
            
            if((UserDefaults.standard.string(forKey: "topo")) != nil){
                
                let imgTopo = UserDefaults.standard.string(forKey: "topo")
                let topoxGuardada = UserDefaults.standard.integer(forKey: "topox") / 2
                let topoyGuardada = UserDefaults.standard.integer(forKey: "topoy") / 2
                let pointTopo = CGPoint(x: topoxGuardada, y: topoyGuardada)
                let imageTopo: UIImage = UIImage(named: imgTopo!)!
                cell.imgTopo.image = imageTopo
                cell.imgTopo.frame.origin = pointTopo
                
            }
            else{
                
                //let image: UIImage = UIImage(named: "fondo0")!
                cell.imgTopo.image = nil
                
            }
            
        }
        
        if(indexPath.row == 0 || indexPath.row == paginasTotales - 1){
            
            //let image: UIImage = UIImage(named: "fondo0")!
            cell.imgGaleria.image = nil
            cell.imgTopo.image = nil
            
            
        }
        
        if(indexPath.row > 0 && indexPath.row < paginasTotales - 2){
            
            let miPagina =  miLibro?.paginas![indexPath.row - 1] as! Pagina
            let imgSel = miPagina.fondo
            let image: UIImage = UIImage(named: imgSel)!
            cell.imgGaleria.image = image
            
            
            let imgTopo = miPagina.topo
            let topoxGuardada = Int(miPagina.topox)! / 2
            let topoyGuardada = Int(miPagina.topoy)! / 2
            
            
            let pointTopo = CGPoint(x: topoxGuardada, y: topoyGuardada)
            let imageTopo: UIImage = UIImage(named: imgTopo)!
            cell.imgTopo.image = imageTopo
            cell.imgTopo.frame.origin = pointTopo
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)
        //cell?.layer.borderWidth = 2.0
        //cell?.layer.borderColor = UIColor.clear.cgColor
    }
    
    func muestraDatos(){
       // btnCierraPagina.isHidden = true
        btnPlay.isHidden = false
        btnEliminar.isHidden = false
        
       // checkFondo.isHidden = false
       // checkTopo.isHidden = false
       // checkMusica.isHidden = false
       // checkAudio.isHidden = false
        
        btnFondoVacio.alpha = 1
        btnTopoVacio.alpha = 1
        btnMusicaVacio.alpha = 1
        btnAudioVacio.alpha = 1
        
        btnFondoVacio.isEnabled = false
        btnTopoVacio.isEnabled = false
        btnMusicaVacio.isEnabled = false
        btnAudioVacio.isEnabled = false
        
        // btnFondo.isHidden = false
        // btnTopo.isHidden = false
        // btnMusica.isHidden = false
        //  btnAudio.isHidden = false
        
    }
    
    func borraDatos(){
        
       // checkFondo.isHidden = true
       // checkTopo.isHidden = true
       // checkMusica.isHidden = true
       // checkAudio.isHidden = true
        
        btnFondoVacio.alpha = 1
        btnTopoVacio.alpha = 1
        btnMusicaVacio.alpha = 1
        btnAudioVacio.alpha = 1
        
        btnPlay.isHidden = true
        btnEliminar.isHidden = true
        
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
        self.myView?.reloadData()
        
        let miLibro = self.libro
        
        if((miLibro!.paginas?.count)! > 0){
            
            btnCerrar.isHidden = false
            lblCerrar.isHidden = false
            
        }
        else{
            
            btnCerrar.isHidden = true
            lblCerrar.isHidden = true
          
        }
        
        
        btnPlay.isHidden = true
        btnEliminar.isHidden = true
        btnFondoVacio.isEnabled = true
        btnTopoVacio.isEnabled = true
        btnMusicaVacio.isEnabled = true
        btnAudioVacio.isEnabled = true
        
        if((UserDefaults.standard.string(forKey: "fondo")) != nil){
            
            if((UserDefaults.standard.string(forKey: "topo")) != nil){
                
                if((UserDefaults.standard.string(forKey: "musica")) != nil){
                    
                    if((UserDefaults.standard.string(forKey: "audio")) != nil){
                        btnCerrar.isHidden = false
                        lblCerrar.isHidden = false
                        cerrar ()
                        borraDatos()
                        
                    }
                }
                
            }
        }
        else{
            
            //btnCierraPagina.isHidden = true
            
        }
        
        
        if((UserDefaults.standard.string(forKey: "fondo")) != nil){
            
            //checkFondo.isHidden = false
            
            btnFondoVacio.alpha = 0.1
            
        }
        else{
            
            //checkFondo.isHidden = true
        }
        
        if((UserDefaults.standard.string(forKey: "topo")) != nil){
            
           // checkTopo.isHidden = false
            
            btnTopoVacio.alpha = 0.1
            
        }
        else{
            
           // checkTopo.isHidden = true
            
        }
        
        
        if((UserDefaults.standard.string(forKey: "musica")) != nil){
            
           // checkMusica.isHidden = false
            
            btnMusicaVacio.alpha = 0.1
            
        }
        else{
            
           // checkMusica.isHidden = true
        }
        
        if((UserDefaults.standard.string(forKey: "audio")) != nil){
            
           // checkAudio.isHidden = false
            
            btnAudioVacio.alpha = 0.1
            
        }
        else{
            
          //  checkAudio.isHidden = true
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
            
            self.pagina?.fileAudio = ""
            self.pagina?.filePng = ""
            self.pagina?.fileVideo1 = ""
            self.pagina?.fileVideo2 = ""
            
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
    
    
    
    func alerta (){
        let alertController = UIAlertController(title: "Tienes Paginas Pendientes", message: "Deseas cerrar el libro, de todos modos?", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
         let DestructiveAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive) {
           (result : UIAlertAction) -> Void in
            
            print("Destructive")
            
         }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
            self.Tapa ()
            
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    func alerta2 (){
        let alertController = UIAlertController(title: "Si sales de la edicion se borra el libro", message: "Deses continuar de todos modos?", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        let DestructiveAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            
            print("Destructive")
            
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
            self.borrarLibro()
            self.Biblioteca()
            
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func borrarLibro () {
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            context.delete(self.libro!)
            
            do {
                try context.save()
                print("borrado!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        }
        
    }
}
