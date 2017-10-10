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
    
    var paginas : [Pagina] = []
    var fetchResultsControllerPagina : NSFetchedResultsController<Pagina>!
    var pagina : Pagina?
    
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
            alerta ()
            return
        }
        
        if(autor == ""){
            alerta ()
            return
        }
        
        if(tapa == nil){
            alerta ()
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
    
    @IBAction func elijeVolver(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func grabar() {
        let file = ""
        let titulo = txtTitulo.text?.uppercased()
        
        let autor = txtAutor.text
        let tapa = UserDefaults.standard.string(forKey: "tapa")
        let fecha = Date()

        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            //self.libro = NSEntityDescription.insertNewObject(forEntityName: "Libro", into: context) as? Libro
            
            self.libro?.file = file
            self.libro?.titulo = titulo!
            self.libro?.autor = autor!
            self.libro?.tapa = tapa!
            self.libro?.fecha = fecha
            
            
            do {
                try context.save()
                print("Grabo OK")
                
                let txtTitulo = self.libro?.titulo
                let txtAutor = self.libro?.autor
                let imgFondo = self.libro?.tapa
                
                let txtTitulo2 = ""
                let txtAutor2 = ""
                let imgFondo2 = "placa.jpg"
                
                grabarTapa(txtTitulo: txtTitulo! as NSString, txtAutor: txtAutor! as NSString, imgFondo: imgFondo! as NSString)
                
                grabarTapa(txtTitulo: txtTitulo2 as NSString, txtAutor: txtAutor2 as NSString, imgFondo: imgFondo2 as NSString)
                
                irBiblioteca ()
                
            } catch {
                print("Ha habido un error al guardar el lugar en Core Data")
            }
            
            
        }
        
    }
    

    
    func grabarTapa(txtTitulo: NSString, txtAutor: NSString, imgFondo: NSString) {
        
        let miLibro = self.libro
        let miPagina = miLibro!.paginas![0] as! Pagina
        
        let txtTitulo = txtTitulo
        let txtAutor = txtAutor
        let imgFondo = imgFondo
        let nuevaImagen = textToImage(drawText1: txtTitulo as NSString, drawText2: txtAutor as NSString, inImage: UIImage(named:imgFondo as String)!)
        
        let random = randomString(length: 8)
        let nombreArchivo = random
        
        if let data = UIImagePNGRepresentation(nuevaImagen) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(nombreArchivo)-.png")
            try? data.write(to: filename)
        }
        
        let filename = getDocumentsDirectory().appendingPathComponent("\(nombreArchivo)-.png")
        
        let topo = "topos0.png"
        let topox = "0"
        let topoy = "0"
        
        let urlString: String = filename.relativePath
        let fondo = urlString
        let musica = "TA0"
        let audio = miPagina.audio
        
        let isoDate = "2016-04-14T10:44:00+0000"
        
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:isoDate)!
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.pagina = NSEntityDescription.insertNewObject(forEntityName: "Pagina", into: context) as? Pagina
            
                
            self.pagina?.fileAudio = ""
            self.pagina?.filePng = ""
            self.pagina?.fileVideo1 = ""
            self.pagina?.fileVideo2 = ""
            
            self.pagina?.topo = topo
            self.pagina?.topox = "\(topox)"
            self.pagina?.topoy = "\(topoy)"
            self.pagina?.fondo = fondo
            self.pagina?.musica = musica
            self.pagina?.audio = audio
            self.pagina?.fecha = date
            
            
            
            
            // let fitEntity = NSEntityDescription.entity(forEntityName: "FitSession", in: managedContext)
            // let fitSession = FitSession(entity: fitEntity!, insertInto: managedContext)
            // fitSession.date = Date()
            
            
            let fitnessSessions = self.libro?.paginas!.mutableCopy() as! NSMutableOrderedSet
            fitnessSessions.add(self.pagina as Any)
            
            self.libro?.paginas = fitnessSessions.copy() as? NSOrderedSet
            
            
            
            
            
            do {
                try context.save()
                print("Grabo OK")
                
                
                
                //let sincronizarcaso = SincronizarCaso()
                //sincronizarcaso.Iniciar()
                
            } catch {
                print("Ha habido un error al guardar el lugar en Core Data")
            }
            
            
        }
        
    }
    
   
    
    func textToImage(drawText1 text1: NSString, drawText2 text2: NSString, inImage image: UIImage) -> UIImage {
        
        let textColor = UIColor.black
        let textColorBack = UIColor.clear
        let textFont = UIFont(name: "ArialRoundedMTBold", size: 100)!
        let textAlinea = NSMutableParagraphStyle()
        textAlinea.alignment = .center
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [NSAttributedStringKey.font: textFont, NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.backgroundColor: textColorBack, NSAttributedStringKey.paragraphStyle : textAlinea] as [AnyHashable : NSObject]
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        
        let rect1 = CGRect(origin: CGPoint(x: 0 ,y :70), size: CGSize(width: image.size.width, height: 300))
        let rect2 = CGRect(origin: CGPoint(x: 0 ,y :400), size: CGSize(width: image.size.width, height: 300))
        
        
        text1.draw(in: rect1, withAttributes: textFontAttributes as? [NSAttributedStringKey : Any])
        text2.draw(in: rect2, withAttributes: textFontAttributes as? [NSAttributedStringKey : Any])
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func irBiblioteca () {
        let storyboard = UIStoryboard(name: "Compartir", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Compartir") as! CompartirViewController
        controller.libro = self.libro
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    func alerta (){
        let alertController = UIAlertController(title: "Debe Completar todos los campos", message: "Ok para continuar", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        //let DestructiveAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive) {
        //    (result : UIAlertAction) -> Void in
        
        //    print("Destructive")
        
        // }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
            //self.Tapa ()
            
        }
        
        //alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
