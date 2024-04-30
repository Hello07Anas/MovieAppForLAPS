//
//  TableViewController.swift
//  MovieApp
//
//  Created by Anas Salah on 22/04/2024.
//

import UIKit
import SDWebImage

class TableViewController: UITableViewController, AddMovieProtocol {
   
    var moviesFromSQL: [ActionMovie] = []
    var dbHelper = DBHelper.shared

    var addDelegate: AddMovieProtocol?
    var networkIndicator: UIActivityIndicatorView?
    var newsPojoArray: [NewsPojo]? // MARK: -> From URL Session


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataFromSQLite()
        
        loadData { [weak self] newsPojoArray in
                guard let self = self else { return }
                if let newsPojoArray = newsPojoArray {
                    self.newsPojoArray = newsPojoArray
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Failed to fetch data")
                }
            }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        reloadDataFromSQLite()
//    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return movies.count
        } else if section == 1 {
            return dbHelper.retrieveAllMovies().count
        } else {
            return newsPojoArray?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            let movie = movies[indexPath.row]
            cell.textLabel?.text = movie.title
        } else if indexPath.section == 1{
            let moviesFromDB = dbHelper.retrieveAllMovies()
            let movie = moviesFromDB[indexPath.row]
            cell.textLabel?.text = movie.title
        } else { // MARK: >>> Cange Test..
            cell.textLabel?.text = newsPojoArray?[indexPath.row].title ?? ""
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.section == 0 {
             let chosenMovie = movies[indexPath.row]
             navigateToMovieViewController(with: chosenMovie)
         } else if indexPath.section == 1 {
             let moviesFromDB = dbHelper.retrieveAllMovies()
             let chosenMovie = moviesFromDB[indexPath.row]
             navigateToMovieViewController(with: chosenMovie)
         } else {
             if let newsPojo = newsPojoArray?[indexPath.row] {
                 downloadImageAndNavigate(newsPojo: newsPojo)
             } else {
                 print("Failed to get NewsPojo for selected row")
             }
         }
     }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Static Arr"
        } else if section == 1{
            return "SQLite Movies"
        } else {
            return "URL Session"
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else if indexPath.section == 1 {
                let moviesFromDB = dbHelper.retrieveAllMovies()
                let movieToDelete = moviesFromDB[indexPath.row]
                dbHelper.delete(title: movieToDelete.title)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                newsPojoArray?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

    
    // MARK: - Helper Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addNewMovie = segue.destination as? AddNewMovie
        addNewMovie?.addMovieDelegate = self
    }
    
    func delete(title: String) {
        dbHelper.delete(title: title)
    }

    func reloadDataFromSQLite() {
        moviesFromSQL = dbHelper.retrieveAllMovies()
        tableView.reloadData()
    }
    
    func addMovie(movie: ActionMovie) {
            movies.append(movie)
            tableView.reloadData()
            print(movies.count)
    }
    
    func downloadImageAndNavigate(newsPojo: NewsPojo) {
        guard let imageUrl = URL(string: newsPojo.poster) else {
            print("Invalid image URL")
            return
        }

        SDWebImageManager.shared.loadImage(with: imageUrl, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            if let image = image {
                let chosenMovie = ActionMovie(title: newsPojo.title, image: image, rating: Int(newsPojo.rating), releaseYear: newsPojo.year, genre: newsPojo.genre)
                self.navigateToMovieViewController(with: chosenMovie)
            } else {
                print("Failed to download image")
            }
        }
    }
    
    func navigateToMovieViewController(with movie: ActionMovie) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.selectedMovie = movie
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}	

/*
// Override to support conditional editing of the table view.
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
}
*/

/*
// Override to support rearranging the table view.
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
}
*/

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
