//
//  ViewController.swift
//  DroneSimulator
//
//  Created by KyungYoung Heo on 2018. 8. 14..
//  Copyright © 2018년 KyungYoung Heo. All rights reserved.
//

import UIKit
import Alamofire

class CustomCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,  UICollectionViewDataSourcePrefetching {
	
	let customCellIdentifier = "customCellIdentifier"
	var imageArr = [UIImage(named: "soohorang")!,UIImage(named: "Ironman")!,UIImage(named: "samsung")!,UIImage(named: "google_chrome_logo")!,UIImage(named: "logo-quantum")!,UIImage(named: "tomato")!,UIImage(named: "ssulogo")!]
//	lazy var imageFilename = ["양철지붕","최저임금","돌팔매","google_chrome_logo","logo-quantum","tomato","ssulogo"]
	lazy var imageId = [String]()
	
	lazy var customItems:Int = imageArr.count
	
	var longPressGesture: UILongPressGestureRecognizer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.prefetchDataSource = self
		
		//서버와 통신해서 imageArr에 텍스트 넣기
		
		DispatchQueue.global().async{
			defer{
				DispatchQueue.main.async {
					self.collectionView?.reloadData()
				}
			}
			do{
				self.parseJSON()
			}catch{
				print(error.localizedDescription)
			}
		}
		
		navigationItem.title = "DroneSimulator"
		createButton()
		
		collectionView?.backgroundColor = UIColor.white
		collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: customCellIdentifier)
		
//		collectionView?.contentInset.top = max(((collectionView?.frame.height)! - (collectionView?.contentSize.height)!) / 2, 0)
		collectionView?.contentInset.top = 50
		collectionView?.dragInteractionEnabled = true

		
		longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
		collectionView?.addGestureRecognizer(longPressGesture)
		
	}
	/*
	MARK: Implement UICollectionViewDataSourcePrefetching protocol
	*/
	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		//		print("prefetchForItemAt", imageFilename.count)
	}
	
	func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
		
	}
	
	func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		let dragItem = [UIDragItem]()
		return dragItem
		
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
//		print("cellForItemAt",indexPath.row, imageFilename.count)
		if(imageId.count == 0) {
			cell.nameLabel.text = nil
		}
		else {
			cell.nameLabel.text = self.imageId[indexPath.row]
		}
		return cell
	}
//	override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCell
//		cell.nameLabel.text = self.imageFilename[indexPath.row]
//	}
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
		return CGSize(width: 300, height: view.frame.height/2)
	}
	
	override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath{
		
		// Swap dragging items
		let tmpImage = imageArr[proposedIndexPath.row]
		imageArr[proposedIndexPath.row] = imageArr[originalIndexPath.row]
		imageArr[originalIndexPath.row] = tmpImage
		
		let tmpId = imageId[proposedIndexPath.row]
		imageId[proposedIndexPath.row] = imageId[originalIndexPath.row]
		imageId[originalIndexPath.row] = tmpId
		
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
	
	func parseJSON(){
		Alamofire.request("http://neinsys.io:5000/api/imageListForFiltering").responseJSON { response in
			print("Request: \(response.request)")
			print("Response: \(response.response)")
			print("Error: \(response.error)")
			
			if let json = response.result.value {
				//				print("JSON: \(json)")
				print("alamofire : \(self.imageId.count)")
				if let objarray = json as? [Any] {
					
					for array in objarray {
						if let object = array as? [String:Any]{
							if let id = object["_id"] as? String {
								print("\(id)\n")
								self.imageId.append(id)
								//						imageFilename.append(filename)
							}
						}
					}
				}
			}
		}
	}
	func createButton(){
		let submitBtn = UIButton()
		
		submitBtn.setTitle("Submit", for: .normal)
		submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
		submitBtn.tintColor = UIColor.black
		
		submitBtn.setTitleColor(UIColor.blue, for: .normal)
		
		self.view.addSubview(submitBtn)
		submitBtn.translatesAutoresizingMaskIntoConstraints = false
		
		submitBtn.centerXAnchor.constraint(equalTo:view.centerXAnchor)
			.isActive = true
		submitBtn.heightAnchor.constraint(equalToConstant: 50)
			.isActive = true
		submitBtn.widthAnchor.constraint(equalToConstant: 150)
			.isActive = true
		submitBtn.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant:300)
			.isActive = true
	}
	
	@objc func submit(sender: UIButton){
//		for element in imageFilename{
			print("Button pressed!")
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
	
	var imageView:UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	func setupViews(){
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
		customView.addSubview(imageView)
		customView.addSubview(nameLabel)
		backgroundColor = UIColor(displayP3Red: 0.99, green: 0.77, blue: 0.32, alpha: 1.0)
		
		
		addSubview(customView)
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-16-[v1]-8-[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":customView ,"v1":imageView,"v2":nameLabel]))
		
//		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
		
//		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-8-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView,"v1": nameLabel]))
		nameLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor)
	}
}
