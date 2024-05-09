//
//  ViewController.swift
//  MovieApp
//
//  Created by Anas Salah on 22/04/2024.
//

import UIKit

class ViewController: UIViewController, AddMovieProtocol {

    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieReleaseYearLbl: UILabel!
    @IBOutlet weak var movieGenreLbl: UILabel!
    @IBOutlet weak var movieRatingLbl: UILabel!
    
   // var selectedMovie: ActionMovie?
    var detailsPresenter = DetatilsPresenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(detailsPresenter.selectedMovie?.imageData as Any)
        
        movieNameLbl.text = detailsPresenter.selectedMovie?.title ?? " "
        movieRatingLbl.text = String(detailsPresenter.selectedMovie?.rating ?? 0)
        movieGenreLbl.text = detailsPresenter.selectedMovie?.genre.joined(separator: ", ")
        movieReleaseYearLbl.text = String(detailsPresenter.selectedMovie?.releaseYear ?? 0)
        movieImg.image = detailsPresenter.selectedMovie?.imageData as? UIImage
    }
    
    func addMovie(movie: ActionMovie) {
        moviesStatic.append(detailsPresenter.selectedMovie!)
    }
}

