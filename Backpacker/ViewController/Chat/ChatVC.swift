//
//  ChatVC.swift
//  Backpacker
//
//  Created by Mobile on 15/07/25.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lbl_ActiveStatus: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    var chatMessages: [ChatMessage] = [
        ChatMessage(sender: .user, message: "Hi, I’m interested in the job.", time: "10:00 AM"),
        ChatMessage(sender: .employer, message: "Thanks for reaching out!", time: "10:01 AM"),
        ChatMessage(sender: .user, message: "Can we schedule an interview?", time: "10:02 AM"),
        ChatMessage(sender: .employer, message: "Sure, does 3 PM work for you?", time: "10:03 AM"),
        ChatMessage(sender: .user, message: "Yes, that works. Thank you!", time: "10:04 AM"),
        
        // Long message
        ChatMessage(sender: .employer, message: """
        Thank you for confirming your availability. The interview will be held via Zoom and will last approximately 45 minutes. Please ensure you have a stable internet connection, a quiet environment, and your resume handy. You’ll be speaking with two team members from the engineering department. If you have any questions before the meeting, feel free to reach out.
        """, time: "10:05 AM"),
        
        ChatMessage(sender: .user, message: "Got it. See you then.", time: "10:06 AM"),
        ChatMessage(sender: .employer, message: "Looking forward to it.", time: "10:07 AM"),
        
        // Long message
        ChatMessage(sender: .user, message: """
        Before we meet, I just wanted to confirm whether there’s anything specific I should prepare or review ahead of the interview. I'm really excited about the opportunity and want to make sure I’m fully ready to discuss my background, relevant projects, and how I can contribute to your team effectively.
        """, time: "10:08 AM"),
        
        ChatMessage(sender: .employer, message: "No special prep is needed—just be yourself and walk us through your experience.", time: "10:09 AM"),
        
        // Long message
        ChatMessage(sender: .user, message: """
        Thank you so much! I really appreciate the transparency and the opportunity to speak with your team. I've looked into your recent product updates and find them incredibly impressive. I’m particularly interested in how your platform scales across different regions and manages real-time data synchronization.
        """, time: "10:10 AM"),
        
        ChatMessage(sender: .employer, message: "That’s great to hear! We’ll touch on some of those topics in the interview.", time: "10:11 AM"),
        ChatMessage(sender: .user, message: "Awesome, looking forward to it.", time: "10:12 AM"),
        
        // Long message
        ChatMessage(sender: .employer, message: """
        Thanks for joining the interview yesterday. It was a pleasure speaking with you and learning more about your background. The panel was especially impressed with your communication skills and the clarity in how you explained your previous project responsibilities. We will now move forward with the internal review and should be in touch with next steps by Friday.
        """, time: "11:00 AM"),

        ChatMessage(sender: .employer, message: """
        After reviewing your profile and interview feedback, we're confident that your skillset aligns well with the role. You demonstrated strong problem-solving abilities, and your understanding of scalable systems really stood out. Our next step involves a short task round to evaluate your hands-on approach. We'll send details via email shortly.
        """, time: "11:01 AM"),

        ChatMessage(sender: .employer, message: """
        We appreciate your interest in joining our team. Your passion for technology and your proactive attitude were evident throughout the discussion. Our culture values individuals who are collaborative, detail-oriented, and eager to learn—all qualities you seem to embody. Expect a follow-up message from HR with the official offer documents and onboarding information.
        """, time: "11:02 AM"),
        ChatMessage(sender: .user, message: "That’s wonderful to hear. Thanks for the update!", time: "11:01 AM"),
        ChatMessage(sender: .employer, message: "You're welcome. Talk soon!", time: "11:02 AM"),
        
        // Long message
        ChatMessage(sender: .user, message: """
        Hello again! I just wanted to say that I truly enjoyed the entire interview process. Every conversation I had was insightful, and the passion your team has for the product really stood out. No matter the outcome, I'm grateful for the opportunity and hope to keep in touch going forward.
        """, time: "11:03 AM"),
        
        ChatMessage(sender: .employer, message: "That means a lot—thank you! We'll be in touch soon.", time: "11:04 AM")
    ]

    
    var chatMessageList = [ChatMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
    }
    

    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setUpUI(){
        self.chatMessageList = chatMessages
        self.lbl_UserName.font = FontManager.inter(.medium, size: 12.0)
        self.lbl_ActiveStatus.font = FontManager.inter(.medium, size: 10.0)
        let nib = UINib(nibName: "UserChatTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "UserChatTVC")
        
        let Enib = UINib(nibName: "EmplyerChatTVC", bundle: nil)
        self.tblVw.register(Enib, forCellReuseIdentifier: "EmplyerChatTVC")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
    }

}


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Replace with your actual data source count
        return  self.chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat =  self.chatMessageList[indexPath.row]
        // Show image only for the last message in a block of same sender
            let shouldShowImage: Bool = {
                // If it's the last message in the list, show image
                guard indexPath.row < chatMessageList.count - 1 else { return true }
                // Show image if next message is from different sender
                return chat.sender != chatMessageList[indexPath.row + 1].sender
            }()

        
        
        switch chat.sender {
        case .user:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatTVC", for: indexPath) as? UserChatTVC else {
                return UITableViewCell()
            }
            cell.txtMsg.text = chat.message
            cell.lbl_Tim.text = chat.time
            return cell

        case .employer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmplyerChatTVC", for: indexPath) as? EmplyerChatTVC else {
                return UITableViewCell()
            }
            cell.txtLbl.text = chat.message
            cell.lbl_Time.text = chat.time
            cell.handleAppearanceForImage(isShow: shouldShowImage) // <- implement this
            return cell
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

struct ChatMessage {
    let sender: SenderType
    let message: String
    let time: String
}
enum SenderType {
    case user
    case employer
}
