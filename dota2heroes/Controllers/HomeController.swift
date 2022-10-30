//
//  ViewController.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 27/10/22.
//

import UIKit



class HomeController: BaseViewController {
    private let homeVM = HomeViewModel()
    private var heroStatus: HeroStats = []
    private var heroRoles: [String] = []
    private var roleFilter: String = "All"
    private var heroFilter: HeroStats = []
    private let notificationCenter = NotificationCenter.default
    
    
    lazy var heroRolesFilterButton: UICollectionView = {
        let buttonLayout = UICollectionViewFlowLayout()
        buttonLayout.scrollDirection = .horizontal
        buttonLayout.itemSize = CGSize(width: 80, height: 50)
        let heroRolesFilterButton = UICollectionView(frame: .zero, collectionViewLayout: buttonLayout)
        heroRolesFilterButton.translatesAutoresizingMaskIntoConstraints = false
        heroRolesFilterButton.showsHorizontalScrollIndicator = false
        heroRolesFilterButton.clipsToBounds = false
        return heroRolesFilterButton
    }()
    
    lazy var heroCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width/3)-4,
                                 height: (view.frame.size.height/6)-4)
        
        let heroCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        heroCollectionView.translatesAutoresizingMaskIntoConstraints = false
        //        heroCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: floatingButton.bounds.size.height + 20, right: 0)
        
        return heroCollectionView
    }()
    
    lazy var floatingButton: UIButton = {
        let floatingButton = UIButton()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setTitle("Sort", for: .normal)
        floatingButton.backgroundColor = .black
        floatingButton.clipsToBounds = true
        floatingButton.layer.zPosition = 100
        floatingButton.addTarget(self, action: #selector(tappedSortButton(_:)), for: .touchUpInside)
        return floatingButton
    }()
    
    
    
    override func loadView() {
        super.loadView()
        setupViews()
        setupConstrains()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dota 2"
        self.homeVM.fetchHeroListStat { heroStatus, heroRoles in
            self.heroRoles = heroRoles
            self.heroStatus = heroStatus
            self.heroFilter = heroStatus
            
            DispatchQueue.main.async {
                self.heroRolesFilterButton.reloadData()
                self.heroCollectionView.reloadData()
            }
        }
        notificationCenter.addObserver(self, selector: #selector(tappedSortFunc(_:)), name: NSNotification.Name("sortingBy"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(floatingButton)
        
    }
    
    func setupViews() {
        // superview
        view.backgroundColor = .white
        view.addSubview(heroRolesFilterButton)
        view.addSubview(heroCollectionView)
        view.addSubview(floatingButton)
        
        // hero roles filter button
        heroRolesFilterButton.dataSource = self
        heroRolesFilterButton.delegate = self
        heroRolesFilterButton.register(UINib(nibName: "HeroRolesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HeroRolesCollectionViewCell")
        
        // hero collection view
        heroCollectionView.dataSource = self
        heroCollectionView.delegate = self
        heroCollectionView.register(HeroCustomCollectionCell.self, forCellWithReuseIdentifier: HeroCustomCollectionCell.identifier)
        heroCollectionView.frame = view.bounds
        
        // floating button
        floatingButton.layer.cornerRadius = 10
        
    }
    
    func setupConstrains() {
        // hero roles filter button
        heroRolesFilterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        heroRolesFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        heroRolesFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        heroRolesFilterButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        
        // hero collection view
        heroCollectionView.topAnchor.constraint(equalTo: heroRolesFilterButton.bottomAnchor, constant: 16).isActive = true
        heroCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        heroCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//                heroCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24).isActive = true
        
        // floating button
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        floatingButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        
        floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    @IBAction private func tappedSortFunc(_ notification: Notification) {
        let sortBy = notification.object as! String

        if sortBy == "base_attack_min" {
            heroFilter = heroFilter.sorted { $0.baseAttackMin ?? 0 > $1.baseAttackMin ?? 0}
        } else if sortBy == "base_health" {
            heroFilter = heroFilter.sorted { $0.baseHealth ?? 0 > $1.baseHealth ?? 0 }
        } else if sortBy == "base_mana" {
            heroFilter = heroFilter.sorted { $0.baseMana ?? 0 > $1.baseMana ?? 0 }
        } else {
            heroFilter = heroFilter.sorted { $0.moveSpeed ?? 0 > $1.moveSpeed ?? 0 }
        }
        
        DispatchQueue.main.async {
            self.heroCollectionView.reloadData()
        }
    }
    
    @IBAction private func tappedSortButton(_ sender: Any) {
        let sortingVC = SortingController()
        present(UINavigationController(rootViewController: sortingVC), animated: true)
    }
    
    
    //MARK : - Remove Notification
    deinit {
        notificationCenter
            .removeObserver(self,
                            name: NSNotification.Name("sortingBy") ,
                            object: nil) }
    
    
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.heroRolesFilterButton {
            return heroRoles.count
        }
        return heroFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.heroRolesFilterButton {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroRolesCollectionViewCell", for: indexPath) as? HeroRolesCollectionViewCell
            if let cell = cell {
                cell.heroRolesTitle?.text = heroRoles[indexPath.row]
                
                cell.heroRolesTitle?.font = UIFont.systemFont(ofSize: 12)
                cell.layer.borderColor = UIColor.gray.cgColor
                cell.layer.borderWidth = 0.5
                cell.layer.cornerRadius = 10
                cell.backgroundColor = roleFilter == heroRoles[indexPath.row] ? .white : .black
                cell.heroRolesTitle?.textColor = roleFilter == heroRoles[indexPath.row] ? .black : .white
                return cell
            }
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCustomCollectionCell.identifier, for: indexPath) as? HeroCustomCollectionCell
            if let cell = cell {
                cell.configure(label: heroFilter[indexPath.row].localizedName ?? "", image: heroFilter[indexPath.row].img ?? "")
                return cell
            }
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.heroCollectionView {
            let heroDetailController = HeroDetailController()
            let stat = heroFilter[indexPath.row]
            let heroBasicStat = [HeroBaseStatModel(id: 1, icon: "house", baseStatus: "Base Health", baseStatusData: stat.baseHealth), HeroBaseStatModel(id: 2, icon: "house", baseStatus: "Base Mana", baseStatusData: stat.baseMana),HeroBaseStatModel(id: 3, icon: "house", baseStatus: "Base Armor", baseStatusData: Int(stat.baseArmor ?? 0)),HeroBaseStatModel(id: 4, icon: "house", baseStatus: "Base Attack", baseStatusData: stat.baseAttackMin),HeroBaseStatModel(id: 5, icon: "house", baseStatus: "Move Speed", baseStatusData: stat.moveSpeed)]
            
            heroDetailController.heroName = stat.localizedName
            heroDetailController.heroAttr = stat.primaryAttr
            
            guard let imageData = stat.img, let iconData = stat.icon else { return  }
            let heroImageData = ApiServices.baseURL + imageData
            let heroIconData = ApiServices.baseURL + iconData
            heroDetailController.heroImage =  heroImageData
            heroDetailController.heroIcon = heroIconData
            heroDetailController.attackType = stat.attackType
            heroDetailController.heroBasicStatus = heroBasicStat
            heroDetailController.heroRolesDetail = stat.roles
            navigationController?.pushViewController(heroDetailController, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
            
        } else {
            roleFilter = heroRoles[indexPath.row]
            if roleFilter == "All" {
                self.heroFilter = heroStatus
            } else {
                let result = heroStatus.filter { $0.roles.contains(where: { $0 == self.roleFilter})}
                self.heroFilter = result
            }
            DispatchQueue.main.async {
                self.heroRolesFilterButton.reloadData()
                self.heroCollectionView.reloadData()
            }
        }
    }
    
    
}

