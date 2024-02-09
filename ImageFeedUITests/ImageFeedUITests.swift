//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Артем Чалков on 06.11.2023.
//

import XCTest

import XCTest

class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"]
        
        print(app.debugDescription) 
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        
        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("")
        webView.swipeUp()
        
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
        
        // Нажать кнопку логина
        webView.buttons["Login"].tap()
            
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        // Подождать, пока открывается и загружается экран ленты
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            
        
        // Сделать жест «смахивания» вверх по экрану для его скролла
        
        cell.swipeUp()
        
        sleep(2)
        
        // Поставить лайк в ячейке верхней картинки
        // Отменить лайк в ячейке верхней картинки
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
            
        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()
        
        sleep(2)
        
        // Нажать на верхнюю ячейку
        
        cellToLike.tap()
            
        sleep(2)
        
        // Подождать, пока картинка открывается на весь экран
        // Увеличить картинку
        // Уменьшить картинку
        
        let image = app.scrollViews.images.element(boundBy: 0)
           // Zoom in
       image.pinch(withScale: 3, velocity: 1) // zoom in
       // Zoom out
       image.pinch(withScale: 0.5, velocity: -1)
        
        // Вернуться на экран ленты
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
