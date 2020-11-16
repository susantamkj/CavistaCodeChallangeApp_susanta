//
//  DetailsViewController.swift
//  CavistaCodeChallangeApp
//
//  Created by Susanta Mukherjee on 13/11/2020.
//  Copyright © 2020 Susanta Mukherjee. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class DetailsViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    let containerViewHeight: CGFloat = 192.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        addButon()
    }
    
    
    private func addButon() {
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 20
        let frame = CGRect(x:0, y: 100, width: buttonWidth, height: buttonHeight)
        let button = UIButton(frame: frame)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
    
    @objc func buttonTapped() {
        
        self.view.removeFromSuperview()
    }
    

    func getdata(content: Contents){
        
        let subview = UIView();
        view.addSubview(subview)
        subview.backgroundColor = .white
            subview.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)

        }
        
        subview.addSubview(activityIndicator)
        activityIndicator.color = UIColor.orange

        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(subview)
            make.centerY.equalTo(subview).offset(-containerViewHeight/2 - 20)
            make.width.equalTo(40)
            make.height.equalTo(activityIndicator.snp.width)
        }
    
        print("valueIs......\(content)")
        
        if content.type!.isEqualToString(find: "image") {

            activityIndicator.startAnimating()
            self.loadImageWithView(imageURLStr: content.data!, withView: subview)
        }
        else if (content.type!.isEqualToString(find: "text") || content.type!.isEqualToString(find: "other") ){
            if content.data!.isValidURL{
                
                activityIndicator.startAnimating()
                self.loadImageWithView(imageURLStr: content.data!, withView: subview)
            }else{
                
                self.loadTextWithView(textData: content.data!, withView: subview)
            }
            
        }
    }

    
    func loadImageWithView(imageURLStr: String, withView aView:UIView){
        
        print("image......\(imageURLStr)")
        
        let imageView = UIImageView()
        
        aView.addSubview(imageView)
        
        imageView.backgroundColor = .clear
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(400)
            make.height.equalTo(600)
            make.centerX.equalTo(aView)
            make.centerY.equalTo(aView)
        }
                
        AF.request( imageURLStr,method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
                imageView.image = UIImage(data: responseData!, scale:1)
                self.activityIndicator.stopAnimating()

            case .failure(let error):
               // print("error--->",error)
                self.showAlert(withTitle: "CavistaCodeChallangeApp", withMessage: "Bad image URL")
                self.activityIndicator.stopAnimating()
            }
        }
                
    }
    
    func loadTextWithView(textData: String, withView aView:UIView){
        
        print("data......\(textData)")
        
        let aTextView = UITextView()
        aView.addSubview(aTextView)
        aTextView.backgroundColor = .clear
        aTextView.snp.makeConstraints { (make) in
            
            make.width.equalTo(400)
            make.height.equalTo(600)
            make.centerX.equalTo(aView)
            make.centerY.equalTo(aView)
        }
        
        aTextView.font = .systemFont(ofSize: 30)
        aTextView.text = textData
    }
    
    
}


extension String {
     func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            
            // it is a link, if the match covers the whole string
            
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
extension  UIViewController {

    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Thanks", style: .default, handler: { action in
            
            self.view.removeFromSuperview()
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}

