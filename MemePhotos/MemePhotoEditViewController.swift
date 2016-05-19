//
//  MemePhotoEditViewController.swift
//  MemePhotos
//
//  Created by Alexander Nelson on 5/9/16.
//  Copyright © 2016 Alexander Nelson. All rights reserved.
//

import UIKit


class MemePhotoEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var selectMemeImageSourceToolBar: UIToolbar!

    let cameraRollPicker = UIImagePickerController()
    let cameraPicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = UIImage(named: "blackBackground")
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cameraRollPicker.delegate = self
        cameraPicker.delegate = self
        formatTextFields(topTextField!, bottomTextField: bottomTextField!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func formatTextFields(topTextField: UITextField, bottomTextField: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor .blackColor(),
            NSForegroundColorAttributeName : UIColor .whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        topTextField.text = "ENTER YOUR MEME"
        bottomTextField.text = "HERE"
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        if memeImage.image == UIImage(named: "blackBackground") {
            navigationItem.leftBarButtonItem?.enabled = false
            navigationItem.rightBarButtonItem?.enabled = false
        } else {
            navigationItem.leftBarButtonItem?.enabled = true
            navigationItem.rightBarButtonItem?.enabled = true
        }

    }

    @IBAction func pickImageFromCameraRoll(sender: AnyObject) {
        self.presentViewController(cameraRollPicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(sender: AnyObject) {
        cameraPicker.sourceType = .Camera
        presentViewController(cameraPicker, animated: true, completion: nil)
    }

    @IBAction func presentActivityView(sender: AnyObject) {
        let memedImageToShare = generateMemedImage()
        let activityItem = memedImageToShare
        let shareController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
        self.presentViewController(shareController, animated: true, completion: nil)
        
        shareController.completionWithItemsHandler = {
            (activityItem, completed, returnedItems, activityError) in
            if completed {
                self.savedMeme(memedImageToShare)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

    @IBAction func resetAll(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        memeImage.image = UIImage(named: "blackBackground")
        formatTextFields(topTextField!, bottomTextField: bottomTextField!)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.contentMode = .ScaleAspectFit
            memeImage.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
        navigationItem.leftBarButtonItem?.enabled = true
        navigationItem.rightBarButtonItem?.enabled = true
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "ENTER YOUR MEME" || textField.text == "HERE" {
            textField.text = ""
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemePhotoEditViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemePhotoEditViewController.keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification) * 1
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.resignFirstResponder() {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    func generateMemedImage() -> UIImage {
        self.navigationController!.navigationBar.hidden = true
        navigationController?.setToolbarHidden(true, animated: false)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController!.navigationBar.hidden = true
        selectMemeImageSourceToolBar.hidden = true

        return memedImage
    }

    func savedMeme(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: memeImage.image!, memedImage: memedImage)
        print("Meme: \(meme)")
    }
}

