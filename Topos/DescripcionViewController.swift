//
//  DescripcionViewController.swift
//  Topos
//
//  Created by Matias Blum on 27/9/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

class DescripcionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func elijeVolver(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Libreria", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Libreria") as! LibreriaViewController
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }

}
