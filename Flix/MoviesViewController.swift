//
//  MoviesViewController.swift
//  Flix
//
//  Created by Asad Rizvi on 9/17/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Download all movie data from the Movie Database API
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Store all movies into an array of dictionaries
                self.movies = dataDictionary["results"] as! [[String: Any]]
                
                // Repeatedly call tableView function
                self.tableView.reloadData()
                
                print(dataDictionary)
            }
        }
        task.resume()
    }
    
    // Creates the rows in the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // Populates the rows of the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // Get current movie
        let movie = movies[indexPath.row]
        
        // Get current movie title and synopsis
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        // Add title and synopsis to tableView
        cell.titleLabel!.text = title
        cell.synopsisLabel!.text = synopsis
        
        // Add movie posters
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
}
