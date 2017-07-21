//
//  Consulta.swift
//  AC-Estudiantil
//
//  Created by Matias Blum on 20/5/17.
//  Copyright © 2017 Matias Blum. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Pagina : NSManagedObject {
    @NSManaged var fileAudio : String
    @NSManaged var filePng : String
    @NSManaged var fileVideo1 : String
    @NSManaged var fileVideo2 : String
    @NSManaged var audio : String
    @NSManaged var fondo : String
    @NSManaged var musica : String
    @NSManaged var topo : String
    @NSManaged var topox : String
    @NSManaged var topoy : String
    @NSManaged var fecha : Date
}
