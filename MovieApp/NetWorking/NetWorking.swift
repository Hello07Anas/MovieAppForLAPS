//
//  NetWorking.swift
//  MovieApp
//
//  Created by Anas Salah on 30/04/2024.
//

//import Foundation
//
//// MARK: next fun to fetch data using URL Session
//func loadData(complisttionHandler: @escaping ([NewsPojo]?)-> Void) {
//    let url = URL(string: "")
//    
//    guard let newURl = url else {
//        complisttionHandler(nil)
//        return
//    }
//    
//    let request = URLRequest(url: newURl)
//    let session = URLSession(configuration: .default)
//    
//    let task = session.dataTask(with: request) { data, response, error in
//        guard let data = data else {
//            complisttionHandler(nil)
//            return
//        }
//        print("BackGround")
//        do {
//            let result = try JSONDecoder().decode([NewsPojo].self, from: data)
//            complisttionHandler(result)
//        } catch let error {
//            print(error.localizedDescription)
//            complisttionHandler(nil)
//        }
//    }
//    task.resume()
//}

import UIKit

// MARK: next fun to fetch data using URL Session
func loadData(complisttionHandler: @escaping ([NewsPojo]?)-> Void) {
    let networkIndicator = UIActivityIndicatorView(style: .gray)
    networkIndicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    networkIndicator.startAnimating()
    UIApplication.shared.keyWindow?.addSubview(networkIndicator)
    /*
    Discussion
    This property holds the UIWindow object in the windows array that is most recently sent the makeKeyAndVisible() message.
     */
    let url = URL(string: "https://freetestapi.com/api/v1/movies")
    
    guard let newURl = url else {
        complisttionHandler(nil)
        DispatchQueue.main.async {
            networkIndicator.stopAnimating()
            networkIndicator.removeFromSuperview()
        }
        return
    }
    
    let request = URLRequest(url: newURl)
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: request) { data, response, error in
        DispatchQueue.main.async {
            networkIndicator.stopAnimating()
            networkIndicator.removeFromSuperview()
        }
        
        guard let data = data else {
            complisttionHandler(nil)
            return
        }
        print("BackGround")
        do {
            let result = try JSONDecoder().decode([NewsPojo].self, from: data)
            complisttionHandler(result)
        } catch let error {
            print(error.localizedDescription)
            complisttionHandler(nil)
        }
    }
    task.resume()
}
