//
//  BaseViewController.swift
//  MilanDemo
//
//  Created by Milan on 03/09/21.
//  Copyright © 2021 Milan. All rights reserved.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {
    
    //MARK:- Properties
    
    //MARK:- LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK:- Functions
    func getRecord(byId id: UUID) -> ApiData? {
        let fetchRequest = NSFetchRequest<ApiData>(entityName: "ApiData")
        let fetchById = NSPredicate(format: "id==%@", id as CVarArg)
        fetchRequest.predicate = fetchById
        
        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        guard result.count != 0 else {return nil}
        
        return result.first
    }
    
    func deleteRecord(byIdentifier id: UUID) -> Bool {
        let data = getRecord(byId: id)
        guard data != nil else {return false}
        
        PersistentStorage.shared.context.delete(data!)
        PersistentStorage.shared.saveContext()
        
        return true
    }
    
    
    func showMessageAlert(inVc: UIViewController, title: String, andMessage message: String, withOkButtonTitle okButtonTitle: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action) -> Void in
            
        }))
        
        inVc.present(alertController, animated: true, completion: nil)
    }
}
