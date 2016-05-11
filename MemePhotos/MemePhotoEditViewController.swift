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

    let cameraRollPicker = UIImagePickerController()
    let cameraPicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = UIImage(named: "blackBackground")
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cameraRollPicker.delegate = self
        cameraPicker.delegate = self

        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor .blackColor(),
            NSForegroundColorAttributeName : UIColor .whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickImageFromCameraRoll(sender: AnyObject) {
        self.presentViewController(cameraRollPicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(sender: AnyObject) {
        cameraPicker.sourceType = .Camera
        presentViewController(cameraPicker, animated: true, completion: nil)
    }

    @IBAction func presentActivityView(sender: AnyObject) {
        let activityItem: [AnyObject] = [memeImage.image as! AnyObject]
        let shareController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
        shareController
        self.presentViewController(shareController, animated: true, completion: nil)
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
        textField.text = ""
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
    }

    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }

    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

}

