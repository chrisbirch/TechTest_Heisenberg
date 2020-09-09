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
    let backgroundImageView = ImageView(UIImage(named: "BackgroundImage")!)
        .content(.scaleAspectFill)
    let backgroundObscureView = View()
        .backgroundColour(UIColor.black.withAlphaComponent(1))
    let imgThumb = ImageView()
        .setImage(size: CGSize(width: 150, height: 150), .init(top: 4, left: 4, bottom: 4, right: 4), forceImageSizeConstraints: true)
    let lbName = UILabel()
    let lbOccupation = UILabel()
    let lbNickname = UILabel()
    let lbStatus = UILabel()
    let lbAppearedInSeasons = UILabel()
    
    private lazy var stackView = StackView(.vertical, spacing: 10, [
        lbName,
        lbOccupation,
        lbStatus,
        lbNickname,
        lbAppearedInSeasons
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutMargins = .init(uniform: 10)
        view.add(view: backgroundImageView)
        view.add(view: backgroundObscureView)
        view.add(view: stackView, .leftRightMargins)
        
        stackView.vConstrain(.top, to: view, .top)
        [lbName, lbOccupation, lbStatus, lbNickname, lbAppearedInSeasons].forEach{$0.textColor = .white}
        backgroundObscureView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        view.add(view: imgThumb, Edges(l: 10, r: 10, t: 10))

    }
    
    override func updateFromModel() {
        guard let model = model?.character else { return }
        imgThumb.image = UIImage(named: "Placeholder")
        imgThumb.imageURL = URL(string: model.img)
        lbName.text = model.name
        lbOccupation.text = model.occupation.joined(separator: ",")
        lbStatus.text = model.status.rawValue
        lbNickname.text = model.nickname
        lbAppearedInSeasons.text = model.appearance.map{"\($0)"}.joined(separator: ",")
    }
}

