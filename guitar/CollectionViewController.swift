//
//  CollectionViewController.swift
//  guitar
//
//  Created by lazycal on 2017/5/25.
//  Copyright © 2017年 lazycal. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MyTestCollectionViewCell"

class CollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate{
    // MARK: Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
        //var
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isMultipleTouchEnabled = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout //UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (screenWidth)/6, height: screenHeight/4)
        // 设置CollectionView
//        collectionView = UICollectionView(frame: CGRect(x:0, y:0, width:screenWidth, height:screenHeight), collectionViewLayout: layout)
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView!.backgroundColor = UIColor.white
        self.collectionView!.register(MyTestCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        print("cell_couont=",collectionView?.visibleCells.count)
        // Do any additional setup after loading the view.
        let tap = UIPanGestureRecognizer(target: self, action: #selector(CollectionViewController.handleTap(_:)))
        tap.delegate = self
        collectionView!.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Gesture
    func handleTap(_ gestureRecognizer : UIPanGestureRecognizer) {
        print("handleTap")
        for i in 0..<gestureRecognizer.numberOfTouches {
            let loc = gestureRecognizer.location(ofTouch: i, in: collectionView!)
            print(loc)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let colors = [UIColor.red, UIColor.green, UIColor.blue]
        cell.backgroundColor = colors[indexPath.row % 3]
        print(indexPath)

        // Configure the cell
    
        return cell
    }
//    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        print("didHighlightItemAt",indexPath)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        cell.backgroundColor = .white
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        print("didUnHighlightItemAt",indexPath)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        let colors = [UIColor.red, UIColor.green, UIColor.blue]
//        cell.backgroundColor = colors[indexPath.row % 3]
//    }
//    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
