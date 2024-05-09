//
//  TableViewController.swift
//  MovieApp
//
//  Created by Anas Salah on 22/04/2024.
//
import UIKit

class TableViewController: UITableViewController, MovieViewProtocol {
    var presenter: MoviesPresenterProtocol!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MoviesPresenter(view: self)
        presenter.fetchData()
    }

    
    func displayMovies(_ movies: [ActionMovie]) {
        reloadData()
    }
    
    func displayError(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let movie = presenter.movie(at: indexPath)
        cell.textLabel?.text = movie.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.titleForHeader(inSection: section)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteMovie(at: indexPath)
        }
    }
    
    func showMovieDetails(for movie: ActionMovie) {
        guard let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
                return
        }
        let detailsPresenter = DetatilsPresenter()
        //movieDetailsViewController.selectedMovie = movie 
        //MARK: Ask  here i allready have obj from view so i dont have to make one from presenter or i have ?!
        detailsPresenter.selectedMovie = movie

        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}
