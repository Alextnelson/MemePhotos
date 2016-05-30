//
//  SentMemesCollectionViewController.swift
//  MemePhotos
//
//  Created by Alexander Nelson on 5/29/16.
//  Copyright © 2016 Alexander Nelson. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.memeImage.image = meme.memedImage
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController

        detailVC.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @IBAction func addMeme(sender: AnyObject) {
        self.performSegueWithIdentifier("presentAddMemeModally", sender: self)
    }

}


