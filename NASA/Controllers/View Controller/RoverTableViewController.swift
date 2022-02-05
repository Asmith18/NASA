//
//  RoverTableViewController.swift
//  NASA
//
//  Created by adam smith on 2/4/22.
//

import UIKit

class RoverTableViewController: UITableViewController {
    
    @IBOutlet weak var roverSearchBar: UISearchBar!

    private var rovers = [Rover]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roverSearchBar.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rovers.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "roverCell", for: indexPath) as? RoverTableViewCell else { return UITableViewCell() }
        
        cell.rover = rovers[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

extension RoverTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchTerm = searchBar.text,
              !searchTerm.isEmpty
        else { return }
        
        RoverNetworkController.fetchRover(from: searchTerm) { rover in
            guard let rover = rover else { return }
            self.rovers = rover
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
