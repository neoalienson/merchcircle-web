//
//  AccountViewController.swift
//  InstaStore
//
//  Created by Neo on 3/21/15.
//  Copyright (c) 2015 instastore. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate
{
    var imagePicker: UIImagePickerController!
    var products = NSMutableArray(array: [
        [ "Mastercard hygiene kit", "$30 HKD", "March 22, 2015", false],
        [ "Horse Mask", "$155 HKD", "March 22, 2015", true],
        [ "2 T. Swift Tickets", "$2,000 HKD", "March 19, 2015", false],
        [ "HP printer", "$50 HKD", "Feb 26, 2015", true],
        [ "Tiffany bracelet", "$1,060 HKD", "January 20, 2015", false],
    ]
    )
    @IBOutlet var imageViewPhoto : UIImageView!
    @IBOutlet var buttonSell : UIButton!
    @IBOutlet var tableViewProducts : UITableView!
    var imageTemp : UIImage!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewPhoto.layer.cornerRadius = imageViewPhoto.frame.size.height / 2
        imageViewPhoto.clipsToBounds = true
        
        buttonSell.layer.cornerRadius = buttonSell.frame.size.height / 10
        buttonSell.clipsToBounds = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("productCell") as UITableViewCell
        
        println(indexPath.item)
        let view = cell.contentView.subviews[2] as UIView
        view.layer.cornerRadius = view.frame.size.height / 2

        let labelName = cell.contentView.subviews[3] as UILabel
        labelName.text = products[indexPath.item][0] as String

        let labelPrice = cell.contentView.subviews[0] as UILabel
        labelPrice.text = products[indexPath.item][1] as String

        let labelDate = cell.contentView.subviews[1] as UILabel
        labelDate.text = products[indexPath.item][2] as String

        return cell
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonStart(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        // load and resized image
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        let resizeRate:CGFloat = 5.0
        let newSize = CGSizeMake(image.size.width / resizeRate, image.size.height / resizeRate)
        image.resize(newSize, completionHandler: { [weak self](resizedImage, data) -> () in
            let image = resizedImage
            self?.imageTemp = image
            // move to another view after resize
            self?.showProductView()
        })
    }
    
    func showProductView() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductAddViewController") as ProductAddViewController

        viewController.image = imageTemp
        viewController.masterView = self
        
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refresh() {
        self.tableViewProducts.reloadData()
    }
}

