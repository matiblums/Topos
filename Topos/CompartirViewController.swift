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
    
    var videoFinal = NSURL()
    
    var paginas : [Pagina] = []
    var fetchResultsController : NSFetchedResultsController<Pagina>!
    var pagina : Pagina?
    
    var libros : [Libro] = []
    var fetchResultsControllerLibro : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        btnPlay.isHidden = true
        btnPause.isHidden = true
        viewTapa.isHidden = true
        
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballClipRotate
        
        self.startAnimating()
        
        
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        creaVideo()
        
    }
    
    func creaVideo(){
        

 
 
        let miLibro = self.libro
 
        let miAutor = self.libro?.autor
        let miTitulo = self.libro?.titulo
        let miTapa = self.libro?.tapa
        lblAutor.text = miAutor
        lblTitulo.text = miTitulo
        let image: UIImage = UIImage(named: miTapa!)!
        imgTapa.image = image
        
        
        
        let totales = miLibro?.paginas?.count
        
        let num = totales
        var imagesArray = [NSString]()
        var musicaArray = [NSString]()
        var audioArray = [NSString]()
        
    
        
        for i in 0...Int(num!)-1{
 
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
            let imageOK = self.mergedImageWith(frontImage: UIImage.init(named: miTopo), backgroundImage: UIImage.init(named: miFondo), Topox: cgFloatTopoX!, Topoy: cgFloatTopoY!)
            
            if let data = UIImagePNGRepresentation(imageOK) {
                let filename = getDocumentsDirectory().appendingPathComponent("\(nombreArchivo)copy.png")
                try? data.write(to: filename)
            }
            
            let filename = getDocumentsDirectory().appendingPathComponent("\(nombreArchivo)copy.png")

            //******************************************************************************************************
            
            imagesArray.append(filename.path as NSString)

            musicaArray.append(miPagina.musica as NSString)
            audioArray.append(miPagina.audio as NSString)
            
        }
        
        
        for i in 0 ..< imagesArray.count {
            
            createVideo(image: imagesArray[i] as NSString, musicaUrl: musicaArray[i] as NSString, audioUrl:audioArray[i] as NSString, num: i, numTotal: imagesArray.count)
            
        }
        
        
    }

   
    
    func createVideo(image: NSString, musicaUrl:NSString, audioUrl:NSString, num: Int, numTotal: Int){
        
        
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
        let duration = Int(CMTimeGetSeconds(asset.duration))
        
        
        for _ in 0...duration {
            //photosArray.append(path1)
            photosArray.append(path1 as String)
        }
        
        let tlb = TimeLapseBuilder(photoURLs: photosArray)
        
        
        tlb.build(outputSize: CGSize(width: 1000, height: 502), progress: { (progress) -> Void in
            
            DispatchQueue.main.async{
                //self.progressLabel.text = "rendering \(progress.completedUnitCount) of \(progress.totalUnitCount) frames"
                //self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            }
            
        }, success: { (url) -> Void in
            //print("SUCCESS: \(url)")
            DispatchQueue.main.async{
                //self.progressLabel.isHidden = true
                //self.progressView.isHidden = true
                
                self.mergeMutableVideoWithAudio(videoUrl: url as NSURL, musicaUrl: musicaUrl, audioUrl: audioUrl, num: num, numTotal: numTotal )
                
            }
            
        }) { (error) -> Void in
            print(error)
        }
        
    }
    
    //***************************************************************************************************************************
    
    func mergeMutableVideoWithAudio(videoUrl:NSURL, musicaUrl:NSString, audioUrl:NSString, num: Int, numTotal: Int){
        
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
        
        mutableCompositionVideoTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid))
        
        mutableCompositionAudioTrack.append( mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid))
        
        mutableCompositionAudioTrack2.append( mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid))
        
        let aVideoAssetTrack : AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        let aAudioAssetTrack : AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaTypeAudio)[0]
        let aAudioAssetTrack2 : AVAssetTrack = aAudioAsset2.tracks(withMediaType: AVMediaTypeAudio)[0]
        
        
        do{
            try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: kCMTimeZero)
            
            try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: kCMTimeZero)
            
            try mutableCompositionAudioTrack2[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration),   of: aAudioAssetTrack2, at: kCMTimeZero)
            
            
        }catch{
            
        }
        
        
        
        totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,aVideoAssetTrack.timeRange.duration )
        let mutableVideoComposition : AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(1, 30)
        mutableVideoComposition.renderSize = CGSize(width: 1280, height: 720)
        
        let random = randomString(length: 8)
        
        let nombreArchivo = random
        
        
        mergedAudioVideoURl = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/FinalVideo\(nombreArchivo).mp4")
        
        
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileTypeMPEG4
        assetExport.outputURL = mergedAudioVideoURl as URL
        removeFileAtURLIfExists(url: mergedAudioVideoURl)
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {
            case AVAssetExportSessionStatus.completed:
                //print("-----Merge mutable video with trimmed audio exportation complete.\(mergedAudioVideoURl)")
                //self.videoFirst = mergedAudioVideoURl as NSURL
                //print("de \(num) aa \(numTotal)")
                self.almacenaVideos(miVideo:  mergedAudioVideoURl, position: num, total: numTotal)
                
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
        
        if(videosArray.count == 0){
            
            for _ in 0...100 {
                videosArray.append(miVideo)
            }
            
        }
        
        videosArray.insert(miVideo, at: position)
        
        if(videosArray.count == total + 101){
            
            let  mas = videosArray.count - 1
            let  menos = 0 + total
            
            var i = mas
            
            for _ in menos...mas{
                videosArray.remove(at: i)
                i = i - 1
            }
            
            mergeVideoFiles(videoFileUrls: videosArray as NSArray)
            
        }
        
    }
    
    
    
    func mergeVideoFiles(videoFileUrls: NSArray) {
        
        var mergeVideoURL = NSURL()
        
        
        let mixComposition = AVMutableComposition()
        
        
        for i in 0 ..< videoFileUrls.count {
            
            
            
            if(i == 0){
                
                let firstAsset = AVURLAsset(url: videoFileUrls[i] as! URL)
                
                do {
                    try mixComposition.insertTimeRange(CMTimeRangeMake(kCMTimeZero, firstAsset.duration), of: firstAsset, at: kCMTimeZero)
                } catch _ {
                    print("Failed to load first track")
                }
            }
            else{
                
                let firstAsset = AVURLAsset(url: videoFileUrls[i - 1] as! URL)
                let secondAsset = AVURLAsset(url: videoFileUrls[i] as! URL)
                
                do {
                    try mixComposition.insertTimeRange(CMTimeRangeMake(kCMTimeZero, secondAsset.duration), of: secondAsset, at: firstAsset.duration)
                } catch _ {
                    print("Failed to load second track")
                }
                
                
            }
            
        }
        
      
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let random = randomString(length: 8)
        let nombreArchivo = random + ".mp4"
        mergeVideoURL = documentDirectoryURL.appendingPathComponent(nombreArchivo)! as URL as NSURL
        let assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileTypeMPEG4
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
                            self.videoFinal = mergeVideoURL
                            self.stopAnimating()
                            self.viewTapa.isHidden = false
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
            
            
            let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
            
            let asset = AVURLAsset(url: (audioFileUrls[0] as! NSURL) as URL)
            
            let track = asset.tracks(withMediaType: AVMediaTypeAudio)[0]
        
            let timeRange = CMTimeRange(start: CMTimeMake(0, 600), duration: track.timeRange.duration)
        
            try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
        
        
            
            
        //}
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        mergeAudioURL = documentDirectoryURL.appendingPathComponent("Merge Audio.m4a")! as URL as NSURL
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileTypeAppleM4A
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
        
        avPlayer = AVPlayer(url: url as URL)
        let playerLayer = AVPlayerLayer()
        playerLayer.player = avPlayer
        playerLayer.frame = self.viewVideo.bounds
        playerLayer.backgroundColor = UIColor.clear.cgColor
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        self.viewVideo.layer.addSublayer(playerLayer)
        avPlayer.play()
        
        
        //NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),
                                              // name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidStartPlaying(note:)),name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: avPlayer.currentItem)
        
        
        /*
        //let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        avPlayer = AVPlayer(url: url as URL)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 3.0 / 4.0)
        self.view.layer.addSublayer(playerLayer)
        avPlayer.play()
        */
    }
    
    
    
    func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        
        viewTapa.isHidden = false
        btnPlay.isHidden = true
        btnPause.isHidden = true
        
    }
    
    func playerDidStartPlaying(note: NSNotification) {
        
        
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
        
        let size = CGSize(width: 3000, height: 1506)
        
        let size2 = CGSize(width: 926, height: 1049)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        //frontImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: size.width * 0.2, dy: size.height * 0.2))
        
        frontImage?.draw(in: CGRect.init(x: topox, y: topoy, width: size2.width, height: size2.height).insetBy(dx: size2.width * 0.0, dy: size2.height * 0.0))
        
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    @IBAction func creaVideo(_ sender: Any){
        
        creaVideo()
        
    }
    
    @IBAction func muestraVideo(_ sender: Any) {
        
        
        verVideo(url: self.videoFinal)
        
    }
    
    @IBAction func grabaVideo(_ sender: Any) {
        
        salvaVideo(url: self.videoFinal)
        
    }
    
    @IBAction func elijeVolver(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func elijePlayTotal(_ sender: Any){
        
        btnPlay.isHidden = true
        btnPause.isHidden = false
        viewTapa.isHidden = true
        
        self.verVideo(url: self.videoFinal)
        
        
        
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
        
        comparteVideo(url: self.videoFinal)
        
    }
    
}


