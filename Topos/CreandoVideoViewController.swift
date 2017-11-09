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

class CreandoVideoViewController: UIViewController , NVActivityIndicatorViewable, AVAudioPlayerDelegate{
    
    
    @IBOutlet weak var lblCargando: UILabel!
    
    var documentController : UIDocumentInteractionController!
    
  
    
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
        
        self.lblCargando.text = (NSLocalizedString("LBL_CARGANDO_VIDEO", comment: ""))
        
        controlaCantidad = 0
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        creaVideo()
    }
    
    
    
    
    func cargaVideo(){
        
        let storyboard = UIStoryboard(name: "Compartir", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Compartir") as! CompartirViewController
        controller.libro = self.libro
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)

        
    }
    
    func creaVideo(){
        let miLibro = self.libro
        let totales = miLibro?.paginas?.count
        let num = Int(totales!)
        
        
        for i in 0..<num{
            
            let miPagina = miLibro!.paginas![i] as! Pagina
            //******************************************************************************************************
            let miFondo = miPagina.fondo
            let miTopo = miPagina.topo
            let miTopoX = miPagina.topox
            let miTopoY = miPagina.topoy
            
            let cgFloatTopoX : CGFloat? = Double(miTopoX).map{ CGFloat($0) }
            let cgFloatTopoY : CGFloat? = Double(miTopoY).map{ CGFloat($0) }
            
            let random = randomString(length: 8)
            let nombreArchivo = random
            //******************************************************************************************************
            
            var miImagen : UIImage
            miImagen = UIImage.init(named: miFondo)!
            
            let imageOK = self.mergedImageWith(frontImage: UIImage.init(named: miTopo), backgroundImage: miImagen, Topox: cgFloatTopoX!, Topoy: cgFloatTopoY!)
            
            if let data = UIImagePNGRepresentation(imageOK) {
                let filename = getDocumentsDirectory().appendingPathComponent("\(nombreArchivo)-.png")
                try? data.write(to: filename)
            }
            
            let filename = getDocumentsDirectory().appendingPathComponent("\(nombreArchivo)-.png")
            
            //******************************************************************************************************
            
            imagesArray.append(filename.path as NSString)
            musicaArray.append(miPagina.musica as NSString)
            audioArray.append(miPagina.audio as NSString)
        }
        
        
        creaLoop(i : 0)
        
        
    }
    
    func creaLoop(i : Int) {
        
        createVideo(image: imagesArray[i] as NSString, musicaUrl: musicaArray[i] as NSString, audioUrl: audioArray[i] as NSString, num: i, numTotal: imagesArray.count)
        
        
    }
    
    //***************************** crea Video en Time Lapse *******************************************
    
    
    func createVideo(image: NSString, musicaUrl:NSString, audioUrl:NSString, num: Int, numTotal: Int){
        
        //print(image, " -- ", num)
        //let path1 = Bundle.main.path(forResource: image as String, ofType: "")!
        
        let path1 = image
        
        let sonidoGuardado = audioUrl
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(sonidoGuardado as String)
        
        
        let playAudio1 = soundURL
        
        var photosArray = [String]()
        
        let asset = AVURLAsset(url: playAudio1!)
        var duration : Int
        
        if(num == numTotal-1 || num == numTotal-2 || num == numTotal-3){
            
            duration = 1
            
        }
            
        else{
            
            duration = Int(CMTimeGetSeconds(asset.duration)) + 1
            
        }
        
        
        for _ in 0...duration {
            //photosArray.append(path1)
            photosArray.append(path1 as String)
        }
        
        let tlb = TimeLapseBuilder(photoURLs: photosArray)
        
        
        //let miWidthFondo = self.view.frame.size.width
        //let miHeightFondo = self.view.frame.size.height
        
        let miWidthFondo = AnchoTotal
        let miHeightFondo = AltoTotal
        
        tlb.build(file: image, outputSize: CGSize(width: miWidthFondo, height: miHeightFondo), progress: {
            
            (progress) -> Void in
            
            DispatchQueue.main.async{
                //self.progressLabel.text = "rendering \(progress.completedUnitCount) of \(progress.totalUnitCount) frames"
                //self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            }
            
        }, success: { (url) -> Void in
            //print("SUCCESS: \(url)")
            DispatchQueue.main.async{
                //self.progressLabel.isHidden = true
                //self.progressView.isHidden = true
                
                self.controlaCantidad = self.controlaCantidad + 1
                
                if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                    let context = container.viewContext
                    
                    let miLibro = self.libro
                    let miPagina = miLibro!.paginas![num] as! Pagina
                    
                    //let url1 = image.absoluteString! as NSString
                    
                    let url1 = "file://\(image)"
                    
                    miPagina.filePng = url1 as String
                    
                    
                    do {
                        try context.save()
                        // print("Grabo OK")
                        
                        
                    } catch {
                        // print("Ha habido un error al guardar el lugar en Core Data")
                    }
                    
                }
                
                
                self.mergeMutableVideoWithAudio(videoUrl: url as NSURL, musicaUrl: musicaUrl, audioUrl: audioUrl, num: num, numTotal: numTotal )
                
                
                if(self.controlaCantidad < numTotal){
                    
                    self.creaLoop(i : self.controlaCantidad)
                    
                }
                else{
                    
                    
                    
                }
                
                
            }
            
        }) { (error) -> Void in
            print(error)
            self.stopAnimating()
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    //***************************************************************************************************************************
    
    func mergeMutableVideoWithAudio(videoUrl:NSURL, musicaUrl:NSString, audioUrl:NSString, num: Int, numTotal: Int){
        
        //print("\(videoUrl)------\(num)")
        
        var mergedAudioVideoURl = NSURL()
        
        let playAudio1 = NSURL(fileURLWithPath: Bundle.main.path(forResource: musicaUrl as String, ofType: "mp3")!)
        
        let sonidoGuardado = audioUrl
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(sonidoGuardado as String)
        
        
        //let playAudio2 = NSURL(fileURLWithPath: Bundle.main.path(forResource: audioUrl as String, ofType: "m4a")!)
        
        
        let mixComposition : AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack : [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack : [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack2 : [AVMutableCompositionTrack] = []
        
        
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        //start merge
        let aVideoAsset : AVAsset = AVAsset(url: videoUrl as URL)
        let aAudioAsset : AVAsset = AVAsset(url: playAudio1 as URL)
        let aAudioAsset2 : AVAsset = AVAsset(url: soundURL!)
        
        mutableCompositionVideoTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        
        mutableCompositionAudioTrack.append( mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        
        mutableCompositionAudioTrack2.append( mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        
        let aVideoAssetTrack : AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        
        let aAudioAssetTrack : AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]
        
        let aAudioAssetTrack2 : AVAssetTrack = aAudioAsset2.tracks(withMediaType: AVMediaType.audio)[0]
        
        
        if(num == numTotal-1 || num == numTotal-2 || num == numTotal-3){
            
            do{
                try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: kCMTimeZero)
                
                try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: kCMTimeZero)
                
            }catch{
                
            }
            
        }
        else{
            
            do{
                try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: kCMTimeZero)
                
                try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: kCMTimeZero)
                
                try mutableCompositionAudioTrack2[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack2, at: kCMTimeZero)
                
            }catch{
                
            }
            
        }
        
        
        //let miWidthFondo = self.view.frame.size.width
        //let miHeightFondo = self.view.frame.size.height
        
        let miWidthFondo = AnchoTotal
        let miHeightFondo = AltoTotal
        
        totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,aVideoAssetTrack.timeRange.duration )
        let mutableVideoComposition : AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(1, 30)
        mutableVideoComposition.renderSize = CGSize(width: miWidthFondo, height: miHeightFondo)
        
        let random = randomString(length: 8)
        
        let nombreArchivo = random
        
        
        mergedAudioVideoURl = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/FinalVideo---\(num)-\(nombreArchivo).mp4")
        
        
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = mergedAudioVideoURl as URL
        //removeFileAtURLIfExists(url: mergedAudioVideoURl)
        //assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {
            case AVAssetExportSessionStatus.completed:
                //print("-----Merge mutable video with trimmed audio exportation complete.\(mergedAudioVideoURl)")
                //self.videoFirst = mergedAudioVideoURl as NSURL
                //print("de \(num) aa \(numTotal)")
                self.almacenaVideos(miVideo:  mergedAudioVideoURl, position: num, total: numTotal)
                //print("---\(mergedAudioVideoURl)")
                
                //**********************************************************************************************************
                
                if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                    let context = container.viewContext
                    
                    let miLibro = self.libro
                    let miPagina = miLibro!.paginas![num] as! Pagina
                    
                    let url1 = videoUrl.absoluteString! as NSString
                    let url2 = mergedAudioVideoURl.absoluteString! as NSString
                    let url3 = soundURL!.absoluteString as NSString
                    
                    miPagina.fileVideo1 = url1 as String
                    miPagina.fileVideo2 = url2 as String
                    miPagina.fileAudio = url3 as String
                    
                    
                    do {
                        try context.save()
                        // print("Grabo OK")
                        
                        
                    } catch {
                        // print("Ha habido un error al guardar el lugar en Core Data")
                    }
                    
                }
                
                //**********************************************************************************************************
                
                
            case  AVAssetExportSessionStatus.failed:
                print("failed \(String(describing: assetExport.error))")
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(String(describing: assetExport.error))")
            default:
                print("complete")
                
                
                
            }
        }
    }
    
    //*******************************************************************************************************
    
    
    func almacenaVideos(miVideo: NSURL, position: Int, total: Int){
        
        videosArray.append(miVideo)
        
        
        if(position == total - 1){
            
            let element = videosArray.remove(at: total - 3)
            videosArray.insert(element, at: 0)
            
            // mergeVideoFiles(videoFileUrls: videosArray as NSArray)
            generaVIdeosNuevaLibreria(miArray: videosArray as NSArray)
        }
        
        
    }
    //***************************** juntas los videos finales nueva libreria *******************************************
    func generaVIdeosNuevaLibreria (miArray: NSArray){
        let random = randomString(length: 8)
        let nombreArchivo = random
        
        //mergeVideoURL = documentDirectoryURL.appendingPathComponent(nombreArchivo)! as URL as NSURL
        //removeFileAtURLIfExists(url: mergeVideoURL)
        
        
        VideoGenerator.mergeMovies(videoURLs: miArray as! [URL], andFileName: nombreArchivo, success: { (videoURL) in
            print(videoURL)
            if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                let context = container.viewContext
                
                
                self.libro?.file = nombreArchivo  + ".m4v"
                
                do {
                    try context.save()
                    //print("Grabo OK")
                    
                    
                } catch {
                    //print("Ha habido un error al guardar el lugar en Core Data")
                }
                
            }
            print("se creo video final ok!!!!")
            
            
            self.cargaVideo()
        }) { (error) in
            print(error)
        }
        
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
    
 
    
 
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    func mergedImageWith(frontImage:UIImage?, backgroundImage: UIImage?, Topox: CGFloat, Topoy: CGFloat) -> UIImage{
        
        let miW = AnchoTotal
        let miH = AltoTotal
        
        let miWParcial = self.view.frame.size.width
        //let miHParcial = self.view.frame.size.height
        
        let ancho = 3000 / self.view.frame.size.width
        let alto = (((1500 / ancho)))
        //let miy2 : Double = Double(alto / miHParcial)
        
        /*
         let mix : Double = Double(self.view.frame.size.width / cell.imgGaleria.frame.size.width)
         let ancho = 3000 / self.view.frame.size.width
         let alto = (((1500 / ancho)))
         let miy : Double = Double(alto / cell.imgGaleria.frame.size.height)
         */
        //*****************************************************************************
        let mix : Double = Double(CGFloat(miW) / miWParcial)
        let miy : Double = Double(CGFloat(miH) / alto)
        
        
        
        let topoxGuardada0 = Int(Topox)
        let topoyGuardada0 = Int(Topoy)
        
        let topoxGuardada: Double = Double(topoxGuardada0)
        let topoyGuardada: Double = Double(topoyGuardada0)
        
        let finalx: Double = topoxGuardada * mix
        let finaly: Double = topoyGuardada * miy
        
        //let pointTopo = CGPoint(x: finalx, y: finaly)
        
        //*****************************************************************************
        
        let topox = CGFloat(finalx)
        let topoy = CGFloat(finaly)
        
        if (backgroundImage == nil) {
            return frontImage!
        }
        
        //let size = self.view.frame.size
        
        //let miWidthFondo = self.view.frame.size.width
        //let miHeightFondo = self.view.frame.size.height
        
        let miWidthFondo = miW
        let miHeightFondo = miH
        
        //let miWidthTopo = self.view.frame.size.width
        //let miHeightTopo = self.view.frame.size.height
        
        let miWidthTopo = miW
        let miHeightTopo = miH
        
        let size = CGSize(width: miWidthFondo, height: miHeightFondo)
        
        let size2 = CGSize(width: miWidthTopo, height: miHeightTopo)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        //frontImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: size.width * 0.2, dy: size.height * 0.2))
        
        frontImage?.draw(in: CGRect.init(x: topox, y: topoy, width: size2.width, height: size2.height).insetBy(dx: size2.width * 0.0, dy: size2.height * 0.0))
        
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
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
    
    
}









