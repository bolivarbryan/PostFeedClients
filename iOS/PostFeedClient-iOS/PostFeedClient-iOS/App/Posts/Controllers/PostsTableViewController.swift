//
//  PostsTableViewController.swift
//  PostFeedClient-iOS
//
//  Created by Bryan A Bolivar M on 10/10/20.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    /// Posts List ViewModel which handles Datasource and connects to networking and database layers
    let viewModel = PostsListViewModel()
    
    /// Selected post for display on a webview
    var selectedPost: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts Feed"
        self.clearsSelectionOnViewWillAppear = true
        viewModel.fetch() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let post = viewModel.posts[indexPath.row]
        cell.textLabel?.text = post.cellTitle
        cell.detailTextLabel?.text = post.cellDescription
        
        cell.accessoryType = post.url != nil ? .disclosureIndicator : .none
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            viewModel.posts.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = viewModel.posts[indexPath.row]
        if selectedPost?.url != nil {
            performSegue(withIdentifier: "webSegue", sender: self)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webSegue" {
            let vc = segue.destination as! WebViewController
            vc.post = selectedPost
        }
    }
    
    
}
