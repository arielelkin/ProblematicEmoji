//
//  ViewController.swift
//  ProblematicTextNodeEmoji
//
//  Created by Ariel Elkin on 09/03/2018.
//  Copyright © 2018 Ariel Elkin. All rights reserved.
//
import UIKit
import AsyncDisplayKit

class Comment {
    var id:String?
    var ownerContent:String?
    var ownerCommentID:String?
    var stats:String?
    var liked:Bool = false
    var content:String?
    var author:String?
    var createdAt:Date?
    var updatedAt:Date?
    var avatarURL: URL?
    var forceCount = 0
}

class MyCommentVC: UIViewController {
    let tableNode = ASTableNode(style: .plain)

    var commentOne = Comment.init()
    var commentTwo = Comment.init()
    var commentThree = Comment.init()

    var comments: [Comment]

    func setupComments() {
        commentOne.author = "Nicki"
        commentOne.content = "Cupim kevin kielbasa meatloaf "
        commentOne.avatarURL = URL(string: "http://i.pravatar.cc/40")
        commentOne.forceCount = 10

        commentTwo.author = "Super Long Username Bacon ipsum dolor amet short loin cupim ball tip ground round, capicola fatback shankle"
        commentTwo.content = "Biltong spare ribs swine"
        commentTwo.avatarURL = URL(string: "http://baconmockup.com/40/40/")
        commentTwo.forceCount = 8000

        commentThree.author = "Freddy"
        commentThree.content = "Lorem ipsum mignon bacon prosciutto pastrami landjaeger beef ribs andouille. Strip steak kevin swine biltong, jowl meatloaf tail chuck turducken burgdoggen ball tip ham hock. Tri-tip pork chop sirloin shank"
        commentThree.avatarURL = URL(string: "http://i.pravatar.cc/40")
        commentThree.forceCount = 3

    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        comments = [commentOne, commentTwo, commentThree]

        super.init(nibName: nil, bundle: nil)

        setupComments()

        tableNode.frame = view.frame
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tableNode.dataSource = self
        tableNode.backgroundColor = UIColor.purple

        view.addSubnode(tableNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CommentCell: ASCellNode {

    fileprivate let avatarNode = ASNetworkImageNode()

    fileprivate let authorNameTextNode = ASTextNode()
    fileprivate let commentContentTextNode = ASTextNode()
    fileprivate let authorAndCommentContainerNode = ASDisplayNode()

    fileprivate let dateTextNode = ASTextNode()
    fileprivate let giveForceButtonNode = ASButtonNode()

    fileprivate let forceCountEmojiTextNode = ASTextNode()
    fileprivate let forceCountTextNode = ASTextNode()

    private let comment: Comment

    init(comment: Comment) {
        self.comment = comment
        super.init()

        automaticallyManagesSubnodes = true

        backgroundColor = UIColor.gray

        avatarNode.willDisplayNodeContentWithRenderingContext = { context, drawParameters in
            let bounds = context.boundingBoxOfClipPath
            UIBezierPath(roundedRect: bounds, cornerRadius: 25).addClip()
        }
        avatarNode.url = comment.avatarURL
        avatarNode.backgroundColor = UIColor.blue

        authorNameTextNode.attributedText = NSAttributedString(string: comment.author!)

        commentContentTextNode.attributedText = NSAttributedString(string: comment.content!)
        commentContentTextNode.maximumNumberOfLines = 0

        authorAndCommentContainerNode.backgroundColor = UIColor.red


        dateTextNode.attributedText = NSAttributedString(string: "48 min")

        giveForceButtonNode.setAttributedTitle(NSAttributedString(string: "Donner de la force"), for: .normal)

        if comment.forceCount > 0 {
            forceCountTextNode.attributedText = NSAttributedString(string: "👏 \(comment.forceCount)")
        }
        forceCountTextNode.backgroundColor = UIColor.green
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        avatarNode.style.preferredSize = CGSize(width: 40, height: 40)

        let authorAndCommentStack = ASStackLayoutSpec.vertical()
        authorAndCommentStack.children = [authorNameTextNode, commentContentTextNode]

        let authorAndCommentStackInsetBox = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
            child: authorAndCommentStack
        )

        let authorAndCommentStackInsetBoxWithBackground = ASBackgroundLayoutSpec(
            child: authorAndCommentStackInsetBox,
            background: authorAndCommentContainerNode
        )

        let dateAndForceStack = ASStackLayoutSpec.horizontal()
        dateAndForceStack.children = [dateTextNode, giveForceButtonNode]
        dateAndForceStack.spacing = 19


        let rightPortionStack = ASStackLayoutSpec.vertical()
        rightPortionStack.children = [authorAndCommentStackInsetBoxWithBackground, dateAndForceStack]



        let mainStack = ASStackLayoutSpec.horizontal()

        if comment.forceCount > 0 {

            forceCountTextNode.style.flexShrink = 1.0
            forceCountTextNode.style.flexGrow = 1.0

            let forceCountStack = ASStackLayoutSpec.vertical()
            forceCountStack.style.flexShrink = 1.0
            forceCountStack.style.flexGrow = 1.0
            forceCountStack.child = forceCountTextNode

            let forceCountInset = ASInsetLayoutSpec(
                insets: UIEdgeInsets.init(top: -4, left: CGFloat.infinity, bottom: CGFloat.infinity, right: -2),
                child: forceCountStack
            )
            forceCountInset.style.flexShrink = 1.0
            forceCountInset.style.flexGrow = 1.0

            let rightPortionStackWithForceOverlay = ASOverlayLayoutSpec(
                child: rightPortionStack,
                overlay: forceCountInset
            )

            mainStack.children = [avatarNode, rightPortionStackWithForceOverlay]

            rightPortionStackWithForceOverlay.style.flexShrink = 1.0
            rightPortionStackWithForceOverlay.style.flexGrow = 1.0

        }
        else {
            mainStack.children = [avatarNode, rightPortionStack]
            rightPortionStack.style.flexShrink = 1.0
        }


        mainStack.spacing = 5

        let mainStackInsetBox = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10),
            child: mainStack
        )

        return mainStackInsetBox
    }
}



extension MyCommentVC: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        return CommentCell.init(comment: comments[indexPath.item])
    }
}
