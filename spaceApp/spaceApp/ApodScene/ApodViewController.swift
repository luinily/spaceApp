//
//  ApodViewController.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ApodViewControllerInput {
	func displayApod(viewModel: ApodViewModel)
}

protocol ApodViewControllerOutput {
	func fetchTodayApod(request: TodayApodRequest)
}

class ApodViewController: UIViewController, ApodViewControllerInput {
	var output: ApodViewControllerOutput!
	var router: ApodRouter!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var explanationTextView: UITextView!
	@IBOutlet weak var imageScrollView: UIScrollView!
	
	// MARK: Object lifecycle
	override func awakeFromNib() {
		super.awakeFromNib()
		ApodConfigurator.sharedInstance.configure(viewController: self)
	}
	
	// MARK: View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchTodaysApod()
		imageScrollView.delegate = self
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: Event handling
	
	func fetchTodaysApod() {
		// NOTE: Ask the Interactor to do some work
		
		let request = TodayApodRequest()
		output.fetchTodayApod(request: request)
	}
	
	// MARK: Display logic
	
	func displayApod(viewModel: ApodViewModel) {
		titleLabel.text = viewModel.title
		explanationTextView.text = viewModel.explanation
		if let picture = viewModel.picture {
			setPicture(picture: picture)
		}
	}
	
	private func setPicture(picture: UIImage) {
		setImageView(picture: picture)
		imageScrollView.contentSize = picture.size
		setZoomScales(picture: picture)
	}
	
	private func setZoomScales(picture: UIImage) {
		imageScrollView.minimumZoomScale = calculateMinimumZoomScale(picture: picture)
		imageScrollView.zoomScale = imageScrollView.minimumZoomScale
		updateImageViewFrame(scrollView: imageScrollView)
	}
	
	private func calculateMinimumZoomScale(picture: UIImage) -> CGFloat {
		let minWidthScale = imageScrollView.frame.width / picture.size.width
		let minHeightScale = imageScrollView.frame.height / picture.size.height
		
		return min(minWidthScale, minHeightScale)
	}
	
	private func setImageView(picture: UIImage) {
		if let imageView = getImageViewFromScrollView() {
			imageView.image = picture
		} else {
			let imageView = UIImageView(image: picture)
			imageView.restorationIdentifier = "imageView"
			imageScrollView.addSubview(imageView)
		}
	}
	
	func getImageViewFromScrollView() -> UIImageView? {
		//ScrollView contains 2 UIImageView for the scrolls, ours is the third one
		if imageScrollView.subviews.count == 3 {
			let views = imageScrollView.subviews.filter() {
					view in
					return view.restorationIdentifier == "imageView"
				}
			return views.first as? UIImageView
		}
		return nil
	}
}

extension ApodViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return getImageViewFromScrollView()
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		updateImageViewFrame(scrollView: scrollView)
	}
	
	private func updateImageViewFrame(scrollView: UIScrollView) {
		if let imageView = getImageViewFromScrollView() {
			let yOffset = max(0, (scrollView.frame.height - imageView.frame.height) / 2)
			let xOffset = max(0, (scrollView.frame.width - imageView.frame.width) / 2)
			imageView.frame = CGRect(x: xOffset, y: yOffset, width: imageView.frame.width, height: imageView.frame.height)
		}
	}
}

