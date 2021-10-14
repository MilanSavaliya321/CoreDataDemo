//
//  ViewController.swift
//  MilanDemo
//
//  Created by Milan on 03/09/21.
//  Copyright © 2021 Milan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblDemo: UITableView!
    
    
    //MARK:- Properties
    var viewModel = ViewModel()
    var arrCoreDbRecord = [ApiData]()
    
    //MARK:- LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Title & Body"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    //MARK:- Functions
    private func setupData() {
        setupTableView()
        fetchRecordsFromDB()
        if arrCoreDbRecord.count == 0 {
            callApi()
        }
    }
    
    private func setupTableView() {
        tblDemo.delegate = self
        tblDemo.dataSource = self
        tblDemo.register(DemoCell.nib, forCellReuseIdentifier: DemoCell.identifier)
        tblDemo.reloadData()
    }
    
    private func callApi() {
        viewModel.getAllData { (sucess, msg) in
            
            DispatchQueue.main.async {
                if sucess {
                    self.createRecord()
                    self.fetchRecordsFromDB()
                    print("sucess")
                } else {
                    self.showMessageAlert(inVc: self, title: "Error", andMessage: msg, withOkButtonTitle: "Ok")
                }
            }
        }
    }
    
    func createRecord() {
        for i in viewModel.arrResult {
            let data = ApiData(context: PersistentStorage.shared.context)
            data.id = UUID()
            data.title = i.title
            data.body = i.body
            PersistentStorage.shared.saveContext()
        }
    }
    
    func fetchRecordsFromDB() {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(path[0])
        
        do {
            guard let result = try PersistentStorage.shared.context.fetch(ApiData.fetchRequest()) as? [ApiData] else {return}
            self.arrCoreDbRecord.removeAll()
            self.arrCoreDbRecord.append(contentsOf: result)
            self.tblDemo.reloadData()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCoreDbRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DemoCell.identifier) as? DemoCell else{return UITableViewCell()}
        
        let data = self.arrCoreDbRecord[indexPath.row]
        cell.lblTitle.text = "Title = \(data.title ?? "")"
        cell.lblDesc.text = "Body = \(data.body ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editDataVC = EditDataVC.instantiate(fromAppStoryboard: .Main)
        editDataVC.RecordID = self.arrCoreDbRecord[indexPath.row].id
        self.navigationController?.pushViewController(editDataVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionDelete = UIContextualAction(
            style: .destructive,
            title: "Delete",
            handler: { (action, view, completion) in
                
                print("delete click")
                let alert = UIAlertController(title: "Are you sure you want to delete this record?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction) in
                    let isdelete = self.deleteRecord(byIdentifier: self.arrCoreDbRecord[indexPath.row].id!)
                    if isdelete {
                        self.fetchRecordsFromDB()
                        self.tblDemo.reloadData()
                        self.showMessageAlert(inVc: self, title: "Sucess", andMessage: "deleted Sucess", withOkButtonTitle: "OK")
                    }
                    
                    completion(true)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                    
                }))
                
                self.present(alert, animated: true, completion: {
                    
                })
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [actionDelete])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}
