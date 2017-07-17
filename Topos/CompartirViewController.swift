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

 var avPlayer: AVPlayer!

class CompartirViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
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
        
        Ver()
    }
    
    func createVideo(image: NSString, musicaUrl:NSString, audioUrl:NSString, num: Int, numTotal: Int){
        
        let path1 = Bundle.main.path(forResource: image as String, ofType: "jpg")!
        
        let playAudio1 = NSURL(fileURLWithPath: Bundle.main.path(forResource: audioUrl as String, ofType: "m4a")!)
        
        var photosArray = [String]()
        
        let asset = AVURLAsset(url: playAudio1 as URL)
        let duration = Int(CMTimeGetSeconds(asset.duration))
        
        
        for _ in 0...duration {
            photosArray.append(path1)
        }
        
        let tlb = TimeLapseBuilder(photoURLs: photosArray)
        
        
        tlb.build(outputSize: CGSize(width: 1000, height: 502), progress: { (progress) -> Void in
            
            DispatchQueue.main.async{
                self.progressLabel.text = "rendering \(progress.completedUnitCount) of \(progress.totalUnitCount) frames"
                self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            }
            
        }, success: { (url) -> Void in
            print("SUCCESS: \(url)")
            DispatchQueue.main.async{
                self.progressLabel.isHidden = true
                self.progressView.isHidden = true
                
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
        let playAudio2 = NSURL(fileURLWithPath: Bundle.main.path(forResource: audioUrl as String, ofType: "m4a")!)
        
        
        let mixComposition : AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack : [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack : [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack2 : [AVMutableCompositionTrack] = []
        
        
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        //start merge
        let aVideoAsset : AVAsset = AVAsset(url: videoUrl as URL)
        let aAudioAsset : AVAsset = AVAsset(url: playAudio1 as URL)
        let aAudioAsset2 : AVAsset = AVAsset(url: playAudio2 as URL)
        
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
        mergedAudioVideoURl = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/FinalVideo\(num).mp4")
        
        
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileTypeMPEG4
        assetExport.outputURL = mergedAudioVideoURl as URL
        removeFileAtURLIfExists(url: mergedAudioVideoURl)
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {
            case AVAssetExportSessionStatus.completed:
                print("-----Merge mutable video with trimmed audio exportation complete.\(mergedAudioVideoURl)")
                //self.videoFirst = mergedAudioVideoURl as NSURL
                print("de \(num) aa \(numTotal)")
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
        mergeVideoURL = documentDirectoryURL.appendingPathComponent("MergeVideo.mp4")! as URL as NSURL
        
        let assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileTypeMPEG4
        assetExport?.outputURL = mergeVideoURL as URL
        removeFileAtURLIfExists(url: mergeVideoURL)
        
        
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
                    
                    
                    print("-----Merge Video exportation complete.\(mergeVideoURL)")
                    self.videoFinal = mergeVideoURL
                    
                    
                }
        })
    }

    
    //******************************************************************************************************************************
    
    
    
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
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url as URL)
        }) { saved, error in
            if saved {
                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
  
    }
    
    //***************************************************************************************************************************
    func verVideo(url: NSURL){
        
        // let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        avPlayer = AVPlayer(url: url as URL)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 3.0 / 4.0)
        self.view.layer.addSublayer(playerLayer)
        avPlayer.play()
        
    }
    
   

    
    @IBAction func creaVideo(_ sender: Any) {
        
        var imagesArray = ["fondo1", "fondo2"]
        var musicaArray = ["ta2", "ta3"]
        var audioArray = ["audio3", "audio2"]
        
        
        for i in 0 ..< imagesArray.count {
            
            createVideo(image: imagesArray[i] as NSString, musicaUrl: musicaArray[i] as NSString, audioUrl:audioArray[i] as NSString, num: i, numTotal: imagesArray.count)
            
        }
        
    }
    
    @IBAction func muestraVideo(_ sender: Any) {
        
        verVideo(url: self.videoFinal)
        
    }
    
    @IBAction func grabaVideo(_ sender: Any) {
        
        salvaVideo(url: self.videoFinal)
        
    }
    
    func Ver (){
        let fetchRequest : NSFetchRequest<Libro> = NSFetchRequest(entityName: "Libro")
        let sortDescriptor = NSSortDescriptor(key: "fecha", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.fetchResultsControllerLibro = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            self.fetchResultsControllerLibro.delegate = self as? NSFetchedResultsControllerDelegate
            
            
            do {
                try fetchResultsController.performFetch()
                self.libros = fetchResultsControllerLibro.fetchedObjects!
                
                //let dolencia = libros[1]
                //let fitSession =  dolencia.paginas![0] as! Pagina
                
                //print(fitSession.topo)
                
                
                // cell.textLabel!.text = dateFormatter.string(from: fitSession.date! as Date)
                
                //let pagina = libros[0].paginas
                //let resultado = pagina.topo
                
                
                
                //let dolencia = dolencias[3]
                
                // for name in casos {
                
                //   let caso = name
                //print (caso.caso)
                
                
                // }
                
                //self.tableView.refreshControl?.endRefreshing()
                //tableView.reloadData()
                
                //print("---: \(dolencia.nombre) ---: \(dolencias.count)")
                
                
            } catch {
                print("Error: \(error)")
            }
            
        }
        
    }
    
}


