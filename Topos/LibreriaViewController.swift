//
//  LibreriaViewController.swift
//  Topos
//
//  Created by Matias Blum on 21/7/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

class LibreriaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func elijeBiblioteca(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Biblioteca", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Biblioteca") as! BibliotecaViewController
         
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }

}
