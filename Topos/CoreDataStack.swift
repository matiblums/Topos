//
//  CoreDataStack.swift
//  ChicoFit
//
//  Created by Juan Gabriel Gomila Salas on 1/6/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import CoreData

class CoreDataStack{
    
    let modelName = "ChicoFit"
    
    fileprivate lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    
    fileprivate lazy var psc: NSPersistentStoreCoordinator = {
       let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.modelName)
        do{
            let options = [NSMigratePersistentStoresAutomaticallyOption:true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
            
        }catch {
            print("Error creando el Persistent Store Coordinator")
        }
        
        return coordinator
    }()
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
       let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: modelURL!)
        return model!
    }()
    
    func saveContext(){
        if context.hasChanges {
            do{
                try context.save()
            }catch let error as NSError{
                print(error.localizedDescription)
                abort()
            }
        }
    }
    
}
