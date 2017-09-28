//
//  BibliotecaViewController.swift
//  Topos
//
//  Created by Matias Blum on 1/7/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import CoreData

import AVKit

private let reuseIdentifier = "Cell"

class BibliotecaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var miGaleria: UICollectionView!
    
    var masPaginas = 1
    
    var libros : [Libro] = []
    var fetchResultsController : NSFetchedResultsController<Libro>!
    var libro : Libro?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        Ver ()
        self.miGaleria?.reloadData()
        
        let playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: "TA1", ofType: "mp3")!)
        audioPlayer = try! AVAudioPlayer(contentsOf: playYoda as URL)
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        audioPlayer.numberOfLoops = 99
        audioPlayer.play()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioPlayer.stop()
    }
    
    @IBAction func elijeBorrar(_ sender: Any) {
        
        borrar ()
        
        Ver ()
        
        self.miGaleria?.reloadData()
        
    }
    
    @IBAction func btnSalir(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Libreria", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Libreria")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
    
    }

    @IBAction func btnCrear(_ sender: Any) {
    
        let miLibro = grabarLibro ()
        
        let storyboard = UIStoryboard(name: "Seleccion", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Seleccion") as! SeleccionViewController
        controller.libro = miLibro
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
    
    }
    

     @IBAction func elijeCompartir(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Compartir", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Compartir") as! CompartirViewController
        controller.libro = self.libros[0]
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
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
        return libros.count + masPaginas
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! BibliotecaCollectionViewCell
        
        if(indexPath.row == 0){
            
            let image: UIImage = UIImage(named: "tapa")!
            cell.imgGaleria.image = image
            
        }
        
        else{
            
            let libro : Libro!
            libro = self.libros[indexPath.row - masPaginas]
            let imgSel = libro.tapa
            let image: UIImage = UIImage(named: imgSel)!
            cell.imgGaleria.image = image
            cell.lblTitulo.text = libro.titulo
            cell.lblAutor.text = libro.autor
            
        }
        if(indexPath.row < libros.count){
            
            
            
        }
       
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let myIndex = indexPath.row - masPaginas
         
        
        if(indexPath.row == 0){
            
            let miLibro = grabarLibro ()
            
            let storyboard = UIStoryboard(name: "Seleccion", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Seleccion") as! SeleccionViewController
            controller.libro = miLibro
            controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(controller, animated: true, completion: nil)
        
        }
        else{
            
            if(self.libros[myIndex].autor == "" || self.libros[myIndex].titulo == "" || self.libros[myIndex].tapa == "tapa0"){
                
                let storyboard = UIStoryboard(name: "Seleccion", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Seleccion") as! SeleccionViewController
                controller.libro = self.libros[myIndex]
                controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(controller, animated: true, completion: nil)
                
            }
            else{
                
                let storyboard = UIStoryboard(name: "Compartir", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Compartir") as! CompartirViewController
                controller.libro = self.libros[myIndex]
                controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(controller, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }
    
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
                
                //let dolencia = libros[1]
                //let fitSession =  dolencia.paginas![0] as! Pagina
                
                //print(fitSession.topo)
                
                
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

    func borrar () {
        
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
                
                
                for name in libros {
                    
                    //let libro = name
                    //print (libro.autor)
                    
                    context.delete(name)
                    
                }
                
                do {
                    try context.save()
                    print("borrado!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
                
                
                
            } catch {
                print("Error: \(error)")
            }
            
        }
        
        
        //return name
        
    }
    
    func grabarLibro() -> Libro {
        let titulo = ""
        let autor = ""
        let tapa = "tapa0"
        let fecha = Date()
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.libro = NSEntityDescription.insertNewObject(forEntityName: "Libro", into: context) as? Libro
            
            self.libro?.file = ""
            self.libro?.titulo = titulo
            self.libro?.autor = autor
            self.libro?.tapa = tapa
            self.libro?.fecha = fecha
            
            
            do {
                try context.save()
                print("Grabo OK")
                //irBiblioteca ()
                
                
                
            } catch {
                print("Ha habido un error al guardar el lugar en Core Data")
            }
            
            
        }
        
        return libro!
        
    }

    
    
}
