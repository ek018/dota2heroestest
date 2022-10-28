//
//  SortingController.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 27/10/22.
//

import UIKit

class SortingController: UIViewController {
    
    var chooseSortingBy: String = ""
    
    lazy var sortingCell: UITableView = {
        let sortingCell = UITableView()
        sortingCell.translatesAutoresizingMaskIntoConstraints = false
        return sortingCell
    }()
    
    override func loadView() {
        super.loadView()
        setupTableCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sort Heroes"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(didTapApplyButton))
        setupTableConstrains()
    }
    
    func setupTableCell() {
        view.addSubview(sortingCell)
        sortingCell.delegate = self
        sortingCell.dataSource = self
        sortingCell.register(UINib(nibName: "HeroSortingViewCell", bundle: nil), forCellReuseIdentifier: "HeroSortingViewCell")
        sortingCell.rowHeight = UITableView.automaticDimension
        sortingCell.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setupTableConstrains() {
        sortingCell.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sortingCell.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sortingCell.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    @objc func didTapApplyButton() {
        NotificationCenter.default.post(name: Notification.Name("sortingBy"), object: chooseSortingBy)
        dismiss(animated: true, completion: nil)
    }
}

extension SortingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroSortingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroSortingViewCell") as? HeroSortingViewCell
        
        if let cell = cell {
            cell.titleLabel.text = heroSortingData[indexPath.row].label
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseSortingBy = heroSortingData[indexPath.row].sortBy ?? ""
    }
    
    
}
