//
//  ViewController.swift
//  DroneSimulator
//
//  Created by KyungYoung Heo on 2018. 8. 14..
//  Copyright © 2018년 KyungYoung Heo. All rights reserved.
//

import UIKit


class CustomCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let customCellIdentifier = "customCellIdentifier"
	let imageArr = [UIImage(named: "양철지붕")!,UIImage(named: "최저임금")!,UIImage(named: "돌팔매")!,UIImage(named: "google_chrome_logo")!,UIImage(named: "logo-quantum")!,UIImage(named: "tomato")!,UIImage(named: "ssulogo")!]
	lazy var customItems:Int = imageArr.count
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = UIColor.white
		collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: customCellIdentifier)
		
		collectionView?.contentInset.top = max(((collectionView?.frame.height)! - (collectionView?.contentSize.height)!) / 2, 0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
		return customItems
	}
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCell
		
		let image: UIImage = imageArr[indexPath.row]
		
		cell.imageView.image = image

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 300, height: view.frame.height)
	}
	
	
}

class CustomCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemnted")
	}
	let customView:UIView = UIView(frame: CGRect(x: 0, y: 50, width: 300, height: 300))
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Custom Text"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var imageView:UIImageView = UIImageView()
	
	func setupViews(){
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
		customView.addSubview(imageView)
		backgroundColor = UIColor(displayP3Red: 0.99, green: 0.77, blue: 0.32, alpha: 1.0)
		addSubview(customView)
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
		
	}
}
