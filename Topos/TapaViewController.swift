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
        let titulo = txtTitulo.text
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
                grabarTapa()
                irBiblioteca ()
                
            } catch {
                print("Ha habido un error al guardar el lugar en Core Data")
            }
            
            
        }
        
    }
    
    func irBiblioteca () {
        /*
        let storyboard = UIStoryboard(name: "Biblioteca", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Biblioteca")
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        */
        
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
    
    func grabarTapa() {
        
        let miLibro = self.libro
        let miPagina = miLibro!.paginas![0] as! Pagina
        
        let txtTitulo = self.libro?.titulo
        let txtAutor = self.libro?.autor
        let imgFondo = self.libro?.tapa
        let nuevaImagen = textToImage(drawText1: txtTitulo! as NSString, drawText2: txtAutor! as NSString, inImage: UIImage(named:imgFondo!)!)
        
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
        let musica = "TA1_Intro"
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
        let textColor = UIColor.white
        let textColorBack = UIColor.black
        let textFont = UIFont(name: "Helvetica", size: 200)!
        let textAlinea = NSMutableParagraphStyle()
        textAlinea.alignment = .center
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColor, NSBackgroundColorAttributeName: textColorBack, NSParagraphStyleAttributeName : textAlinea] as [String : Any]
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect1 = CGRect(origin: CGPoint(x: 0 ,y :20), size: image.size)
        let rect2 = CGRect(origin: CGPoint(x: 0 ,y :300), size: image.size)
        
        text1.draw(in: rect1, withAttributes: textFontAttributes)
        text2.draw(in: rect2, withAttributes: textFontAttributes)
        
        
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

}
