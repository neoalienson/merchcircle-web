//
//  ProductViewController.swift
//  InstaStore
//
//  Created by Neo on 3/21/15.
//  Copyright (c) 2015 instastore. All rights reserved.
//

import UIKit
import Social

class ProductViewController: UIViewController, UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var actvityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelPrice : UILabel!
    @IBOutlet weak var labelName : UILabel!
    @IBOutlet weak var labelMaskedCreditcard : UILabel!
    @IBOutlet weak var buttonShare : UIButton!
    @IBOutlet weak var buttonClose : UIButton!

    var id : String!
    var image : UIImage!
    var name : String!
    var desc : String!
    var price : String!
    var masterView: AccountViewController!
    var maskedCreditcard : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        labelDescription.text = desc
        labelName.text = name
        labelPrice.text = String(format:"$%@ HKD", price)
        if (maskedCreditcard != nil) {
            labelMaskedCreditcard.text = maskedCreditcard
        }
        buttonShare.layer.cornerRadius = buttonShare.frame.height / 10
        buttonClose.layer.cornerRadius = buttonClose.frame.height / 10
    }
    
    @IBAction func buttonClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func buttonShare(sender: AnyObject) {
        let productUrl = String(format: "http://instastore.herokuapp.com/product/%@", self.id)
        
        let message = String(format: "I'm selling %@, buy it @merchcircle, %@", self.name, productUrl)
        
        let sheet: UIAlertController = UIAlertController(title: "Share your product", message: "", preferredStyle: .ActionSheet)
        
        // copy to clipboard
        let clipboardAction = UIAlertAction(title: "Copy to clipboard", style: .Default, handler: {(alert: UIAlertAction!) in
            UIPasteboard.generalPasteboard().string = productUrl
        })
        sheet.addAction(clipboardAction)
        
        // twitter
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterAction = UIAlertAction(title: "Twitter", style: .Default, handler: {(alert: UIAlertAction!) in
                var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                tweetSheet.setInitialText(message)
                tweetSheet.addImage(self.image)
                self.presentViewController(tweetSheet, animated: true, completion: nil)
            })
            
            sheet.addAction(twitterAction)
        }
        
        // facebook
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: {(alert: UIAlertAction!) in
                var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookSheet.setInitialText(message)
                self.presentViewController(facebookSheet, animated: true, completion: nil)
            })

            sheet.addAction(facebookAction)
        }
        
        // cancel
        sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(sheet, animated: true, completion: nil)
        
    }

}