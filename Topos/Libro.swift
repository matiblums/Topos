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

class Libro : NSManagedObject {
    @NSManaged var titulo : String
    @NSManaged var autor : String
    @NSManaged var tapa : String
    @NSManaged var fecha : Date
}
