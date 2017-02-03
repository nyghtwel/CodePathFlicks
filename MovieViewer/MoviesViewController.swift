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
  
  
  
  // @IBOutlet var didTap: UITapGestureRecognizer!
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
          // print(dataDictionary)
          self.movies = dataDictionary["results"] as? [NSDictionary]
          self.tableView.reloadData()
        }
      }
      
    }
    print("init")
    
    task.resume()
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (showText))
    gestureRecognizer.numberOfTapsRequired = 2
    tableView.addGestureRecognizer(gestureRecognizer)
    let longGesture = UITapGestureRecognizer(target: self, action: #selector (jump))
    
    tableView.addGestureRecognizer(longGesture)
    longGesture.require(toFail: gestureRecognizer)
    print("init tap")
  }
  
  func jump(recognizer: UIGestureRecognizer){
    if recognizer.state == UIGestureRecognizerState.ended{
      
      let tappedLocation = recognizer.location(in: self.tableView)
      //  let tappedY = tappedLocation.y.truncatingRemainder(dividingBy: 620)
      
      
      if let tappedIndexPath = tableView.indexPathForRow(at: tappedLocation ){
        //var row = 0;
        
        
        if let tappedCell = self.tableView.cellForRow(at: tappedIndexPath) as? MovieCell{
          //print(tappedCell)
          tappedCell.overviewLabel.isHidden = !(tappedCell.overviewLabel.isHidden)
          
          if !tappedCell.overviewLabel.isHidden {
            tappedCell.overviewLabel.backgroundColor = UIColor.black
            
          }else{
            tappedCell.overviewLabel.backgroundColor = UIColor.clear
          }
        }
      }
      
      
    }
    
    
    
  }
  func showText(recognizer: UIGestureRecognizer){
    if recognizer.state == UIGestureRecognizerState.ended{
      let tappedLocation = recognizer.location(in: self.tableView)
      let tappedY = tappedLocation.y.truncatingRemainder(dividingBy: 650)
      
      if let tappedIndexPath = tableView.indexPathForRow(at: tappedLocation ){
        
        var row = 0;
        if(tappedY > 320 && tappedIndexPath.row < movies!.count){
          if let tappedCell = self.tableView.cellForRow(at: tappedIndexPath) as? MovieCell{
            //print(tappedCell)
            tappedCell.overviewLabel.isHidden = true
            
            
            tappedCell.overviewLabel.backgroundColor = UIColor.clear
            
          }
          row = tappedIndexPath.row+1
          let index = NSIndexPath(row: row, section: 0)
          self.tableView.scrollToRow(at: index as IndexPath, at: .bottom, animated: true)
        }else if (tappedY < 320 && tappedIndexPath.row != 0) {
          if let tappedCell = self.tableView.cellForRow(at: tappedIndexPath) as? MovieCell{
            //print(tappedCell)
            tappedCell.overviewLabel.isHidden = true
            
            tappedCell.overviewLabel.backgroundColor = UIColor.clear
            
          }
          print("bug")
          row = tappedIndexPath.row - 1
          let index = NSIndexPath(row: row, section: 0)
          self.tableView.scrollToRow(at: index as IndexPath, at: .bottom, animated: true)
        }else{
          
          
        }
      }
      
    }
    
  }
  
  //long press function
  
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
    cell.titleLabel.isHidden = true
    
    cell.overviewLabel.text = overview
    cell.overviewLabel.isHidden = true
    cell.overviewLabel.backgroundColor = UIColor.clear
    cell.posterView.setImageWith(imageURL! as URL)
    return cell
    
  }
  
  
}
