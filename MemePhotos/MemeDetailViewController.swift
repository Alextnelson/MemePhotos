//
//  MemeDetailViewController.swift
//  MemePhotos
//
//  Created by Alexander Nelson on 5/29/16.
//  Copyright © 2016 Alexander Nelson. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!

    @IBOutlet weak var memeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memedImage
        
    }
}
