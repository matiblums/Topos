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
        
        let txtTitulo = "El Cuento del Topo -GGGGTY---------------"
        let txtAutor = "Matias Blum"
        let imgFondo = "tapa1"
        
        let nuevaImagen = textToImage(drawText1: txtTitulo as NSString, drawText2: txtAutor as NSString, inImage: UIImage(named:imgFondo)!)
        
        miImagenTapa.image = nuevaImagen
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func textToImage(drawText1 text1: NSString, drawText2 text2: NSString, inImage image: UIImage) -> UIImage {
        
        let textColor = UIColor.black
        let textColorBack = UIColor.clear
        let textFont = UIFont(name: "ArialRoundedMTBold", size: 50)!
        let textAlinea = NSMutableParagraphStyle()
        textAlinea.alignment = .center
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [NSAttributedStringKey.font: textFont, NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.backgroundColor: textColorBack, NSAttributedStringKey.paragraphStyle : textAlinea] as [AnyHashable : NSObject]
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        
        let rect1 = CGRect(origin: CGPoint(x: 0 ,y :70), size: CGSize(width: image.size.width, height: 300))
        let rect2 = CGRect(origin: CGPoint(x: 0 ,y :500), size: CGSize(width: image.size.width, height: 300))
        
        
        text1.draw(in: rect1, withAttributes: textFontAttributes as? [NSAttributedStringKey : Any])
        text2.draw(in: rect2, withAttributes: textFontAttributes as? [NSAttributedStringKey : Any])
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
     }
 
    
    
}

