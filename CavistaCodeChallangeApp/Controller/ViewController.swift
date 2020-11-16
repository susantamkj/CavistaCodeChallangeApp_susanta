//
//  ViewController.swift
//  CavistaCodeChallangeApp
//
//  Created by Susanta Mukherjee on 30/10/2020.
//  Copyright © 2020 Susanta Mukherjee. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift


protocol DataPresentationDelegate {
    
    func PresentData(response: [Contents])
}

class ViewController: UIViewController,DataPresentationDelegate {
   
     let detailsView = DetailsViewController()
    private var embedController: EmbedController?
    let realm = try! Realm()
    var contentes : Results<Contents>?
    var tableView = UITableView()
    var subView = UIView()
    var activityIndicator: UIActivityIndicatorView!
    let containerViewHeight: CGFloat = 192.0
    
    var interactorDelegate : APIManagerDelegate?
    let interactor = ConnectionManager()
    
    func config(){
        self.interactorDelegate = interactor
    }
    
    func PresentData(response: [Contents]) {
        
        contentes =  realm.objects(Contents.self).sorted(byKeyPath: "type", ascending: true)
       // print(contentes)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.reloadData()
        
    }
    
    func configureTableView() {
         view.addSubview(tableView)
         tableView.snp.makeConstraints { (make) in
              make.edges.equalTo(0)
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.config()
        self.interactorDelegate?.makeRequest()
        self.interactor.aDataPresentationLogic = self
    

        self.configureTableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 100.0
               
    }

    
    func addChildViewControllers() {
        
        detailsView.view.backgroundColor = .lightGray
        embedController?.append(viewController: detailsView)

        print("\nChildViewControllers added")
    }
    
}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.contentes!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let content = self.contentes![indexPath.row]
        
        cell.textLabel?.text = content.type
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        embedController = EmbedController(rootViewController: self)
        addChildViewControllers()
        detailsView.getdata(content: self.contentes![indexPath.row])
    }
    
    
}

