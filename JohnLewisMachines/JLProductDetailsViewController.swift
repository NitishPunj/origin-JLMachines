//
//  JLProductDetailsViewController.swift
//  JohnLewisMachines
//
//  Created by TAE on 24/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//


extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil) else { return nil }
        return html
    }
}

import UIKit
import SwiftyJSON
import Alamofire
import ARSLineProgress
class JLProductDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   public var value:String!
    
   
    var imgArray:[String] = []
    var json:JSON!
    var attributesArray:[JSON] = []

    @IBOutlet weak var imgCollcetionView: UICollectionView!
    @IBOutlet weak var detailsTable: UITableView!
    
  public  func parseAndLoad(){
        let skus = json["skus"].array!
        for img in skus[0]["media"]["images"]["urls"].array!{
            imgArray.append("https:" + img.string!)
        }
    
    
        self.imgCollcetionView.reloadData()
        
         self.detailsTable.reloadData()
    
    imgCollcetionView.alpha = 1
    detailsTable.alpha = 1
    ARSLineProgress.hide()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgCollcetionView.alpha = 0
        detailsTable.alpha = 0
        

        ARSLineProgress.show()
        ConnectionFile.sharedInstance.fetchProductInfo(productID: value){response in
            self.json = JSON(response!)
            
            self.navigationController?.navigationBar.topItem?.title =  self.json["title"].string!
           
    
            self.parseAndLoad()
            
        }
  
        // Do any additional setup after loading the view.
    }
    
    //Orientation change for collcetionview
    override func viewWillLayoutSubviews() {
        
        
        super.viewWillLayoutSubviews()
        
        imgCollcetionView.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Collcetion View Delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return imgArray.count
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PagerCell", for: indexPath) as!JLDetailPageViewCell
        
        Alamofire.request(self.imgArray[indexPath.row], method: .get)
            .response { response  in
                if let error = response.error{
                    print(error)
                    return
                }else{
                    DispatchQueue.main.async {
                        let image:UIImage = UIImage(data: response.data!, scale:1)!
                        cell.imageView.image = image                         
                    }
                }
        }
     
        return cell
        
    }
    
    
  
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 350)
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if json != nil
        {
       var featuresArray = json["details"]["features"].array!
        attributesArray = featuresArray[0]["attributes"].array!
            return 2 + attributesArray.count
        }
     
        return 0
        
    }
    
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if(indexPath.row == 0){
          
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as!JLInfoTableViewCell
        cell.priceLabel.text? = "£" + json["price"]["now"].string!
        cell.redlabel.text? = json["displaySpecialOffer"].string!
        let arr = json["additionalServices"]["includedServices"].array!
        
        cell.greenLabel.text? = arr[0].string!
        
        //for css tags
        let str = json["details"]["productInformation"].string!
        
        cell.infoLabel.attributedText = str.htmlAttributedString()
        cell.codeLabel.text? = "Product Code:" + json["code"].string!
        
        
        return cell
        
    }
    
    if(indexPath.row == 1){
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
        
       
        return cell
        
    }
        
    else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as!JLFeatureTableViewCell
        
        
            cell.featureLabel.text? = attributesArray[indexPath.row - 2]["name"].string!
        cell.valueLabel.text? =  attributesArray[indexPath.row - 2]["value"].string!
       
        return cell

    }
    
    }
      
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if (indexPath.row == 0){
             return UITableViewAutomaticDimension//return 300
        }
        else if  (indexPath.row == 1)
        {
            return 75
        }
        
        else
        {
            return 60
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

    
    
    
    
    
    
    
    

}
