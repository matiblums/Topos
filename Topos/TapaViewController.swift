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
    
    @IBOutlet var txtCuento: UITextField!
    @IBOutlet var txtAutor: UITextField!

    
    var libros : [Libro] = []
    var fetchResultsController : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
