//
//  SentMemesTableViewController.swift
//  MemePhotos
//
//  Created by Alexander Nelson on 5/29/16.
//  Copyright © 2016 Alexander Nelson. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")! as UITableViewCell
        let meme = memes[indexPath.row]

        cell.textLabel!.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController

        detailVC.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @IBAction func addMeme(sender: AnyObject) {
        self.performSegueWithIdentifier("presentAddMemeModally", sender: self)
    }
}




