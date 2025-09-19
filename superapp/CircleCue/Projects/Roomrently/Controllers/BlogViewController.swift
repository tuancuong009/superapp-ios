//
//  BlogViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 16/08/2023.
//

import UIKit

class BlogViewController: BaseRRViewController {

    @IBOutlet weak var cltBlog: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cltBlog.register(UINib.init(nibName: "BlogCollectionViewListCell", bundle: nil), forCellWithReuseIdentifier: "BlogCollectionViewListCell")
        // Do any additional setup after loading the view.
    }
}
extension BlogViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = cltBlog.dequeueReusableCell(withReuseIdentifier: "BlogCollectionViewListCell", for: indexPath) as! BlogCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: cltBlog.frame.size.width, height: 220)
    }
}
