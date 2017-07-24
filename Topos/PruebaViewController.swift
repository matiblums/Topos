//
//  PruebaViewController.swift
//  Topos
//
//  Created by Matias Blum on 17/7/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

class PruebaViewController: UIViewController {
    
    @IBOutlet var imgGaleria: UIImageView!
    
    @IBOutlet var image: UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        image = self.mergedImageWith(frontImage: UIImage.init(named: "topos1.png"), backgroundImage: UIImage.init(named: "fondo2.jpg"), Topox: 0, Topoy: 0)
        //imgGaleria.image = image
        
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
            try? data.write(to: filename)
        }
        
        let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
        let newImage = UIImage(contentsOfFile: filename.path)!
        imgGaleria.image = newImage
        
             
    }
    
   
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func mergedImageWith(frontImage:UIImage?, backgroundImage: UIImage?, Topox: CGFloat, Topoy: CGFloat) -> UIImage{
        
        let topox = Topox
        let topoy = Topoy
        
        if (backgroundImage == nil) {
            return frontImage!
        }
        
        //let size = self.view.frame.size
        
        let size = CGSize(width: 667, height: 375)
        
        let size2 = CGSize(width: 190, height: 200)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        //frontImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: size.width * 0.2, dy: size.height * 0.2))
        
        frontImage?.draw(in: CGRect.init(x: topox, y: topoy, width: size2.width, height: size2.height).insetBy(dx: size2.width * 0.0, dy: size2.height * 0.0))
        
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
