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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let volleyballImage = CIImage(image: UIImage(named:"fondo1.jpg")!)
        let otherImage = CIImage(image: UIImage(named:"topos1.png")!)
        let compositeFilter = CIFilter(name: "CIAdditionCompositing")!
        
        compositeFilter.setValue(volleyballImage,
                                 forKey: kCIInputImageKey)
        
        
        compositeFilter.setValue(otherImage,
                                 forKey: kCIInputBackgroundImageKey)
        
        if let compositeImage = compositeFilter.outputImage{
            //let image2: UIImage = UIImage(ciImage: compositeImage)
            //imgGaleria.image = image
            //imgGaleria.image = image2
            if let data = UIImagePNGRepresentation(convert(cmage: compositeImage)) {
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)
            }
            
        }
        
        let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
        let newImage = UIImage(contentsOfFile: filename.path)!
        imgGaleria.image = newImage
        
        
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
}
