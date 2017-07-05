//
//  TapaViewController.swift
//  Topos
//
//  Created by Matias Blum on 30/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreData


class TapaViewController: UIViewController {
    
    @IBOutlet var txtTitulo: UITextField!
    @IBOutlet var txtAutor: UITextField!
    
    @IBOutlet var miFondo: UIImageView!

    
    var libros : [Libro] = []
    var fetchResultsController : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let tapa = UserDefaults.standard.string(forKey: "tapa")
        
        if((tapa) != nil){
            
            let image: UIImage = UIImage(named: tapa!)!
            miFondo.image = image
            
        }
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func elijeBiblioteca(_ sender: Any) {
        let titulo = txtTitulo.text
        let autor = txtAutor.text
        let tapa = UserDefaults.standard.string(forKey: "tapa")
        
        
        if(titulo == ""){
            return
        }
        
        if(autor == ""){
            return
        }
        
        if(tapa == nil){
            return
        }
        
        grabar()
    }
    
    @IBAction func elijeGaleriaTapas(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "GaleriaTapas", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GaleriaTapas")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func grabar() {
        let titulo = txtTitulo.text
        let autor = txtAutor.text
        let tapa = UserDefaults.standard.string(forKey: "tapa")
        let fecha = Date()

        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            //self.libro = NSEntityDescription.insertNewObject(forEntityName: "Libro", into: context) as? Libro
            
            self.libro?.titulo = titulo!
            self.libro?.autor = autor!
            self.libro?.tapa = tapa!
            self.libro?.fecha = fecha
            
            
            do {
                try context.save()
                print("Grabo OK")
                irBiblioteca ()
                
            } catch {
                print("Ha habido un error al guardar el lugar en Core Data")
            }
            
            
        }
        
    }
    
    func irBiblioteca () {
        
        let storyboard = UIStoryboard(name: "Biblioteca", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Biblioteca")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }

}
