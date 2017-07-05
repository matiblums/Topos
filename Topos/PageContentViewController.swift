//
//  PeliculaViewController.swift
//  Topos
//
//  Created by Matias Blum on 4/6/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreData

class PageContentViewController: UIViewController {
    
    public static let NotificationIdentifierSinc = Notification.Name(rawValue: "NotificationIdentifierSinc")
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var timerTest: Timer? = nil
    var timer = 0
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strPhotoName: String!
    
    @IBOutlet var miFondo: UIImageView!
    @IBOutlet var miTopo: UIImageView!
    
    
    var player1: AVAudioPlayer?
    var player2: AVAudioPlayer?
    
    var duracionPlayer2 = 0
    
    var paginas : [Pagina] = []
    var fetchResultsController : NSFetchedResultsController<Pagina>!
    var pagina : Pagina?
    
    var libros : [Libro] = []
    var fetchResultsControllerLibro : NSFetchedResultsController<Libro>!
    var libro : Libro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VerTodo ()
        lblTitle.text = "Pagina: " + "\(pageIndex + 1 )"
        startTimer ()
        
    }
  
    
   
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("finaliza")
        player1?.stop()
        player2?.stop()
        stopTimerTest()
        
    }
    
    func startTimer () {
        timerTest =  Timer.scheduledTimer(
            timeInterval: TimeInterval(1.0),
            target      : self,
            selector    : #selector(PageContentViewController.timerActionTest),
            userInfo    : nil,
            repeats     : true)
    }
    
    func timerActionTest() {
        
        timer = timer + 1
        
        let prepara = 1
        let espacio = 2
        
        let arranca1 = espacio
        let arranca2 = espacio + espacio
        let termina1 = duracionPlayer2 + prepara + arranca2
        let termina2 = termina1 + espacio
        let finaliza = termina2 + espacio
        
        
        switch self.timer {
            
        case prepara:
            print("prepara")
            playSound1()
            playSound2()
            
            break
            
        case arranca1:
            print("arranca1")
            player1?.play()
            player1?.setVolume(1.0, fadeDuration: 2)
            
            break
            
        case arranca2:
            print("arranca2")
            player2?.play()
            player1?.setVolume(0.2, fadeDuration: 2)
            player2?.setVolume(1.0, fadeDuration: 2)
            
            break
            
        case termina1:
            print("termina1")
            player2?.setVolume(0.0, fadeDuration: 2)
            player1?.setVolume(1.0, fadeDuration: 2)
            break
            
        case termina2:
            print("termina2")
            player1?.setVolume(0.0, fadeDuration: 2)
            break
            
        case finaliza:
            print("finaliza")
            player1?.stop()
            player2?.stop()
            stopTimerTest()
            
            NotificationCenter.default.post(name: PageContentViewController.NotificationIdentifierSinc, object: self)
            break
            
        default:
            break
        }
            
        print(timer)
        
    }
    
    func playSound1() {
        
        
        let musicaGuardada = self.pagina?.musica
        
      
        
        do {
            let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: musicaGuardada, ofType: "wav")!)
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player1 = try AVAudioPlayer(contentsOf: url as URL)
            player1?.prepareToPlay()
            player1?.numberOfLoops = 10
            
            //guard let player1 = player1 else { return }
            
            //player1.play()
            //player1.numberOfLoops = 10
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound2() {
       
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player2 = try AVAudioPlayer(contentsOf: self.directoryURL()! as URL)
            player2?.prepareToPlay()
            
            
            //guard let player2 = player2 else { return }
            
            let i = Int((player2?.duration)!)
            duracionPlayer2 = i
            
            
            
            //player2.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopTimerTest() {
        if timerTest != nil {
            timerTest?.invalidate()
            timerTest = nil
        }
    }
    
    
    //**************************************************
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func directoryURL() -> NSURL? {
        let sonidoGuardado = self.pagina?.audio
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(sonidoGuardado!)
        return soundURL as NSURL?
    }
    
    func VerTodo (){
        
        let fondo = self.pagina?.fondo
        let topo = self.pagina?.topo
        let topox = self.pagina?.topox
        let topoy = self.pagina?.topoy
        
        let pointTopo = CGPoint(x: Int(topox!)!, y: Int(topoy!)!)
        let imageFondo: UIImage = UIImage(named: fondo!)!
        miFondo.image = imageFondo
        
        let imageTopo: UIImage = UIImage(named: topo!)!
        miTopo.image = imageTopo
        
        miTopo.frame.origin = pointTopo
        
    }
    
    
}












