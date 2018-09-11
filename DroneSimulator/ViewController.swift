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
	let submitBtn = UIButton()
	let pathNameField = UITextField()
	let customCellIdentifier = "customCellIdentifier"
	//	var imageArr = [UIImage(named: "pentagon_drone")!,UIImage(named: "drone_drone")!,UIImage(named: "soohorang_drone")!,UIImage(named: "snowboard_drone")!,UIImage(named: "bird_drone")!,UIImage(named: "Ironman")!,UIImage(named: "samsung")!,UIImage(named: "square_chrome_logo")!,UIImage(named: "logo-quantum")!,UIImage(named: "ssulogo")!]
	//	lazy var imageFilename = ["Pentagon_drone","drone","Soohorang_drone","Snowboard_drone","Bird_drone","Samsung","IronMan","google_chrome_logo","firefox_logo","SSU_logo"]
	//	lazy var imageId = [String]()
	
	var imageArr = [UIImage(named:"samsung")!,UIImage(named:"soohorang_drone")!,UIImage(named:"logo-quantum")!,UIImage(named:"Ironman")!,UIImage(named:"square_chrome_logo")!,UIImage(named:"logo-quantum")!,UIImage(named:"Ironman")!,UIImage(named:"square_chrome_logo")!,UIImage(named:"Ironman")!,UIImage(named:"square_chrome_logo")!]
	
	lazy var imageFilename = [String]()
	//		= ["Samsung","Soohorang_drone","Firefox","Ironman","Chrome"]
	var imageId = [String]()
	lazy var customItems:Int = 10
	//		imageArr.count
	
	var longPressGesture: UILongPressGestureRecognizer!
	var swipeGesture: UISwipeGestureRecognizer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//		self.collectionView?.reloadData()
		collectionView?.prefetchDataSource = self
		print("imageId.count = \(imageId.count), imageFilename.count = \(imageFilename.count)")
		//서버와 통신해서 imageArr에 텍스트 넣기
		
		DispatchQueue.global().async{
			defer{
				DispatchQueue.main.async {
					self.collectionView?.reloadData()
				}
			}
			do{
				self.parseJSON()
			}
		}
		
		navigationItem.title = "Multi Drone Path Planning"
		createButton()
		
		collectionView?.backgroundColor = UIColor.white
		collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: customCellIdentifier)
		
		//		collectionView?.contentInset.top = max(((collectionView?.frame.height)! - (collectionView?.contentSize.height)!) / 2, 0)
		collectionView?.contentInset.top = -50
		collectionView?.dragInteractionEnabled = true
		
		longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
		collectionView?.addGestureRecognizer(longPressGesture)
		
		swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipe(sender:)))
		swipeGesture.direction = UISwipeGestureRecognizerDirection.up
		collectionView?.addGestureRecognizer(swipeGesture)
		
		
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
		
		if(imageId.count == 0) {
			cell.nameLabel.text = nil
		}
		else {
			//			cell.nameLabel.text = self.imageId[indexPath.row]
			cell.nameLabel.text = self.imageFilename[indexPath.row]
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
		// TODO: Using swap methods
		let tmpImage = imageArr[proposedIndexPath.row]
		imageArr[proposedIndexPath.row] = imageArr[originalIndexPath.row]
		imageArr[originalIndexPath.row] = tmpImage
		
		let tmpId = imageId[proposedIndexPath.row]
		imageId[proposedIndexPath.row] = imageId[originalIndexPath.row]
		imageId[originalIndexPath.row] = tmpId
		
		let tmpName = imageFilename[proposedIndexPath.row]
		imageFilename[proposedIndexPath.row] = imageFilename[originalIndexPath.row]
		imageFilename[originalIndexPath.row] = tmpName
		
		return proposedIndexPath
	}
	
	// swipe Gesture
	@objc func onSwipe(sender:UISwipeGestureRecognizer){
		
		let indexPath = collectionView?.indexPathForItem(at: sender.location(in: collectionView))
		let cell = collectionView?.cellForItem(at: indexPath!)
		let itemIndex = self.collectionView!.indexPath(for: cell!)!.item
		
		var customCell = cell as! CustomCell
		
		if sender.state == UIGestureRecognizerState.ended {
			
			self.view.layoutIfNeeded()
			UIView.animate(withDuration: 0.2, animations: {(
				customCell.center = CGPoint(x:(customCell.center.x),y:(customCell.center.y)-600)
				)}
				,completion: {(finished:Bool) in
					self.imageId.remove(at: itemIndex)
					self.imageFilename.remove(at: itemIndex)
					self.imageArr.remove(at: itemIndex)
					
					self.customItems -= 1
					self.collectionView!.reloadData()
			})			
			
		}
		//		Thread.sleep(forTimeInterval: 0.3)
		
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
								
							}
							if let filename = object["filename"] as? String {
								self.imageFilename.append(filename)
							}
						}
					}
				}
			}
		}
	}
	func createButton(){
		//		let submitBtn = UIButton()
		//		let pathNameField = UITextField()
		
		submitBtn.setTitle("Submit", for: .normal)
		submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
		submitBtn.tintColor = UIColor.black
		
		
		submitBtn.setTitleColor(UIView().tintColor, for: .normal)
		submitBtn.layer.cornerRadius = 10
		submitBtn.layer.borderWidth = 1
		
		submitBtn.layer.borderColor = UIView().tintColor.cgColor
		
		pathNameField.font = UIFont.systemFont(ofSize: 15)
		pathNameField.borderStyle = UITextBorderStyle.roundedRect
		pathNameField.placeholder = "Please input your path name"
		pathNameField.textAlignment = .center
		
		self.view.addSubview(submitBtn)
		self.view.addSubview(pathNameField)
		
		submitBtn.translatesAutoresizingMaskIntoConstraints = false
		pathNameField.translatesAutoresizingMaskIntoConstraints = false
		
		submitBtn.centerXAnchor.constraint(equalTo:view.centerXAnchor)
			.isActive = true
		submitBtn.heightAnchor.constraint(equalToConstant: 50)
			.isActive = true
		submitBtn.widthAnchor.constraint(equalToConstant: 150)
			.isActive = true
		submitBtn.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant:350)
			.isActive = true
		
		pathNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		pathNameField.heightAnchor.constraint(equalToConstant: 50)
			.isActive = true
		pathNameField.widthAnchor.constraint(equalToConstant: 400)
			.isActive = true
		pathNameField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:250).isActive = true
	}
	
	@objc func submit(sender: UIButton){
		let pathName = self.pathNameField.text!
		
		let params: Parameters = [
			"rest" : 0,
			"optimization" : 0,
			"name" : pathName,
			"algorithm" : "DinicAndMCMF",
			"image": imageId
		]
		
		let encoding = URLEncoding(arrayEncoding: .noBrackets)
		Alamofire.request("http://neinsys.io:5000/findPath", method: .post, parameters: params, encoding:encoding)
			.validate(contentType: ["multipart/form-data"])
			.response { response in
				//			debugPrint(response)
				print("\(response)")
				
		}
		//		debugPrint(request)
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
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var imageView:UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	func setupViews(){
		imageView = UIImageView(frame: CGRect(x: 25, y: 0, width: 250, height: 250))
		customView.addSubview(imageView)
		customView.addSubview(nameLabel)
		
		// Set backgroundColor
		backgroundColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0)
		
		addSubview(customView)
		
		self.layer.cornerRadius = 15
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-16-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView,"v1":nameLabel]))
		
		imageView.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
		nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
	}
}
