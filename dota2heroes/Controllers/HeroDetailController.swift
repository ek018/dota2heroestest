import UIKit
import Kingfisher


class HeroDetailController: BaseViewController {
    var heroRolesDetail: [String]?
    var heroBasicStatus: [HeroBaseStatModel]?
    var attackType: String?
    var heroName: String?
    var heroImage: String?
    var heroIcon: String?
    var heroAttr: String?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    
    lazy var heroThumbnailImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.frame.width,
                                 height: view.frame.height*0.5)
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var heroTitleView: HeroTitleDetailView = {
        let heroTitle = HeroTitleDetailView()
        heroTitle.translatesAutoresizingMaskIntoConstraints = false
        heroTitle.clipsToBounds = true
        heroTitle.backgroundColor = .white

        return heroTitle
    }()
    
    lazy var heroTypeDetailView: HeroTypeDetail = {
       let heroTypeDetailView = HeroTypeDetail()
        heroTypeDetailView.translatesAutoresizingMaskIntoConstraints = false
        heroTypeDetailView.backgroundColor = .white
        return heroTypeDetailView
    }()
    
    lazy var heroStatusDetailViewCell: UITableView = {
       let heroStatusDetailViewCell = UITableView()
        heroStatusDetailViewCell.translatesAutoresizingMaskIntoConstraints = false
        
        return heroStatusDetailViewCell
    }()
    
    lazy var heroRolesDetailViewCell: UITableView = {
       let heroRolesDetailView = UITableView()
        heroRolesDetailView.translatesAutoresizingMaskIntoConstraints = false
        return heroRolesDetailView
    }()
    
    override func loadView() {
        super.loadView()
        setupViews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.heroName
        view.backgroundColor = .backgroundColor
        setupConstrains()
        bindDataToUIView()
    }
    
    func setupViews() {
        // scrollview
        view.addSubview(scrollView)
        // contentview
        scrollView.addSubview(contentView)
        // image thumbnail
        contentView.addSubview(heroThumbnailImage)
        // heroTitle
        contentView.addSubview(heroTitleView)
        // heroTypeDetail
        contentView.addSubview(heroTypeDetailView)
        // heroStatus
        contentView.addSubview(heroStatusDetailViewCell)
        heroStatusDetailViewCell.delegate = self
        heroStatusDetailViewCell.dataSource = self
        heroStatusDetailViewCell.allowsSelection = false
        heroStatusDetailViewCell.register(UINib(nibName: "HeroStatDetailViewCell", bundle: nil), forCellReuseIdentifier: "HeroStatDetailViewCell")
        heroStatusDetailViewCell.rowHeight = UITableView.automaticDimension
        heroStatusDetailViewCell.estimatedRowHeight = UITableView.automaticDimension
        // hero roles
        contentView.addSubview(heroRolesDetailViewCell)
        heroRolesDetailViewCell.delegate = self
        heroRolesDetailViewCell.dataSource = self
        heroRolesDetailViewCell.allowsSelection = false
        heroRolesDetailViewCell.register(UINib(nibName: "HeroRolesDetailViewCell", bundle: nil), forCellReuseIdentifier: "HeroRolesDetailViewCell")
        heroRolesDetailViewCell.rowHeight = UITableView.automaticDimension
        heroRolesDetailViewCell.estimatedRowHeight = UITableView.automaticDimension
        
        
    }
    
    func setupConstrains() {
        // scrollview
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // contentview
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        let contentViewHeightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightAnchor.priority = .defaultLow
        contentViewHeightAnchor.isActive = true
        
        // image thumbnail
        heroThumbnailImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        heroThumbnailImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        heroThumbnailImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        heroThumbnailImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
       
        // hero title
        heroTitleView.topAnchor.constraint(equalTo: heroThumbnailImage.bottomAnchor, constant: 24).isActive = true
        heroTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        heroTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        // hero type
        heroTypeDetailView.topAnchor.constraint(equalTo: heroTitleView.bottomAnchor, constant: 24).isActive = true
        heroTypeDetailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        heroTypeDetailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        // hero status
        heroStatusDetailViewCell.topAnchor.constraint(equalTo: heroTypeDetailView.bottomAnchor, constant: 24).isActive = true
        heroStatusDetailViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        heroStatusDetailViewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        // hero roles
        heroRolesDetailViewCell.topAnchor.constraint(equalTo: heroStatusDetailViewCell.bottomAnchor, constant: 24).isActive = true
        heroRolesDetailViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        heroRolesDetailViewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        heroRolesDetailViewCell.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func bindDataToUIView() {
        DispatchQueue.main.async {
            [weak self] in guard let self = self else { return }
            print("url img \(self.heroImage)")
            self.heroThumbnailImage.kf.setImage(with: URL(string: self.heroImage ?? ""))
            self.heroTitleView.heroIconImage.kf.setImage(with: URL(string: self.heroIcon ?? ""))
            self.heroTitleView.titleLabel.text = self.heroName
            self.heroTitleView.subtitleLabel.text = self.heroAttr?.uppercased()
            self.heroTypeDetailView.subtitleLabel.text = self.attackType
            
            self.heroStatusDetailViewCell.reloadData()
            self.heroRolesDetailViewCell.reloadData()
        }
    }
}

extension HeroDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.heroRolesDetailViewCell {
            return heroRolesDetail?.count ?? 0
        }
        return heroBasicStatus?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.heroRolesDetailViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeroRolesDetailViewCell") as? HeroRolesDetailViewCell
            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
            if let cell = cell {
                cell.titleLabel.text = heroRolesDetail?[indexPath.row]
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeroStatDetailViewCell") as? HeroStatDetailViewCell
            tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
            if let cell = cell {
                let heroBaseData = heroBasicStatus?[indexPath.row]
                cell.heroBaseStatImage.backgroundColor = .gray
                cell.heroBaseStatImage.image = UIImage(named: heroBasicStatus?[indexPath.row].icon ?? "house")
                cell.heroBaseTitleLabel.text = heroBaseData?.baseStatus
                
                guard let statusData = heroBaseData?.baseStatusData else {
                    return UITableViewCell()
                }
                cell.heroBaseDataSubtitleLabel.text = String(statusData)
                return cell
            }
        }
        
        
        return UITableViewCell()
    }
    
    
}
