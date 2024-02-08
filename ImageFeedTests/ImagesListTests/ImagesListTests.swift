//
//  ImagesListTests.swift
//  ImageFeedTests
//

@testable import ImageFeed
import XCTest

class ImagesListPresenterSpy: ImageListPresenterProtocol {
    
  
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var viewWillAppearCalled = false
    var viewWillDisappearCalled = false
    var viewDidAppearCalled = false
    
    var fetchPhotosNextPageCalled = false
    
    func viewWillAppear() {
        viewWillAppearCalled = true
    }
    
    func viewDidAppear() {
        viewDidAppearCalled = true
    }
    
    func viewWillDisappear() {
        viewWillDisappearCalled = true
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = false
    }
    
    var imageListService: ImageFeed.ImagesListService = ImageFeed.ImagesListService()
    
    func getPhotos() -> [ImageFeed.Photo] {
        return []
    }
    
    func update(_ index: Int, newPhoto: ImageFeed.Photo) {
        
    }
    
    
}

final class ImagesListTests: XCTestCase {

    func testViewControllerCallsViewWillAppear() {
        
        //given
        let controller = ImagesListViewController()
        
        let presenter = ImagesListPresenterSpy()
        
        controller.presenter = presenter
        presenter.view = controller
        
        //when
        _ = controller.viewWillAppear(false)
        
        //then
        XCTAssertTrue(presenter.viewWillAppearCalled) //behaviour verification
    }

    //viewWillDisappear
    
    func testViewControllerCallsViewDidAppear() {
        
        //given
        let controller = ImagesListViewController()
        
        let presenter = ImagesListPresenterSpy()
        
        controller.presenter = presenter
        presenter.view = controller
        
        //when
        _ = controller.viewDidAppear(false)
        
        //then
        XCTAssertTrue(presenter.viewDidAppearCalled) //behaviour verification
    }
    
    //fetchNewPhotos
    
    
}
