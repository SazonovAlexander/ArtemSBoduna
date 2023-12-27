import UIKit


final class SelectProcedureRoomViewController: UIViewController {
    
    //MARK: - Private Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.separatorColor = .black
        return tableView
    }()
    
    var cellDataSource: [ProcedureRoomResponse] = []
    private let service = ProcedureRoomService()
    weak var delegate: SelectProcedureRoomDelegate?
    private var currentPage = 0
    private let itemsPerPage = 20
    private var inLoad = false
    private var isEnd = false {
        didSet {
            if isEnd == false {
                currentPage = 0
                cellDataSource = []
                getRooms()
            }
        }
    }
    //MARK: - Override methods
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}


//MARK: - Private Methods
private extension SelectProcedureRoomViewController {
    
    func setupView() {
        view.backgroundColor = .darkGray
        setupTableView()
        addSubviews()
        activateConstraints()
        getRooms()
    }

    func getRooms() {
        inLoad.toggle()
        service.fetchAllProcedureRoom(page: currentPage, count: itemsPerPage, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let rooms):
                if !rooms.isEmpty {
                    currentPage += 1
                }
                else {
                    isEnd = true
                }
                self.cellDataSource.append(contentsOf: rooms)
                inLoad.toggle()
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                inLoad.toggle()
                let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
                self.present(alert, animated: true)
            }
        })
    }
    

    
    
    func addSubviews(){
        view.addSubview(tableView)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
    }
    
    func registerCell() {
        tableView.register(ProcedureRoomViewCell.self, forCellReuseIdentifier: ProcedureRoomViewCell.reuseIdentifier)
    }
    
}


//MARK: - UITableViewDelegate
extension SelectProcedureRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectProcedureRoom(cellDataSource[indexPath.row])
        dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height && !inLoad && !isEnd{
            getRooms()
        }
    }
    
}

//MARK: - UITableViewDataSource
extension SelectProcedureRoomViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProcedureRoomViewCell.reuseIdentifier, for: indexPath) as? ProcedureRoomViewCell else { return UITableViewCell() }
            let room = cellDataSource[indexPath.row]
        cell.setupCell(room: room)
        return cell
    }
    
}


protocol SelectProcedureRoomDelegate: AnyObject {
    
    func selectProcedureRoom(_ room: ProcedureRoomResponse)
    
}
