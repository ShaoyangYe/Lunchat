//
//  PeopleViewController.swift
//  Lunchat
//
//  Created by JamesCullen on 2019/10/21.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    var searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    var users: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
//        self.navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.barTintColor = UIColor.white
        loadUsers()
    }
    
    func loadUsers() {
        Api.User.observeUsers { (user) in
            self.isFollowing(userId: user.id!, completed: { (value) in
                user.isFollowing = value
                self.hasFollower(userId: user.id!, completed: { (value1) in
                    user.hasFollower = value1
                    self.users.append(user)
                    self.tableView.reloadData()
                    
                })
            })

        }
    }

    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    func hasFollower(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.hasFollower(userId: userId, completed: completed)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender  as! String
            profileVC.userId = userId
            profileVC.delegate = self
        }
    }
    
    func doSearch() {
        if let searchText = searchBar.text?.lowercased() {
            self.users.removeAll()
            self.tableView.reloadData()
            Api.User.queryUsers(withText: searchText, completion: { (user) in
                self.isFollowing(userId: user.id!, completed: { (value) in
                    user.isFollowing = value
                    
                    self.users.append(user)
                    self.tableView.reloadData()
                    
                })
            })
        }
    }
}

extension PeopleViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
}

extension PeopleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension PeopleViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "ProfileSegue", sender: userId)
    }
}

extension PeopleViewController: ProfileViewControllerDelegate {
    func updateFollowButton(forUser user: UserModel) {
        for u in self.users {
            if u.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
}
