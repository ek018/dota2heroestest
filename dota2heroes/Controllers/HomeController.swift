//
//  ViewController.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 19/10/22.
//

import UIKit


class HomeController: BaseViewController {
    private let homeVM = HomeViewModel()
    private var heroStatus: HeroStats = []
    private var heroRoles: [String] = ["All","Carry",
                                       "Escape",
                                       "Nuker","All","au",
                                       "eu",
                                       "iu"]
    private var roleFilter: String = "Carry"
    private var heroFilter: HeroStats = []
    
    lazy var heroRolesFilterButton: UICollectionView = {
        let buttonLayout = UICollectionViewFlowLayout()
        buttonLayout.scrollDirection = .horizontal
        let heroRolesFilterButton = UICollectionView(frame: .zero, collectionViewLayout: buttonLayout)
        heroRolesFilterButton.translatesAutoresizingMaskIntoConstraints = false
        heroRolesFilterButton.showsHorizontalScrollIndicator = false
        heroRolesFilterButton.clipsToBounds = true
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
        floatingButton.layer.cornerRadius = floatingButton.layer.frame.size.width/2
        floatingButton.layer.zPosition = 100
        floatingButton.addTarget(self, action: #selector(tappedSortFunc(_:)), for: .touchUpInside)
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
        self.homeVM.fetchHeroListStat { heroStatus in
            self.heroStatus = heroStatus
            //            filter function
            //            let result = heroStatus.filter { $0.roles.contains(where: { $0 == self.roleFilter})}
            //            self.heroFilter = result
            DispatchQueue.main.async {
                self.heroCollectionView.reloadData()
            }
        }
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
        heroRolesFilterButton.register(HeroRolesCollectionViewCell.self, forCellWithReuseIdentifier: "HeroRolesCollectionViewCell")
        
        // hero collection view
        heroCollectionView.dataSource = self
        heroCollectionView.delegate = self
        heroCollectionView.register(HeroCustomCollectionCell.self, forCellWithReuseIdentifier: HeroCustomCollectionCell.identifier)
        view.addSubview(heroCollectionView)
        heroCollectionView.frame = view.bounds
        
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
        //        heroCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // floating button
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        floatingButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        
        floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    @IBAction private func tappedSortFunc(_ sender: Any) {
            print("tes")
        }
    
    
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.heroCollectionView {
            return heroStatus.count
        }
        return heroRoles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.heroCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCustomCollectionCell.identifier, for: indexPath) as? HeroCustomCollectionCell
            if let cell = cell {
                cell.configure(label: heroStatus[indexPath.row].localizedName ?? "", image: heroStatus[indexPath.row].img ?? "")
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroRolesCollectionViewCell", for: indexPath) as? HeroRolesCollectionViewCell
            if let cell = cell {
                cell.backgroundColor = .black
                cell.primaryFilterButton?.setTitleColor(.white, for: .normal)
                cell.primaryFilterButton?.setTitle(heroRoles[0], for: .normal)
                return cell
            }
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.heroCollectionView {
            let heroDetailController = HeroDetailController()
            let stat = heroStatus[indexPath.row]
            let heroBasicStat = [HeroBaseStatModel(id: 1, icon: "house", baseStatus: "Base Health", baseStatusData: stat.baseHealth), HeroBaseStatModel(id: 2, icon: "house", baseStatus: "Base Mana", baseStatusData: stat.baseMana),HeroBaseStatModel(id: 3, icon: "house", baseStatus: "Base Armor", baseStatusData: Int(stat.baseArmor ?? 0)),HeroBaseStatModel(id: 4, icon: "house", baseStatus: "Base Attack", baseStatusData: stat.baseAttackMin),HeroBaseStatModel(id: 5, icon: "house", baseStatus: "Move Speed", baseStatusData: stat.moveSpeed)]
            
            heroDetailController.heroName = stat.localizedName
            heroDetailController.heroAttr = stat.primaryAttr
            heroDetailController.heroImage =  stat.img
            heroDetailController.heroIcon = stat.icon
            heroDetailController.attackType = stat.attackType
            heroDetailController.heroBasicStatus = heroBasicStat
            heroDetailController.heroRolesDetail = stat.roles
            navigationController?.pushViewController(heroDetailController, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
            
        } else {
            let sortingVC = SortingController()
            present(UINavigationController(rootViewController: sortingVC), animated: true)
        }
    }
    
    
}

