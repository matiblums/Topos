//
//  ViewController.swift
//  ImagesToVideo
//
//  Created by Justin Winter on 9/10/15.
//  Copyright © 2015 wintercreative. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreData
import CoreImage
import NVActivityIndicatorView

import SwiftVideoGenerator

class CompartirViewController: UIViewController , NVActivityIndicatorViewable, AVAudioPlayerDelegate{
    
    
    @IBOutlet weak var viewFondoBotones: UIView!
    
    @IBOutlet weak var viewVideo: UIView!
    
    @IBOutlet weak var viewTapa: UIView!
    @IBOutlet weak var btnPlayTotal: UIButton!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnCompartir: UIButton!
    @IBOutlet weak var btnBorrar: UIButton!
    
    
    @IBOutlet weak var imgTapa: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblAutor: UILabel!
     
    
    @IBOutlet var btnSalir: UIButton!
    
    var documentController : UIDocumentInteractionController!
    
    var avPlayer: AVPlayer!
    
    var videosArray = [NSURL]()
    
    //var videoFinal = NSURL()
    
    //var videoFinalStr = NSString()
    
    
    var paginas : [Pagina] = []
    var fetchResultsController : NSFetchedResultsController<Pagina>!
    var pagina : Pagina?
    
    var libros : [Libro] = []
    var fetchResultsControllerLibro : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    var imagesArray = [NSString]()
    var musicaArray = [NSString]()
    var audioArray = [NSString]()
    
    var controlaCantidad = Int()
    
    var isPlay = false
    
    let playerLayer = AVPlayerLayer()
    
    var nombreArchivoFinal = NSURL()

    let AnchoTotal = 1920
    let AltoTotal = 960
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        
        let miImagenCuentos = (NSLocalizedString("BTN_VOLVER", comment: ""))
        btnSalir.setImage(UIImage(named: miImagenCuentos), for: .normal)
        
        let miImagenCuentosCompartir = (NSLocalizedString("BTN_COMPARTIR", comment: ""))
        btnCompartir.setImage(UIImage(named: miImagenCuentosCompartir), for: .normal)
        
        let miImagenCuentosBorrar = (NSLocalizedString("BTN_BORRAR", comment: ""))
        btnBorrar.setImage(UIImage(named: miImagenCuentosBorrar), for: .normal)
        
        controlaCantidad = 0
        
        cargaVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
    }
    
    
    
    func cargaVideo(){

        self.viewTapa.isHidden = false
        self.viewFondoBotones.isHidden = false
        self.viewVideo.isHidden = true
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let videoDataPath = documentsDirectory + "/" + (self.libro?.file)!
        let filePathURL = URL(fileURLWithPath: videoDataPath)
        let asset = AVURLAsset(url: filePathURL)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTimeMakeWithSeconds(0.5, 1000)
        var actualTime = kCMTimeZero
        var thumbnail : CGImage?
        let image:UIImage
        
        do {
            thumbnail = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
            image = UIImage.init(cgImage: thumbnail!)
            //imageFileArray.append(image as UIImage)
            self.imgTapa.image = image
            print("creo thumbnail")
        }
        catch let error as NSError {
            print(error.localizedDescription)
            //image = nil
            image = UIImage(named: "tapa")!
            self.imgTapa.image = image
        }
        
       // DispatchQueue.global().async {
         //   self.imgTapa.image = image
       // }
        
        
        
        
        
       
    }
    
    
    
   
    //*******************************************************************************************************************
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
    
    
    
    //********************************************************************************************************************
    
    func removeFileAtURLIfExists(url: NSURL) {
        if let filePath = url.path {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                do{
                    try fileManager.removeItem(atPath: filePath)
                } catch let error as NSError {
                    print("-----Couldn't remove existing destination file: \(error)")
                }
            }
        }
    }
    
    //*********************************************************************************************************************
    
    func salvaVideo(url: NSURL){
        self.startAnimating()
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url as URL)
        }) { saved, error in
            if saved {
                
                self.stopAnimating()
                
                
                let alertController = UIAlertController(title: "Tu Video se ha Guardado en el Carrete", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            else{
                
                self.stopAnimating()
                
                let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
  
    }
    
    func comparteVideo(url: NSURL){
    
        documentController = UIDocumentInteractionController(url: url as URL)
        documentController.presentOptionsMenu(from: self.btnCompartir.frame, in: self.view, animated: true)
    }
    
    //*******************************************************************************************************************
    
    func verVideo(url: NSURL){
        //btnPlay.isHidden = true
       // btnPause.isHidden = false
        //viewTapa.isHidden = true
        
        
        avPlayer = AVPlayer(url: url as URL)
        
        playerLayer.player = avPlayer
        playerLayer.frame = self.viewVideo.bounds
        playerLayer.backgroundColor = UIColor.clear.cgColor
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
            //viewTapa.isHidden = false

        }
         
        
        self.viewVideo.layer.addSublayer(playerLayer)
        avPlayer.play()
        
        
        
        
        
        //NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),
                                              // name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidStartPlaying(note:)),name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: avPlayer.currentItem)
    
    }
    
    
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        //self.viewTapa.isHidden = false
        //viewTapa.isHidden = false
        //btnPlay.isHidden = true
        //btnPause.isHidden = true
        
        self.cargaVideo()
        
    }
    
    @objc func playerDidStartPlaying(note: NSNotification) {
        
        
    }
   
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    
    
    
    func borrar () {
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            context.delete(self.libro!)
                    
            do {
                try context.save()
                print("borrado!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                    
            }
                
        }
        
    }
    
    @IBAction func grabaVideo(_ sender: Any) {
        
        let videoGuardado = self.libro?.file
        let videoFinal = NSURL(string: videoGuardado!)!
        
        salvaVideo(url: videoFinal)
        
    }
    
    @IBAction func elijeVolver(_ sender: Any) {
        
        if(avPlayer != nil){
            avPlayer.pause()
            avPlayer = nil
        }
        
        
        
        let storyboard = UIStoryboard(name: "Biblioteca", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Biblioteca") as! BibliotecaViewController
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }
    func funcBorrar(){
        
        let videoGuardado = self.libro?.file
        let videoFinal = NSURL(string: videoGuardado!)!
        removeFileAtURLIfExists(url: videoFinal)
        
        
        let miLibro = self.libro
        
        let paginasTotales = (miLibro?.paginas?.count)!
        
        
        for i in 0...paginasTotales - 1{
            
            let miPagina = miLibro!.paginas![i] as! Pagina
            
            let videoGuardado1 = miPagina.fileVideo1
            let videoFinal1 = NSURL(string: videoGuardado1)!
            removeFileAtURLIfExists(url: videoFinal1)
            
            let videoGuardado2 = miPagina.fileVideo2
            let videoFinal2 = NSURL(string: videoGuardado2)!
            removeFileAtURLIfExists(url: videoFinal2)
            
            let pngGuardado = miPagina.filePng
            let pngFinal = NSURL(string: pngGuardado)!
            removeFileAtURLIfExists(url: pngFinal)
            
            let audioGuardado = miPagina.fileAudio
            let audioFinal = NSURL(string: audioGuardado)!
            removeFileAtURLIfExists(url: audioFinal)
            
        }
        
        borrar ()
        
        if(isPlay){
            avPlayer.pause()
            avPlayer = nil
        }
        
        let storyboard = UIStoryboard(name: "Biblioteca", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Biblioteca") as! BibliotecaViewController
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)

        
    }
    @IBAction func elijeBorrar(_ sender: Any) {
        
        alerta()
    }
    
    @IBAction func elijePlayTotal(_ sender: Any){
        

        self.viewTapa.isHidden = true
        self.viewVideo.isHidden = false
        self.viewFondoBotones.isHidden = true
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let videoDataPath = documentsDirectory + "/" + (self.libro?.file)!
        let filePathURL = URL(fileURLWithPath: videoDataPath)
        verVideo(url: filePathURL as NSURL)
        isPlay = true
        
        avPlayer.play()
    }
    
    @IBAction func elijePlay(_ sender: Any){
        
        self.viewFondoBotones.isHidden = true
        avPlayer.play()
        
    }
    
    @IBAction func elijePausa(_ sender: Any){
        
        if(isPlay){
            self.viewFondoBotones.isHidden = false
            avPlayer.pause()
        }
        
    }
    
    @IBAction func elijeStop(_ sender: Any){
        
        avPlayer.pause()
        avPlayer = nil
        
    }
    
    @IBAction func elijeComparte(_ sender: Any){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let videoDataPath = documentsDirectory + "/" + (self.libro?.file)!
        let filePathURL = URL(fileURLWithPath: videoDataPath)
        
        comparteVideo(url: filePathURL as NSURL)
        
    }
    
    func alerta (){
        //(NSLocalizedString("LBL_CARGANDO_VIDEO", comment: ""))
        let alertController = UIAlertController(title: (NSLocalizedString("COMPARTIR_TITULO_PAGINAS_PENDIENTES", comment: "")), message: (NSLocalizedString("COMPARTIR_MENSAJE_PAGINAS_PENDIENTES", comment: "")), preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        let DestructiveAction = UIAlertAction(title: (NSLocalizedString("COMPARTIR_CANCELAR_PAGINAS_PENDIENTES", comment: "")), style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            
            print("Destructive")
            
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: (NSLocalizedString("COMPARTIR_ACEPTAR_PAGINAS_PENDIENTES", comment: "")), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
            self.funcBorrar()
            
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
