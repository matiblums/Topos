//
//  DescripcionViewController.swift
//  Topos
//
//  Created by Matias Blum on 27/9/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import UIKit

import AVKit
class DescripcionViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet var miTexVIew: UITextView!
    @IBOutlet var imgTitulo: UIImageView!
    @IBOutlet var btnVolver: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let miImagenTitulo = (NSLocalizedString("IMG_TITULO_LIBRERIA", comment: ""))
        let image: UIImage = UIImage(named: miImagenTitulo)!
        self.imgTitulo.image = image
        
        let miImagenVolver = (NSLocalizedString("BTN_VOLVER", comment: ""))
        btnVolver.setImage(UIImage(named: miImagenVolver), for: .normal)
        
        // Do any additional setup after loading the view.
        
        let miTexto : String =
        """
        Esta aplicación surge como una idea creativa que les propone a los chicos ser activos generadores de sus propias historias.
        Los cuentos, los relatos, las narraciones orales les permiten a los niños construir sentidos, representar el tiempo y el espacio, poner palabras compartidas a emociones intensas o a emociones inesperadas, representar conflictos, simbolizar lo que (les) sucede.
        “Cuentos para soñar y hacer” invita a los chicos a construir, ellos mismos, sus propias historias, a imaginar nuevas realidades,  a inventar, de manera original y singular, un universo propio de relatos, en un mundo que siempre es más amplio y cambiante.
        Estas historias inventadas y grabadas, quizás puedan, algún día, conservarse como ese tesoro singular de un tiempo en el que los cuentos y los relatos poblaron la infancia.
        Allí quedarán, tal vez, las huellas imborrables de lo que ese niño, esa niña, un día imaginó…

        Equipo:
        
        Bien contenidos:
        Lic. María Luisa Sánchez Chiappe
        Lic. Bárbara Gelbaum

        Dibujos:
        Lic. María Luisa Sánchez Chiappe

        Diseño:
        Nico Risso
        
        Desarrollo app:
        Ana Clara Zaccra
        Matías Blum
        
        Música original:
        Emiliano Khayat

        Produccion de Sonido:
        Franco Khayat

        (c) 2017 Bien Contenidos
        biencontenidos@gmail.com
        Facebook: Bien Contenidos
        www.biencontenidos.com
        
        Se sugiere que está App sea ofrecida y utilizada dentro de una amplia variedad de opciones en las que también se priorice el juego con otros, el tiempo al aire libre y el contacto con los libros. La multiplicidad de ofertas lúdicas y recreativas favorecen al desarrollo integral de un niño.

        """
        
        miTexVIew.text = miTexto
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        let playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: "TA1", ofType: "mp3")!)
        audioPlayer = try! AVAudioPlayer(contentsOf: playYoda as URL)
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        audioPlayer.numberOfLoops = 99
        //audioPlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioPlayer.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func elijeVolver(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Libreria", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Libreria") as! LibreriaViewController
        
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true, completion: nil)
        
    }

}
