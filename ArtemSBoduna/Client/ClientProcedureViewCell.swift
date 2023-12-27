import UIKit


final class ClientProcedureViewCell: UITableViewCell {
    static let reuseIdentifier: String = "ClientProcedureRoomViewCell"
    
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
    func setupCell(cp: ClientProcedureResponse) {
        descriptionLabel.text = "\(cp.count)\n\(cp.client.fullName)\n\(cp.procedure.name)"
    }
    
    
    //MARK: - Private Methods
    private func setupViews(){
        

        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(descriptionLabel)
        

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
    }
}





