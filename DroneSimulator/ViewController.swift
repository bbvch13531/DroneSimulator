//
//  ViewController.swift
//  DroneSimulator
//
//  Created by KyungYoung Heo on 2018. 8. 14..
//  Copyright © 2018년 KyungYoung Heo. All rights reserved.
//

import UIKit
import Alamofire

class CustomCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
	func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
		
	}
	
	func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		let dragItem = [UIDragItem]()
		return dragItem
		
	}
	
	let customCellIdentifier = "customCellIdentifier"
	var imageArr = [UIImage(named: "양철지붕")!,UIImage(named: "최저임금")!,UIImage(named: "돌팔매")!,UIImage(named: "google_chrome_logo")!,UIImage(named: "logo-quantum")!,UIImage(named: "tomato")!,UIImage(named: "ssulogo")!]
	
	
//	var imageArr = [UILabel()]
	
	
	lazy var customItems:Int = imageArr.count
	
	var longPressGesture: UILongPressGestureRecognizer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = UIColor.white
		collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: customCellIdentifier)
		
		collectionView?.contentInset.top = max(((collectionView?.frame.height)! - (collectionView?.contentSize.height)!) / 2, 0)
		
		collectionView?.dragInteractionEnabled = true
		
//		self.collectionView?.dragDelegate = self
//		collectionView?.dropDelegate = self
		
		longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
		collectionView?.addGestureRecognizer(longPressGesture)
		
		//서버와 통신해서 imageArr에 텍스트 넣기
		
		Alamofire.request("http://neinsys.io:5000/api/imageListForFiltering").response { response in
			print("Request: \(response.request)")
			print("Response: \(response.response)")
			print("Error: \(response.error)")
			
			if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
				print("Data: \(utf8Text)")
			}
		}
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
		cell.nameLabel.text = "Custom Text"
		return cell
	}
	/*
	Enable the use of moving items in UICollectionView
	*/
	override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		print("start : \(sourceIndexPath.item), end : \(destinationIndexPath.item)")

	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 300, height: view.frame.height)
	}
	
	override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath{
		
		let tmp = imageArr[proposedIndexPath.row]
//		get(proposedIndexPath)
		
		imageArr[proposedIndexPath.row] = imageArr[originalIndexPath.row]
		imageArr[originalIndexPath.row] = tmp
		
		return proposedIndexPath
	}
	
	@objc func handleLongGesture(gesture: UILongPressGestureRecognizer){
		switch gesture.state {
		case .began:
			guard let selectedIndexPath = collectionView?.indexPathForItem(at: gesture.location(in: collectionView))
				else {
					break
			}
			collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
		case .changed:
			collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
		case .ended:
			collectionView?.endInteractiveMovement()
		default:
			collectionView?.cancelInteractiveMovement()
		}
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
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var imageView:UIImageView = UIImageView()
	
	func setupViews(){
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
		customView.addSubview(imageView)
		customView.addSubview(nameLabel)
		backgroundColor = UIColor(displayP3Red: 0.99, green: 0.77, blue: 0.32, alpha: 1.0)
		addSubview(customView)
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
		
	}
}
