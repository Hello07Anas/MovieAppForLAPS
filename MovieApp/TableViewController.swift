//
//  TableViewController.swift
//  MovieApp
//
//  Created by Anas Salah on 22/04/2024.
//

import UIKit

class TableViewController: UITableViewController, AddMovieProtocol {

    var moviesFromSQL: [ActionMovie] = []
    var addDelegate: AddMovieProtocol?
    var dbHelper = DBHelper.shared

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataFromSQLite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadDataFromSQLite()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return movies.count
        } else {
            return dbHelper.retrieveAllMovies().count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            let movie = movies[indexPath.row]
            cell.textLabel?.text = movie.title
        } else {
            let moviesFromDB = dbHelper.retrieveAllMovies()
            let movie = moviesFromDB[indexPath.row]
            cell.textLabel?.text = movie.title
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenMovie: ActionMovie
        if indexPath.section == 0 {
            chosenMovie = movies[indexPath.row]
        } else {
            let moviesFromDB = dbHelper.retrieveAllMovies()
            chosenMovie = moviesFromDB[indexPath.row]
        }
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        viewController.selectedMovie = chosenMovie
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Static Arr"
        } else {
            return "SQLite Movies"
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addNewMovie = segue.destination as? AddNewMovie
        addNewMovie?.addMovieDelegate = self
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let moviesFromDB = dbHelper.retrieveAllMovies()
                let movieToDelete = moviesFromDB[indexPath.row]
                dbHelper.delete(title: movieToDelete.title)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    // MARK: - Helper Methods
    
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
