//
//  ProfileTests.swift
//  ImageFeedTests
//

@testable import ImageFeed
import XCTest

class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    var exitButtonTappedCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func exitButtonTapped() {
        exitButtonTappedCalled = true
    }
    
    func fetchProfile() {
        
    }
    
    func fetchAvatar() {
        
    }
    
    func logout() {
        
    }
}

class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    
    var setProfileCalled: Bool = false
    var setAvatarCalled: Bool = false
    
    var navigateToSplashScreenCalled: Bool = false
    
    var showAlertCalled: Bool = false
    
    func configure(_ presenter: ImageFeed.ProfilePresenterProtocol) {
        
    }
    
    func setProfile(_ profile: ImageFeed.Profile) {
        setProfileCalled = true
    }
    
    func setAvatar(_ url: URL) {
        setAvatarCalled = true
    }
    
    func showLogoutAlert() {
        showAlertCalled = true
    }
    
    func navigateToSplashScreen() {
        navigateToSplashScreenCalled = true
    }
    
}

final class ProfileTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        
        //given
        let viewController = ProfileViewController()
        
        let presenter = ProfilePresenterSpy()
        
        viewController.configure(presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testViewControllerCallsExitButtonTapped() {
        
        //given
        let viewController = ProfileViewController()
        
        let presenter = ProfilePresenterSpy()
        
        viewController.configure(presenter)
        
        //when
        viewController.exitButtonTapped()
        
        //then
        XCTAssertTrue(presenter.exitButtonTappedCalled) //behaviour verification
    }

    func testPresenterLogoutCallsShowAlert() {
        
        //given
        let viewController = ProfileViewControllerSpy()
        
        let presenter = ProfilePresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.logout()
        
        //then
        XCTAssertTrue(viewController.navigateToSplashScreenCalled)
    }

}
