import UIKit

class DetailViewControllerModel: ViewControllerModel {
    let character: Character.Character
    init(_ character: Character.Character) {
        self.character = character
    }
    
    override func controllerConnected() {
        self.viewController?.updateFromModel()
    }
}

class DetailViewController: ModelViewController<DetailViewControllerModel> {
    let backgroundImageView = ImageView(UIImage(named: "BackgroundImageNoText")!)
        .content(.scaleAspectFill)
    let contentView = View()
        .backgroundColour(UIColor.black.withAlphaComponent(1))
        .cornerRadius(8)
    let headerView = AlignmentView<UILabel>()
 
    let imgThumb = ImageView()
        .setImage(size: CGSize(width: 300, height: 300), .init(top: 4, left: 4, bottom: 4, right: 4), forceImageSizeConstraints: true)

    lazy private var btnClose = Button(image: UIImage(named: "CloseIcon")!)
        .touchUpInside({ _ in
            self.dismiss(animated: true)
        })
        .set(width: 34, height: 34)
        
    
    
    let occupationView = InfoFieldView<UILabel>(title: "Occupation")
    let statusView = InfoFieldView<UILabel>(title: "Status")
    let nicknameView = InfoFieldView<UILabel>(title: "Nickname")
    let footerView = View()
    let lbAppearedInSeasons = UILabel()
    let seasonsView = SeasonView()
    
    
    
    private lazy var stackView = StackView(.vertical, spacing: 10, [
        occupationView,
        statusView,
        nicknameView
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutMargins = .init(uniform: 4)
        contentView.layoutMargins = .init(uniform: 14)
        view.add(view: backgroundImageView)
        view.add(view: contentView, Edges(l: 10, r: 10, safeT: 20, safeB: 20))
        footerView.add(view: lbAppearedInSeasons, Edges(l: 10, cY: 0))
        footerView.add(view: seasonsView, Edges(r: 10, cY: 0))
        
        contentView.add(view: headerView, .topLeftRight)
        contentView.add(view: imgThumb, .centerX)
        contentView.add(view: stackView, .leftRightMargins)
        contentView.add(view: footerView, .bottomLeftRight)
        imgThumb.vConstrain(.top, to: headerView, .bottom)
        stackView.vConstrain(.top, to: imgThumb, .bottom, 10)
        btnClose.image(.image1)?.tintColor = .white
        headerView
            .set(height: 34)
            .backgroundColour(UIColor.black.withAlphaComponent(0.3))
            .contentView.textColor = UIColor.white.withAlphaComponent(0.68)
        

        footerView
            .set(height: 34)
            .backgroundColour(UIColor.black.withAlphaComponent(0.14))
        
        lbAppearedInSeasons.textColor = UIColor.white.withAlphaComponent(0.68)
        
        headerView.add(view: btnClose, Edges(r: 4, cY: 0))
        
        [occupationView, statusView, nicknameView].forEach{ infoView in
            infoView.contentView.numberOfLines = 0
            infoView.contentView.textColor = UIColor.white.withAlphaComponent(0.8)
            infoView.lbTitle.textColor = UIColor.white.withAlphaComponent(0.68)
        }
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.14)
    }
    
    override func updateFromModel() {
        guard let model = model?.character else { return }
        imgThumb.image = UIImage(named: "Placeholder")
        imgThumb.imageURL = URL(string: model.img)
        headerView.contentView.text = model.name
        occupationView.contentView.text = model.occupation.joined(separator: ", ")
        statusView.contentView.text = model.status.rawValue
        nicknameView.contentView.text = model.nickname
        seasonsView.seasons = model.appearance
        lbAppearedInSeasons.text = "Seasons:"
    }
}

