import UIKit
class ListViewControllerModel: ViewControllerModel {
    var characters = [Character.Character]()
}
class ListViewController: ModelViewController<ListViewControllerModel> {
    let tableView = UITableView()
    
    struct Constants {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updateFromModel() {
        guard let model = model else { return }
        
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.characters.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
