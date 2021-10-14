//
//  EditDataVC.swift
//  MilanDemo
//
//  Created by Milan on 03/09/21.
//  Copyright © 2021 Milan. All rights reserved.
//

import UIKit

class EditDataVC: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var tvBody: UITextView!
    
    
    //MARK:- Properties
    var RecordID: UUID!
    
    //MARK:- LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Data"
        loadDataByID()
    }
    
    //MARK:- Functions
    func loadDataByID() {
        if let data = self.getRecord(byId: RecordID) {
            self.tvTitle.text = data.title
            self.tvBody.text = data.body
            
        } else {
            self.showMessageAlert(inVc: self, title: "Invalid Data", andMessage: "Data is not valid", withOkButtonTitle: "Ok")
        }
    }
    
    
    func updateRecord(id: UUID) -> Bool {
        if let data = self.getRecord(byId: RecordID) {
            data.title = self.tvTitle.text
            data.body = self.tvBody.text
            PersistentStorage.shared.saveContext()
            
        } else {
            self.showMessageAlert(inVc: self, title: "Invalid Data", andMessage: "Data is not valid", withOkButtonTitle: "Ok")
        }
        return true
    }
    
    
    //MARK:- IBActions
    @IBAction func onBtnUpdate(_ sender: UIButton) {
        if updateRecord(id: self.RecordID) {
            self.showMessageAlert(inVc: self, title: "Success", andMessage: "data updated successfully", withOkButtonTitle: "Ok")
        }
    }
    
}
