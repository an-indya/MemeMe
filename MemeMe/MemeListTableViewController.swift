//
//  MemeListTableViewController.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/23/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class MemeListTableViewController: UITableViewController {

    let memeList = MemeCollection.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeList.memeCollection.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MemeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! MemeTableViewCell
        let meme = memeList.memeCollection[indexPath.row]
        cell.memeImage.image = meme.memedImage
        cell.topText.text = "\(meme.topText)...\(meme.bottomText)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = dateFormatter.string(from: meme.createdOn)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memeList.memeCollection.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memeList.memeCollection[indexPath.row]
        performSegue(withIdentifier: StoryboardIds.showMemeDetails.rawValue, sender: meme)
    }

    // MARK: - Navigation


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardIds.showMemeEditor.rawValue {
            if  let navController = segue.destination as? UINavigationController,
                let destinationVC = navController.viewControllers.first as? MemeViewController {
                destinationVC.delegate = self
            }
        } else {
            if let destinationVC = segue.destination as? MemeDetailViewController,
                let meme = sender as? Meme {
                destinationVC.meme = meme
            }
        }
    }
}

extension MemeListTableViewController: MemeEditorDelegate {
    func didFinishEditingMeme() {
        tableView.reloadData()
    }
}
