//
//  MoviesPresenter.swift
//  MovieApp
//
//  Created by Anas Salah on 09/05/2024.
//

import Foundation

protocol MoviesPresenterProtocol {
    func fetchData()
    func reloadDataFromSQLite()
    func numberOfSections() -> Int
    func numberOfRows(inSection section: Int) -> Int
    func movie(at indexPath: IndexPath) -> ActionMovie
    func didSelectRow(at indexPath: IndexPath)
    func titleForHeader(inSection section: Int) -> String?
    func deleteMovie(at indexPath: IndexPath)
}

protocol MovieViewProtocol: AnyObject {
    func displayMovies(_ movies: [ActionMovie])
    func displayError(_ message: String)
    func showMovieDetails(for movie: ActionMovie)
}

class MoviesPresenter: MoviesPresenterProtocol {
    
    private weak var view: MovieViewProtocol?
    private let dataManager: MovieDataManager
    private let dbHelper: DBHelper
    private var movies: [ActionMovie] = moviesStatic// Static movies
    private var urlSessionMovies: [ActionMovie] = [] //
    private var tableView = TableViewController()
    
    
    init(view: MovieViewProtocol) {
        self.view = view
        self.dataManager = MovieDataManager.shared
        self.dbHelper = DBHelper.shared
    }
    
    func fetchData() {
        dataManager.loadData { [weak self] moviesPojo in
            guard let self = self else { return }
            
            if let moviesPojo = moviesPojo {
                var actionMovies: [ActionMovie] = []
                
                for moviePojo in moviesPojo {
                    guard let posterURL = URL(string: moviePojo.poster),
                          let imageData = try? Data(contentsOf: posterURL) else {
                        continue
                    }
                    
                    let actionMovie = ActionMovie(
                        title: moviePojo.title,
                        imageData: imageData,
                        rating: Int(moviePojo.rating),
                        releaseYear: moviePojo.year,
                        genre: moviePojo.genre
                    )
                    
                    actionMovies.append(actionMovie)
                }
                
                self.urlSessionMovies = actionMovies
                
                DispatchQueue.main.async {
                    self.view?.displayMovies(actionMovies)
                }
            } else {
                DispatchQueue.main.async {
                    self.view?.displayError("Failed to fetch movies.")
                }
            }
        }
    }
    
    func reloadDataFromSQLite() {
        let moviesFromDB = dbHelper.retrieveAllMovies()
        view?.displayMovies(moviesFromDB)
    }
    
    func numberOfSections() -> Int {
        return 3
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        switch section {
        case 0:
            return movies.count
        case 1:
            return dbHelper.retrieveAllMovies().count
        case 2:
            return urlSessionMovies.count
        default:
            return 0
        }
    }
    
    func movie(at indexPath: IndexPath) -> ActionMovie {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            return movies[row]
        case 1:
            let moviesFromDB = dbHelper.retrieveAllMovies()
            return moviesFromDB[row]
        case 2:
            return urlSessionMovies[row]
        default:
            fatalError("Invalid section")
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let selectedMovie = movie(at: indexPath)
        view?.showMovieDetails(for: selectedMovie)
    } // MARK: have to make the functionalty in tableView to avoid importing UIKIT here
    
    
    func titleForHeader(inSection section: Int) -> String? {
        switch section {
        case 0:
            return "Static Arr"
        case 1:
            return "SQLite Movies"
        case 2:
            return "URL Session"
        default:
            return nil
        }
    }
    
    func deleteMovie(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("Deleted : \(movies[indexPath.row].title)")
            
            movies.remove(at: indexPath.row)
            reloadTableViewData()
        case 1:
            let moviesFromDB = dbHelper.retrieveAllMovies()
            let movieToDelete = moviesFromDB[indexPath.row]
            dbHelper.delete(title: movieToDelete.title)
            reloadDataFromSQLite()
        case 2:
            let movieToDelete = urlSessionMovies[indexPath.row]
        default:
            fatalError("Invalid section")
        }
    }


    func reloadTableViewData() {
        view?.displayMovies(movies)

    }
}
