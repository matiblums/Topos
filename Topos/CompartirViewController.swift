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
import NVActivityIndicatorView



class CompartirViewController: UIViewController , NVActivityIndicatorViewable, AVAudioPlayerDelegate{
    
    
    @IBOutlet weak var viewFondoBotones: UIView!
    
    @IBOutlet weak var viewVideo: UIView!
    
    @IBOutlet weak var viewTapa: UIView!
    @IBOutlet weak var btnPlayTotal: UIButton!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnCompartir: UIButton!
    
    
    @IBOutlet weak var imgTapa: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblAutor: UILabel!
    
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
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        //btnPlay.isHidden = true
        //btnPause.isHidden = true
        //viewTapa.isHidden = true
        
        controlaCantidad = 0
        self.viewTapa.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        verificaVIdeo()
        
    }
    
    func verificaVIdeo(){
        
        let miFile = self.libro?.file
        
        if(miFile?.isEmpty)!{
            
            creaVideo()
            
        }
        else{
            //creaVideo()
            cargaVideo()
        }
        
        
    }
    
    func cargaVideo(){
        self.viewTapa.isHidden = true
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let videoDataPath = documentsDirectory + "/" + (self.libro?.file)!
        let filePathURL = URL(fileURLWithPath: videoDataPath)
        verVideo(url: filePathURL as NSURL)
        isPlay = true
    }
    
    func creaVideo(){
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballClipRotate
        self.startAnimating()
        
        let miLibro = self.libro
 
        //let miAutor = self.libro?.autor
        //let miTitulo = self.libro?.titulo
        //let miTapa = self.libro?.tapa
        //lblAutor.text = miAutor
        //lblTitulo.text = miTitulo
        //let image: UIImage = UIImage(named: miTapa!)!
        //imgTapa.image = image
        
        
        
        let totales = miLibro?.paginas?.count
        
        let num = totales
        
        //****************************  primero carga tapa ********************************************

        let miPagina = miLibro!.paginas![num!-1] as! Pagina
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
        miImagen = UIImage.init(contentsOfFile: miFondo)!
        let imageOK = self.mergedImageWith(frontImage: UIImage.init(named: miTopo), backgroundImage: miImagen, Topox: cgFloatTopoX!, Topoy: cgFloatTopoY!)
        if let data = UIImagePNGRepresentation(imageOK) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(nombreArchivo)-.png")
            try? data.write(to: filename)
        }
        let filename = getDocumentsDirectory().appendingPathComponent("\(nombreArchivo)-.png")
        imagesArray.append(filename.path as NSString)
        musicaArray.append(miPagina.musica as NSString)
        audioArray.append(miPagina.audio as NSString)
        //******************************************************************************************************

        
        
        for i in 0...Int(num!)-2{
 
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
        
        if(num == 0){
            
            duration = 5
            
        }
        
        else{
            
            duration = Int(CMTimeGetSeconds(asset.duration))
            
        }
        
        
        for _ in 0...duration {
            //photosArray.append(path1)
            photosArray.append(path1 as String)
        }
        
        let tlb = TimeLapseBuilder(photoURLs: photosArray)
        
        
        let miWidthFondo = self.view.frame.size.width
        let miHeightFondo = self.view.frame.size.height
        
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
        
        let playAudio1 = NSURL(fileURLWithPath: Bundle.main.path(forResource: musicaUrl as String, ofType: "wav")!)
        
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
        
        
        if(num == 0){
            
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
        
        
        let miWidthFondo = self.view.frame.size.width
        let miHeightFondo = self.view.frame.size.height
        
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
        assetExport.shouldOptimizeForNetworkUse = true
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
            
            mergeVideoFiles(videoFileUrls: videosArray as NSArray)
            
        }
 
 
    }
    
    
    
    func mergeVideoFiles(videoFileUrls: NSArray) {
        
        var mergeVideoURL = NSURL()
        
        
        let mixComposition = AVMutableComposition()
        
        var duracionDesde = kCMTimeZero
        
        for i in 0 ..< videoFileUrls.count {
            
            
            let firstAsset = AVURLAsset(url: videoFileUrls[i] as! URL)
            
            do {
                try mixComposition.insertTimeRange(CMTimeRangeMake(kCMTimeZero, firstAsset.duration), of: firstAsset, at: duracionDesde)
            } catch _ {
                print("Failed to load first track")
        }
            
        duracionDesde = duracionDesde + firstAsset.duration
  
        }
        
      
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let random = randomString(length: 8)
        let nombreArchivo = random + ".mp4"
        mergeVideoURL = documentDirectoryURL.appendingPathComponent(nombreArchivo)! as URL as NSURL
        let assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileType.mp4
        assetExport?.outputURL = mergeVideoURL as URL
        removeFileAtURLIfExists(url: mergeVideoURL)
        
        
        
        assetExport?.exportAsynchronously(completionHandler:{
            
                switch assetExport!.status{
                    
                    case AVAssetExportSessionStatus.failed:
                        print("failed \(String(describing: assetExport?.error))")
                    case AVAssetExportSessionStatus.cancelled:
                        print("cancelled \(String(describing: assetExport?.error))")
                    case AVAssetExportSessionStatus.unknown:
                        print("unknown\(String(describing: assetExport?.error))")
                    case AVAssetExportSessionStatus.waiting:
                        print("waiting\(String(describing: assetExport?.error))")
                    case AVAssetExportSessionStatus.exporting:
                        print("exporting\(String(describing: assetExport?.error))")
                    default:
                        DispatchQueue.main.async() {
                           // print("-----Merge Video exportation complete.\(mergeVideoURL)")
                        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                            let context = container.viewContext
                            
                            //let url = mergeVideoURL.absoluteString! as NSString
                            
                            let url2 = nombreArchivo
                            
                            //self.libro?.file = url as String
                            
                            self.libro?.file = url2
                            
                            do {
                                try context.save()
                                //print("Grabo OK")
                                
                                
                            } catch {
                                //print("Ha habido un error al guardar el lugar en Core Data")
                            }
                            
                        }
                            
                            //self.videoFinalStr = mergeVideoURL.absoluteString! as NSString
                            //self.videoFinal = NSURL(string: self.videoFinalStr as String)!
                            
                        
                            self.stopAnimating()
                            //self.viewTapa.isHidden = false
                            
                            self.cargaVideo()
                        }
                    }
            })
        }

    
    //******************************************************************************************************************************
    
    
    
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
    
    func mergeAudioFiles(audioFileUrls: NSArray) {
        var mergeAudioURL = NSURL()
        
        let composition = AVMutableComposition()
        
        //for i in 0 ..< audioFileUrls.count {
            
            
        let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            
            let asset = AVURLAsset(url: (audioFileUrls[0] as! NSURL) as URL)
            
        let track = asset.tracks(withMediaType: AVMediaType.audio)[0]
        
            let timeRange = CMTimeRange(start: CMTimeMake(0, 600), duration: track.timeRange.duration)
        
            try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
        
        
            
            
        //}
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        mergeAudioURL = documentDirectoryURL.appendingPathComponent("Merge Audio.m4a")! as URL as NSURL
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = mergeAudioURL as URL
        removeFileAtURLIfExists(url: mergeAudioURL)
        assetExport?.exportAsynchronously(completionHandler:
            {
                switch assetExport!.status
                {
                case AVAssetExportSessionStatus.failed:
                    print("failed \(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(String(describing: assetExport?.error))")
                default:
                    
                    
                    print("-----Merge audio exportation complete.\(mergeAudioURL)")
                   
                    
                    
                }
        })
    }
    
    
    //***************************************************************************************************************************
    
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
    
    //***************************************************************************************************************************
    
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
    
    //***************************************************************************************************************************
    func verVideo(url: NSURL){
        //btnPlay.isHidden = true
       // btnPause.isHidden = false
        //viewTapa.isHidden = true
        
        
        avPlayer = AVPlayer(url: url as URL)
        let playerLayer = AVPlayerLayer()
        playerLayer.player = avPlayer
        playerLayer.frame = self.viewVideo.bounds
        playerLayer.backgroundColor = UIColor.clear.cgColor
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        /*
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
            //viewTapa.isHidden = false

        }
         */
        
        self.viewVideo.layer.addSublayer(playerLayer)
        avPlayer.play()
        
        
        
        
        
        //NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),
                                              // name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidStartPlaying(note:)),name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: avPlayer.currentItem)
    
    }
    
    
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        self.viewTapa.isHidden = false
        //viewTapa.isHidden = false
        //btnPlay.isHidden = true
        //btnPause.isHidden = true
        
    }
    
    @objc func playerDidStartPlaying(note: NSNotification) {
        
        
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
        
        let miWidthFondo = self.view.frame.size.width
        let miHeightFondo = self.view.frame.size.height
        
        let miWidthTopo = 176
        let miHeightTopo = 200
        
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
    
    @IBAction func elijeBorrar(_ sender: Any) {
        
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
    
    @IBAction func elijePlayTotal(_ sender: Any){
        
        cargaVideo()
        
    }
    
    @IBAction func elijePlay(_ sender: Any){
        
        btnPlay.isHidden = true
        btnPause.isHidden = false
        avPlayer.play()
        
    }
    
    @IBAction func elijePausa(_ sender: Any){
        
        btnPlay.isHidden = false
        btnPause.isHidden = true
        avPlayer.pause()
        
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
    
}








