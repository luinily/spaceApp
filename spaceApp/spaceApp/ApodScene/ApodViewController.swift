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
	func displayApod(viewModel: ApodDataViewModel)
	func displayImage(viewModel: ApodImageViewModel)
	func displayApodError(viewModel: ApodErrorViewModel)
	func displayProgress(viewModel: ApodPictureDownloadProgressViewModel)
}

protocol ApodViewControllerOutput {
	func fetchTodayApod(request: TodayApodRequest)
	func fetchRandomApod(request: RandomApodRequest)
}

class ApodViewController: UIViewController {
	var output: ApodViewControllerOutput!
	var router: ApodRouter!
	var refreshControl: UIRefreshControl!

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var explanationTextView: UITextView!
	@IBOutlet weak var imageScrollView: UIScrollView!
	@IBOutlet weak var refreshScrollView: UIScrollView!
	@IBOutlet weak var progressView: UIProgressView!



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
		setupRefreshControl()
		setupProgressView()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	// MARK: Event handling

	func fetchTodaysApod() {
		// NOTE: Ask the Interactor to do some work

		let request = TodayApodRequest()
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		output.fetchTodayApod(request: request)
	}

	func onRefreshPull() {
		output.fetchRandomApod(request: RandomApodRequest())
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}

	// MARK: Display logic
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshScrollView.refreshControl = refreshControl
		refreshControl.addTarget(self, action: #selector(ApodViewController.onRefreshPull), for: .valueChanged)
	}

	private func setupProgressView() {
		progressView.isHidden = true
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

extension ApodViewController: ApodViewControllerInput {
	func displayApod(viewModel: ApodDataViewModel) {
		titleLabel.text = viewModel.title
		explanationTextView.text = viewModel.explanation
		removeImageView()
		startProgressView()
		if refreshControl.isRefreshing {
			refreshControl.endRefreshing()
		}
	}

	private func startProgressView() {
		progressView.progress = 0
		progressView.isHidden = false
	}

	private func removeImageView() {
		let subview = getImageViewFromScrollView()
		subview?.removeFromSuperview()
	}

	func displayImage(viewModel: ApodImageViewModel) {
		if let picture = viewModel.picture {
			setPicture(picture: picture)
		}
		progressView.isHidden = true
		UIApplication.shared.isNetworkActivityIndicatorVisible = false

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
			imageView.sizeToFit()
		} else {
			let imageView = UIImageView(image: picture)
			imageView.restorationIdentifier = "imageView"
			imageScrollView.addSubview(imageView)
		}
	}

	func displayApodError(viewModel: ApodErrorViewModel) {
		presentAlert(errorMessage: viewModel.errorMessage)

		progressView.isHidden = true
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		if refreshControl.isRefreshing {
			refreshControl.endRefreshing()
		}
	}

	private func presentAlert(errorMessage: String) {
		let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

	func displayProgress(viewModel: ApodPictureDownloadProgressViewModel) {
		progressView.setProgress(viewModel.progressRatio, animated: true)
	}
}

extension ApodViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return getImageViewFromScrollView()
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		updateImageViewFrame(scrollView: scrollView)
	}

	fileprivate func updateImageViewFrame(scrollView: UIScrollView) {
		if let imageView = getImageViewFromScrollView() {
			let yOffset = max(0, (scrollView.frame.height - imageView.frame.height) / 2)
			let xOffset = max(0, (scrollView.frame.width - imageView.frame.width) / 2)
			imageView.frame = CGRect(x: xOffset, y: yOffset, width: imageView.frame.width, height: imageView.frame.height)
		}
	}
}
