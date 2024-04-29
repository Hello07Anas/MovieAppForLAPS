//
//  AddNewMovie.swift
//  MovieApp
//
//  Created by Anas Salah on 24/04/2024.
//

import UIKit

class AddNewMovie: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        
    @IBOutlet weak var nameOfMovieTF: UITextField!
    @IBOutlet weak var releaseYearTF: UITextField!
    @IBOutlet weak var genreTF: UITextField!
    @IBOutlet weak var ratingTF: UITextField!
    @IBOutlet weak var imgTest: UIImageView!
    
    var addMovieDelegate: AddMovieProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func donetBtn(_ sender: Any) {
        
        let newMovie = ActionMovie(title: nameOfMovieTF.text ?? " ",
                                   image: UIImage(named: "Mad Max"),
                                   rating: Int(ratingTF.text ?? "") ?? 5,
                                   releaseYear: Int(releaseYearTF.text ?? "") ?? 5,
                                   genre: genreTF.text?.split(separator: " ").map { String($0) } ?? [])
        
        addMovieDelegate?.addMovie(movie: newMovie)
        if (newMovie.title != " " && newMovie.genre != [] && newMovie.image != nil && newMovie.rating != 0 && newMovie.releaseYear != 0) {
            addMovieDelegate?.addMovie(movie: newMovie)
            navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Attention Pleas", message: "Sorry can not add empty data", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { _ in
                        print("OK tapped")
                    }
                    alertController.addAction(action)
                    
                    present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func imagePickerBtn(_ sender: Any) {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            print("Something went Roung!!")
        }
    }
    
    //didFinishPickingMediaWithInfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imgTest.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
