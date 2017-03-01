//
//  MemeListCollectionViewController.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/23/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCell"
private let memeDetailSegue = "showMemeDetails"

class MemeListCollectionViewController: UICollectionViewController {
    let memeList = MemeCollection.shared
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let totalPadding: CGFloat = 60

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MemeDetailViewController,
            let meme = sender as? Meme {
            destinationVC.meme = meme
        }
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeList.memeCollection.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MemeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memeList.memeCollection[indexPath.item]
        cell.memeImageview.image = meme.memedImage
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = dateFormatter.string(from: meme.createdOn)

        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memeList.memeCollection[indexPath.item]
        performSegue(withIdentifier: memeDetailSegue, sender: meme)
    }

    // MARK: - Device Rotation
    //Need the collectionview to retain it's layout after orientation change.
    //http://stackoverflow.com/questions/13181217/animating-uicollectionview-on-orientation-changes

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
}

extension MemeListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - totalPadding)/3, height: (UIScreen.main.bounds.width)/3)
    }
}
