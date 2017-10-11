//
//  BibliotecaViewController.swift
//  Topos
//
//  Created by Matias Blum on 1/7/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import CoreData
import CoreImage
import AVKit

private let reuseIdentifier = "Cell"

class BibliotecaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var miGaleria: UICollectionView!
    
    var masPaginas = 1
    
    var libros : [Libro] = []
    var fetchResultsController : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    var urlFileArray = [NSString]()
    var imageTapaArray = [NSString]()
    var imageFileArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        Ver ()
        
        
        let playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: "TA1", ofType: "mp3")!)
        audioPlayer = try! AVAudioPlayer(contentsOf: playYoda as URL)
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        audioPlayer.numberOfLoops = 99
        //audioPlayer.play()
        
        var libro : Libro!
        
        
        for i in 0 ..< self.libros.count {
            
            libro = self.libros[i]
            let urlFile = libro.file
            let imageTapa = libro.tapa
            urlFileArray.append(urlFile as NSString)
            imageTapaArray.append(imageTapa as NSString)
            let image:UIImage
            
            
            if(urlFile == ""){
                
                image = UIImage(named: imageTapa)!
                
            }
            else{
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = paths[0]
                let videoDataPath = documentsDirectory + "/" + (urlFile as String)
                let filePathURL = URL(fileURLWithPath: videoDataPath)
                let asset = AVURLAsset(url: filePathURL)
                
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                let time = CMTimeMakeWithSeconds(0.5, 1000)
                var actualTime = kCMTimeZero
                var thumbnail : CGImage?
                
                do {
                    thumbnail = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
                    image = UIImage.init(cgImage: thumbnail!)
                    //imageFileArray.append(image as UIImage)
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                    //image = nil
                    image = UIImage(named: "tapa")!
                    
                }
                
            }
            
            imageFileArray.append(image)
        }
        
        
        self.miGaleria?.reloadData()
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let miAncho = self.view.frame.size.width / 3 - 10
        let miAlto = miAncho / 2;
        
        
        
        return CGSize(width: miAncho, height: miAlto);
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.libros.count + masPaginas
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! BibliotecaCollectionViewCell
        
        if(indexPath.row == 0){
            
            let image: UIImage = UIImage(named: "tapa")!
            cell.imgGaleria.image = image
            
        }
        
        else{
            
            cell.imgGaleria.image = imageFileArray[indexPath.row - masPaginas]

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
