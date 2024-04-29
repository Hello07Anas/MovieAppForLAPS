//
//  DBhelper.swift
//  MovieApp
//
//  Created by Anas Salah on 28/04/2024.
//

import Foundation
import SQLite3
import UIKit

class DBHelper {
    static let shared = DBHelper() // SingleTone
    
    private var db: OpaquePointer?
    private let dbPath: String
    
    private init() {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access document directory.")
        }
        self.dbPath = documentDirectoryPath.appendingPathComponent("movies.sqlite").path
        
        if sqlite3_open(self.dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.dbPath)")
            createTable()
        } else {
            fatalError("Unable to open database.")
        }
    }
    
    private func createTable() { // Binary Large Object == BLOB
        let createTableString = """
        CREATE TABLE IF NOT EXISTS ActionMovie (
            title TEXT PRIMARY KEY,
            image BLOB,
            rating INTEGER,
            releaseYear INTEGER,
            genre TEXT
        );
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("ActionMovie table created.")
            } else {
                print("ActionMovie table is not created.")
            }
        } else {
            print("CREATE TABLE statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(movie: ActionMovie) {
        let insertStatementString = "INSERT INTO ActionMovie (title, image, rating, releaseYear, genre) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (movie.title as NSString).utf8String, -1, nil)
            if let imageData = movie.image?.pngData() {
                sqlite3_bind_blob(insertStatement, 2, (imageData as NSData).bytes, Int32(imageData.count), nil)
            } else {
                sqlite3_bind_null(insertStatement, 2)
            }
            sqlite3_bind_int(insertStatement, 3, Int32(movie.rating))
            sqlite3_bind_int(insertStatement, 4, Int32(movie.releaseYear))
            let genreString = movie.genre.joined(separator: ",")
            sqlite3_bind_text(insertStatement, 5, (genreString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) != SQLITE_DONE {
                print("Could not insert \(movie.title).")
            }
        } else {
            print("INSERT statement is not prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func delete(title: String) {
        let deleteStatementString = "DELETE FROM ActionMovie WHERE title = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (title as NSString).utf8String, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted movie with title \(title).")
            } else {
                print("Failed to delete movie with title \(title).")
            }
        } else {
            print("DELETE statement is not prepared.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    func retrieveAllMovies() -> [ActionMovie] {
        var movies: [ActionMovie] = []
        let queryStatementString = "SELECT title, image, rating, releaseYear, genre FROM ActionMovie;"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let title = String(cString: sqlite3_column_text(queryStatement, 0))
                let imageDataPtr = sqlite3_column_blob(queryStatement, 1)
                let imageDataSize = sqlite3_column_bytes(queryStatement, 1)
                let image: UIImage?
                if let imageDataPtr = imageDataPtr {
                    let imageData = Data(bytes: imageDataPtr, count: Int(imageDataSize))
                    image = UIImage(data: imageData)
                } else {
                    image = nil
                }
                let rating = Int(sqlite3_column_int(queryStatement, 2))
                let releaseYear = Int(sqlite3_column_int(queryStatement, 3))
                let genreString = String(cString: sqlite3_column_text(queryStatement, 4))
                let genre = genreString.components(separatedBy: ",")
                
                let movie = ActionMovie(title: title, image: image, rating: rating, releaseYear: releaseYear, genre: genre)
                movies.append(movie)
            }
        } else {
            print("Failed to retrieve movies.")
        }
        
        sqlite3_finalize(queryStatement)
        
        return movies
    }
    
    deinit {
        if sqlite3_close(db) == SQLITE_OK {
            print("Database connection closed.")
        } else {
            print("Unable to close database connection.")
        }
    }
}


