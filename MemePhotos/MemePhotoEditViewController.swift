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

        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"

        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.enabled = false
    }

    @IBAction func pickImageFromCameraRoll(sender: AnyObject) {
        self.presentViewController(cameraRollPicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(sender: AnyObject) {
        cameraPicker.sourceType = .Camera
        presentViewController(cameraPicker, animated: true, completion: nil)
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
    
}

