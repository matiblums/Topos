//
//  ViewController.swift
//  FDSoundActivatedRecorder
//
//  Created by William Entriken on 1/30/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
//import SwiftySound
//import KDEAudioPlayer

import CoreMedia
import Foundation
import CoreData



class GrabarAudioViewController: UIViewController ,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet var botonOK: UIButton!
    
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    var audioPlayer : AVAudioPlayer!
    //var playerGrabado = AudioPlayer()
    
    @IBOutlet var botonRecOn: UIButton!
    @IBOutlet var botonPlay: UIButton!
    @IBOutlet var myProgress: UIProgressView!
    var updater : CADisplayLink! = nil
    
    
    @IBOutlet var miFondo: UIImageView!
    @IBOutlet var miTopo: UIImageView!
    
    var paginas : [Pagina] = []
    var fetchResultsControllerPagina : NSFetchedResultsController<Pagina>!
    var pagina: Pagina?
    
    var libros : [Libro] = []
    var fetchResultsController : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //***************************************************************************
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {  allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //print("Allow")
                    } else {
                        //print("Dont Allow")
                    }
                }
            }
        } catch {
            //print("failed to record!")
        }
        
        // Audio Settings
        
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        //***************************************************************************
        //self.directoryURL()
        
        
         botonOK.isHidden = true
        //grabarLibro()
        //Ver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        botonPlay.isHidden = true
        
        
        let imgFondo = UserDefaults.standard.string(forKey: "fondo")
        let imgTopo = UserDefaults.standard.string(forKey: "topo")
        let topoxGuardada = UserDefaults.standard.integer(forKey: "topox")
        let topoyGuardada = UserDefaults.standard.integer(forKey: "topoy")
        let pointTopo = CGPoint(x: topoxGuardada, y: topoyGuardada)
        let imageFondo: UIImage = UIImage(named: imgFondo!)!
        miFondo.image = imageFondo
        
        let imageTopo: UIImage = UIImage(named: imgTopo!)!
        miTopo.image = imageTopo
        
        miTopo.frame.origin = pointTopo
        
    }
    
    @IBAction func btnGraba(_ sender: Any) {
        
        self.startRecording()
        
        botonPlay.isHidden = true
        
        myProgress.setProgress(0, animated: false)
        
    }
    
    @IBAction func btnGrabaStop(_ sender: Any) {
        
        self.finishRecording(success: true)
        
        botonPlay.isHidden = false
        botonOK.isHidden = false
    }
    
    
    
    @IBAction func btnPlay(_ sender: Any) {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        
       // audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,settings: settings)
        
        if !audioRecorder.isRecording {
            //audioPlayer = try! AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer = try! AVAudioPlayer(contentsOf: self.directoryURLPlay()! as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.play()
        }
        
        updater = CADisplayLink(target: self,
                                        selector: #selector(step))
        
        updater.add(to: .current,
                        forMode: .defaultRunLoopMode)
        
        myProgress.setProgress(0, animated: false)
        
        botonPlay.isHidden = true
    }
    
 
    
    func step(updater: CADisplayLink) {
        //print(updater.timestamp)
        let normalizedTime = Float(audioPlayer.currentTime * 1.0 / audioPlayer.duration)
        
        myProgress.setProgress(normalizedTime, animated: true)
        
        
       print( myProgress.progress)
        
        
        
    }
    
    
    @IBAction func btnSalir(_ sender: Any) {
        
        if((audioPlayer) != nil){
            audioPlayer.stop()
        }
        
        grabar()
        dismiss(animated: true, completion: nil)
        
        
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
    
    
    //***************************************************************************
    func directoryURL() -> NSURL? {
        
        
        
        let random = randomString(length: 8)
        
        let nombreArchivo = random + ".m4a"
        
        print(nombreArchivo)
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(nombreArchivo)
        
        UserDefaults.standard.set(nombreArchivo, forKey: "audio")
        
        return soundURL as NSURL?
    }
    
    func directoryURLPlay() -> NSURL? {
        
        
        
        //let random = UserDefaults.standard.string(forKey: "audio")
        
        let nombreArchivo = UserDefaults.standard.string(forKey: "audio")
        
        //print(nombreArchivo)
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(nombreArchivo!)
        
        
        
        return soundURL as NSURL?
    }
    
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success {
            //print(success)
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }
    
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        updater.invalidate()
        myProgress.setProgress(1, animated: true)
        botonPlay.isHidden = false
    }
   
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print(player.debugDescription)
    }
    
    //***************************************************************************
    
    func grabar() {
        
        
        let topo = UserDefaults.standard.string(forKey: "topo")
        let topox = UserDefaults.standard.integer(forKey: "topox")
        let topoy = UserDefaults.standard.integer(forKey: "topoy")
        let fondo = UserDefaults.standard.string(forKey: "fondo")
        let musica = UserDefaults.standard.string(forKey: "musica")
        let audio = UserDefaults.standard.string(forKey: "audio")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        _ = formatter.string(from: date)
        
        
        
        
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.pagina = NSEntityDescription.insertNewObject(forEntityName: "Pagina", into: context) as? Pagina
            
            
            
            self.pagina?.topo = topo!
            self.pagina?.topox = "\(topox)"
            self.pagina?.topoy = "\(topoy)"
            self.pagina?.fondo = fondo!
            self.pagina?.musica = musica!
            self.pagina?.audio = audio!
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
    
    func grabarLibro() {
        let titulo = "titulo"
        let autor = "autor"
        let tapa = "tapa"
        let fecha = Date()
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            //self.libro = NSEntityDescription.insertNewObject(forEntityName: "Libro", into: context) as? Libro
            
            self.libro?.titulo = titulo
            self.libro?.autor = autor
            self.libro?.tapa = tapa
            self.libro?.fecha = fecha
            
            
            do {
                try context.save()
                print("Grabo OK")
                //irBiblioteca ()
                
            } catch {
                print("Ha habido un error al guardar el lugar en Core Data")
            }
            
            
        }
        
    }
    
    func Ver (){
        let fetchRequest : NSFetchRequest<Libro> = NSFetchRequest(entityName: "Libro")
        let sortDescriptor = NSSortDescriptor(key: "fecha", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            self.fetchResultsController.delegate = self as? NSFetchedResultsControllerDelegate
            
            
            do {
                try fetchResultsController.performFetch()
                self.libros = fetchResultsController.fetchedObjects!
                
                let dolencia = libros[1]
                let fitSession =  dolencia.paginas![0] as! Pagina
                
                print(fitSession.topo)
                
                
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

