import Foundation

class Block {
    let author: String
    let data: String
    let dataHash: String
    let hash: String
    let height: Int
    let next: String
    let nonce: Int
    let previous: String
    let receivedAt: Int
    let receivedFrom: String
    let signature: String
    let timestamp: Int
    
    init(
        author: String,
        data: String,
        dataHash: String,
        hash: String,
        height: Int,
        next: String,
        nonce: Int,
        previous: String,
        receivedAt: Int,
        receivedFrom: String,
        signature: String,
        timestamp: Int
    ) {
        self.author = author
        self.data = data
        self.dataHash = dataHash
        self.hash = hash
        self.height = height
        self.next = next
        self.nonce = nonce
        self.previous = previous
        self.receivedAt = receivedAt
        self.receivedFrom = receivedFrom
        self.signature = signature
        self.timestamp = timestamp
    }
}
