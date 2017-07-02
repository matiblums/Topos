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
        
        UserDefaults.standard.set(txtTitulo.text, forKey: "titulo")
        UserDefaults.standard.set(txtAutor.text, forKey: "autor")
        
        //let tapa = UserDefaults.standard.string(forKey: "tapa")
        //let titulo = UserDefaults.standard.integer(forKey: "titulo")
        //let autor = UserDefaults.standard.integer(forKey: "autor")
        
        
        let storyboard = UIStoryboard(name: "Biblioteca", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Biblioteca")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func elijeGaleriaTapas(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "GaleriaTapas", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GaleriaTapas")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }


}
