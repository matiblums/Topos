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
        
        image = self.mergedImageWith(frontImage: UIImage.init(named: "topos1.png"), backgroundImage: UIImage.init(named: "fondo2.jpg"))
        //imgGaleria.image = image
        
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
            try? data.write(to: filename)
        }
        
        let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
        let newImage = UIImage(contentsOfFile: filename.path)!
        imgGaleria.image = newImage
        
        //let urls = [filename.path]
        
       
        
        /*
        //[filter1 setValue:[imageForeground imageByApplyingTransform:CGAffineTransformMakeTranslation(100, 100)] forKey:kCIInputImageKey]


        let otherImage = CIImage(image: UIImage(named:"WhatsApp Image 2017-05-19 at 17.02.49.jpeg")!)
        let volleyballImage = CIImage(image: UIImage(named:"topos2.png")!)
        let compositeFilter = CIFilter(name: "CIAdditionCompositing")!
        
        
        
        compositeFilter.setValue(volleyballImage, forKey: kCIInputImageKey)
        compositeFilter.setValue(otherImage, forKey: kCIInputBackgroundImageKey)
        
        if let compositeImage = compositeFilter.outputImage{
            //let image2: UIImage = UIImage(ciImage: compositeImage)
            //imgGaleria.image = image
            //imgGaleria.image = image2
            if let data = UIImagePNGRepresentation(convert(cmage: compositeImage)) {
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)
                let newImage = UIImage(contentsOfFile: filename.path)!
                imgGaleria.image = newImage
            }
            
        }
        
        //let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
        //let newImage = UIImage(contentsOfFile: filename.path)!
        //imgGaleria.image = newImage
        */
        
    }
    
   
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func mergedImageWith(frontImage:UIImage?, backgroundImage: UIImage?) -> UIImage{
        
        if (backgroundImage == nil) {
            return frontImage!
        }
        
        //let size = self.view.frame.size
        
        let size = CGSize(width: 3000, height: 1506)
        
        let size2 = CGSize(width: 926, height: 1049)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        //frontImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: size.width * 0.2, dy: size.height * 0.2))
        
        frontImage?.draw(in: CGRect.init(x: 0, y: 0, width: size2.width, height: size2.height).insetBy(dx: size2.width * 0.0, dy: size2.height * 0.0))
        
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
