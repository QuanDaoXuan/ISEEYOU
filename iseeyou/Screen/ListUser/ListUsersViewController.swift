//
//  ListUsersViewController.swift
//  iseeyou
//
//  Created by resopt on 11/11/20.
//  Copyright © 2020 truc. All rights reserved.
//

import UIKit

class ListUsersViewController: UITableViewController {
    let viewModel = ListUsersModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(R.nib.listUserCell)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.listUserCell, for: indexPath)!
        cell.isUserInteractionEnabled = false
        cell.titleLb.text = RamdomName().getRandom()
        return cell
    }
}
