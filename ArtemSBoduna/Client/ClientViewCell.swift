import UIKit


final class ClientViewCell: UITableViewCell {
    static let reuseIdentifier: String = "ClientRoomViewCell"
    
    //MARK: - Private Properties
    private let descriptionLabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Public Methods
    func setupCell(client: ClientResponse) {
        descriptionLabel.text = "\(client.fullName)\n\(client.phoneNumber)\n\(client.address)\nПотрачено: \(client.summa)\nНомер: \(client.livingRoom.number)"
    }
    
    
    //MARK: - Private Methods
    private func setupViews(){
        

        selectionStyle = .none
        backgroundColor = .white
        
        
        addSubview(descriptionLabel)
        

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
    }
}




