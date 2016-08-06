//
//  ApodConfigurator.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

extension ApodViewController: ApodPresenterOutput {
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		router.passDataToNextScene(segue: segue)
	}
}

extension ApodInteractor: ApodViewControllerOutput {
}

extension ApodPresenter: ApodInteractorOutput {
}

class ApodConfigurator {
	// MARK: Object lifecycle
	
	class var sharedInstance: ApodConfigurator {
		struct Static {
			static var instance = ApodConfigurator()
			static var token: Int = 0
		}
		return Static.instance
	}
	
	// MARK: Configuration
	
	func configure(viewController: ApodViewController) {
		let router = ApodRouter()
		router.viewController = viewController
		
		let presenter = ApodPresenter()
		presenter.output = viewController
		
		let interactor = configureInteractor(presenter: presenter)
		
		viewController.output = interactor
		viewController.router = router
	}
	
	private func configureInteractor(presenter: ApodPresenter) -> ApodInteractor? {
		guard let initializer = getInitializer() else {
			return nil
		}
		
		let apodStore = initializer.createApodStore()
		let worker = ApodWorker(apodStore: apodStore)
		let interactor = ApodInteractor(apodWorker: worker)
		interactor.output = presenter
		return interactor
	}
	
	private func getInitializer() -> Initializer? {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		return appDelegate?.initializer
	}
}
