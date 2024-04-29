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
    
    var selectedMovie: ActionMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(selectedMovie?.image as Any)
        
        movieNameLbl.text = selectedMovie?.title ?? " "
        movieRatingLbl.text = String(selectedMovie?.rating ?? 0)
        movieGenreLbl.text = selectedMovie?.genre.joined(separator: ", ")
        movieReleaseYearLbl.text = String(selectedMovie?.releaseYear ?? 0)
        movieImg.image = selectedMovie?.image as? UIImage
    }
    
    func addMovie(movie: ActionMovie) {
        movies.append(selectedMovie!)
    }
    

}
