//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Alan Liou on 2/1/17.
//  Copyright © 2017 Alan Liou. All rights reserved.
//

import UIKit
import AFNetworking
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var tableView: UITableView!
  
  var movies: [NSDictionary]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      if let data = data {
        if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
          print(dataDictionary)
          self.movies = dataDictionary["results"] as? [NSDictionary]
          self.tableView.reloadData()
        }
      }
      
    }
    task.resume()
    
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    if movies != nil {
      return movies!.count
    }else{
      return 0
    }
  }
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    
    let movie = movies![indexPath.row]
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    let posterPath = movie["poster_path"] as! String
    let baseURL = "https://image.tmdb.org/t/p/w500/"
    let imageURL = NSURL(string: baseURL + posterPath)
    
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    cell.posterView.setImageWith(imageURL! as URL)
    return cell
    
  }
  
  
}
