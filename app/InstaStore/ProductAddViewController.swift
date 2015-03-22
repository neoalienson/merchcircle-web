//
//  ProductViewController.swift
//  InstaStore
//
//  Created by Neo on 3/21/15.
//  Copyright (c) 2015 instastore. All rights reserved.
//


import UIKit

class ProductAddViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    var imagePicker: UIImagePickerController!
    var image: UIImage!
    var masterView: AccountViewController!
    var id: String!
        
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var actvityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var textFieldPrice: UITextField!
    @IBOutlet weak var textFieldCreditCard: UITextField!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var buttonGo : UIButton!
    
    let urlPost = "http://instastore.herokuapp.com/product"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let parent = self.parentViewController
        
        imageProduct.image = image
        
        scrollView.contentSize = CGSizeMake(414, 736*1.4)
        buttonGo.layer.cornerRadius = buttonGo.frame.height / 10
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        scrollView.scrollRectToVisible(CGRectMake(0, 736*1.4, 10, 10), animated: true)
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textField == textFieldCreditCard) {
            scrollView.scrollRectToVisible(CGRectMake(0, 736*1.4, 10, 10), animated: true)
        } else if (textField == textFieldPrice) {
            scrollView.scrollRectToVisible(CGRectMake(0, 736*1.2, 10, 10), animated: true)
        } else {
            // textFieldName
            scrollView.scrollRectToVisible(CGRectMake(0, imageProduct.bounds.origin.y,
                10, textFieldPrice.bounds.origin.y + textFieldPrice.bounds.size.height
                    - imageProduct.bounds.origin.y ), animated: true)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func buttonCamera(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func buttonSubmit(sender: AnyObject) {
        let creditcard = textFieldCreditCard.text.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())


// .stringByReplacingOccurrencesOfString("-", withString: "", options: .allZeros, range: NSMakeRange(0, ))
        
        actvityIndicator.startAnimating()
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let price = numberFormatter.numberFromString(textFieldPrice.text)
        if (price?.integerValue < 10) {
            showAlert("Input error", message: "Price should not be less than 10")
            return
        }
        
        let imagePng = UIImagePNGRepresentation(image)
        let imageString = imagePng.base64EncodedStringWithOptions(.allZeros)
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        self.id = formatter.stringFromDate(now)
        println(self.id)
        
        let json = String(format: "{\"id\": \"%@\",\"name\": \"%@\",\"description\": \"%@\",\"price\": %@,\"image\": \"%@\", \"creditCard\" : \"%@\"}",
            self.id, textFieldName.text, textViewDescription.text, price!, imageString, creditcard)
        
        post("http://instastore.herokuapp.com/product", json: json)
        
        masterView.products.insertObject([ textFieldName.text, String(format:"$%@ HKD", price!), "March 22, 2015", false], atIndex: 0)
        masterView.refresh()
    }
    
    func maskCreditcard(no: String) -> String {
        let idx : String.Index = advance(no.endIndex, -4)
        let substring = no.substringFromIndex(idx)
        return String(format: "**** - **** - **** - %@", substring)
        
    }
    
    func post(url : String, json : NSString) {
        let _url = NSURL(string: url)
        var request = NSMutableURLRequest(URL: _url!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            let httpResponse = response as NSHTTPURLResponse
            if (httpResponse.statusCode == 200) {
                dispatch_sync(dispatch_get_main_queue())
                {
                    self.dismissViewControllerAnimated(false, completion: {()-> Void in
                        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductViewController") as ProductViewController

                        viewController.id = self.id
                        viewController.image = self.imageProduct.image
                        viewController.price = self.textFieldPrice.text
                        viewController.name = self.textFieldName.text
                        viewController.desc = self.textViewDescription.text

                        let maskedCreditcard = self.maskCreditcard(self.textFieldCreditCard.text)
                        viewController.maskedCreditcard = maskedCreditcard as String
                        
                        self.masterView?.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            } else {
                self.actvityIndicator.stopAnimating()

                self.showAlert("Server error", message: "Something went wrong. Please retry")
            }
        })
        
        task.resume()
    }

    func showAlert(title: String, message : String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)

        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func buttonCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        // load and resized image
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        let resizeRate:CGFloat = 10.0
        
        let newSize = CGSizeMake(image.size.width / resizeRate, image.size.height / resizeRate);
        image.resize(newSize, completionHandler: { [weak self](resizedImage, data) -> () in
            let image = resizedImage
            
            self?.imageProduct.image = image
        })
    }
    
    func imagePickerControllerDidCancel( picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
}

