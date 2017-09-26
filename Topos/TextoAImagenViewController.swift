//
//  TextoAImagenViewController.swift
//  Topos
//
//  Created by Matias Blum on 20/8/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

class TextoAImagenViewController: UIViewController {
    
    @IBOutlet weak var miImagenTapa: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let txtTitulo = "El Cuento del Topo"
        let txtAutor = "Matias Blum"
        let imgFondo = "fondo2.jpg"
        
        let nuevaImagen = textToImage(drawText1: txtTitulo as NSString, drawText2: txtAutor as NSString, inImage: UIImage(named:imgFondo)!)
        
        miImagenTapa.image = nuevaImagen
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func textToImage(drawText1 text1: NSString, drawText2 text2: NSString, inImage image: UIImage) -> UIImage {
     let textColor = UIColor.white
     let textColorBack = UIColor.black
     let textFont = UIFont(name: "Helvetica", size: 2000)!
     let textAlinea = NSMutableParagraphStyle()
     textAlinea.alignment = .center
     
     let scale = UIScreen.main.scale
     UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
     
     let textFontAttributes = [NSAttributedStringKey.font.rawValue: textFont, NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.backgroundColor: textColorBack, NSAttributedStringKey.paragraphStyle : textAlinea] as [AnyHashable : NSObject]
     
     image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
     
     let rect1 = CGRect(origin: CGPoint(x: 100 ,y :20), size: image.size)
     let rect2 = CGRect(origin: CGPoint(x: 0 ,y :300), size: image.size)
     
     text1.draw(in: rect1, withAttributes: textFontAttributes as? [NSAttributedStringKey : Any])
     text2.draw(in: rect2, withAttributes: textFontAttributes as? [NSAttributedStringKey : Any])
     
     
     let newImage = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     
     return newImage!
     }
 
    
    
}

