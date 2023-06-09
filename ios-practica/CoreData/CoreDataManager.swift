//
//  CoreDataManager.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/21/23.
//

import CoreData
import Foundation

class CoreDataManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error {
                debugPrint("Error during loading persistent stores \(error)")
            }
        }
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            debugPrint("Error during saving context \(error)\n")
        }
    }
    
    static func saveApiDataToCoreData(_ heroesSendToMapping: [HeroModel]) {
        
        print("Starting saveApiDataToCoreData...")
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        heroesSendToMapping.forEach { heroSendToMapping in
        
            let heroRecFmMapping = HeroCD(context: context)
            
            heroRecFmMapping.id = heroSendToMapping.id
            heroRecFmMapping.name = heroSendToMapping.name
            heroRecFmMapping.desc = heroSendToMapping.description
            heroRecFmMapping.photo = heroSendToMapping.photo
            heroRecFmMapping.favorite = heroSendToMapping.favorite
            heroRecFmMapping.latitude = heroSendToMapping.latitude ?? 0.0
            heroRecFmMapping.longitude = heroSendToMapping.longitude ?? 0.0
            
            do {
                try context.save()
            } catch let error {
                debugPrint(error)
            }
        }
    }
    
    // code credit: PracticaResueltalOSAvanzado
    static func getCoreDataForPresentation() -> [HeroModel] {
        
        print("\nStarting getCoreDataForPresentation...\n")
        
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        let heroFetch: NSFetchRequest<HeroCD> = HeroCD.fetchRequest()
        
        do {
            let result = try context.fetch(heroFetch)
            
            let heroToPresent = result.map {
                HeroModel.init(id: $0.id ?? "",
                               name: $0.name ?? "",
                               photo: $0.photo ?? "",
                               description: $0.desc ?? "",
                               favorite: $0.favorite,
                               latitude: $0.latitude,
                               longitude: $0.longitude)
            }

            return heroToPresent
        } catch let error as NSError {
            debugPrint("Error: \(error)")
            return []
        }
    }
    
    static func readCoreDataInCDFormat() -> [HeroCD] {
        let heroFetch: NSFetchRequest<HeroCD> = HeroCD.fetchRequest()
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        do {
            let result = try context.fetch(heroFetch)
            return result
        } catch let error as NSError {
            debugPrint("Error -> \(error)")
            return []
        }
    }
    
    static func deleteCoreData() {
        var heroesToDelete = CoreDataManager.readCoreDataInCDFormat()
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        print("Core Data inventory check of heroes: \(heroesToDelete.count)\n")
        heroesToDelete.forEach { heroToDelete in
            
            context.delete(heroToDelete)
            AppDelegate.sharedAppDelegate.coreDataManager.saveContext()
        }
        heroesToDelete = CoreDataManager.readCoreDataInCDFormat()
        print("Core Data inventory check of heroes: \(heroesToDelete.count)\n")
    }
}
