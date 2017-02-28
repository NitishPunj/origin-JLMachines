//
//  JLGridViewController.swift
//  JohnLewisMachines
//
//  Created by TAE on 23/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import ARSLineProgress

class JLGridViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var gridView: UICollectionView!
    
    var machines: [Machine] = []
    let productImageCache = AutoPurgingImageCache()
    var valueToPass:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.navigationBar.topItem?.title = "Dishwashers(20)"
        // Do any additional setup after loading the view.
        
        //Calling the WebAPIConnection to fetch machines on completion  we will reload the grid/collectionview
        //Show the progress bar
        ARSLineProgress.show()
        
        ConnectionFile.sharedInstance.fetchAllMachines(){machines in
            self.machines = machines
            
            self.gridView.reloadData()
            ARSLineProgress.hide()
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let vc = segue.destination as! JLProductDetailsViewController
        vc.value = valueToPass
    
    
    }
    
    //CollectionView delegate methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return machines.count
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as!JLGridViewCell

       cell.descriptionLabel.text = machines[indexPath.row].title
        cell.priceLabel.text = machines[indexPath.row].price
        
        let productImage = productImageCache.image(withIdentifier: "productImage" + String(indexPath.row))
        if productImage == nil {
            
            
           
            // Move to a background thread to do some long running work
            DispatchQueue.global().async {
                
                
                Alamofire.request(self.machines[indexPath.row].imageURL, method: .get)
                    .response { response  in
                        if let error = response.error{
                            print(error)
                            return
                        }else{
                            // Bounce back to the main thread to update the UI
                            DispatchQueue.main.async {
                                
                                let image:UIImage = UIImage(data: response.data!, scale:1)!
                                
                                
                                cell.imageView.image = image
                                self.productImageCache.add(image, withIdentifier: "productImage" + String(indexPath.row))
                                
                            }
                        }
                }
            }
        }else{
            
            cell.imageView.image = productImage
           
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        
        valueToPass = machines[indexPath.row].id
        performSegue(withIdentifier: "detailSegue", sender: self)
       
    }
    
       
    
    
}
