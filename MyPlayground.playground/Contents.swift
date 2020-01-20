import UIKit

struct Position {
    let x, y : Int
}

class Node {
    var g: Int = 0
    var h: Int = 0
    var f: Int = 0
    var position: Position
    var parent: Node?
    
    init(parent: Node? = nil, position: Position) {
        self.parent = parent
        self.position = position
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        (lhs.position.x == rhs.position.x) && (lhs.position.y == rhs.position.y)
    }
}

class Algorithms {
    func astar(maze: [[Int]], start: Position, end: Position) -> [Position]? {
        let startNode = Node(position: start)
        let endNode = Node(position: end)
        var openList: [Node] = []
        var closedList: [Node] = []
        openList.append(startNode)
        
        while openList.count > 0 {
            guard
                let currentNode = openList.min(by: { $0.f < $1.f }),
                let currentIndex = openList.firstIndex(of: currentNode)
            else {
                return nil
            }
            
            openList.remove(at: currentIndex)
            closedList.append(currentNode)
            
            guard currentNode != endNode else {
                var path: [Position] = []
                var current: Node? = currentNode
                while current != nil {
                    path.append(current!.position)
                    current = current?.parent
                }
                return path.reversed()
            }

            let adjacentSquares = [
                Position(x: 0, y: -1),
                Position(x: 0, y: 1),
                Position(x: -1, y: 0),
                Position(x: 1, y: 0),
                Position(x: -1, y: -1),
                Position(x: -1, y: 1),
                Position(x: 1, y: -1),
                Position(x:1, y:1)
            ]
                        
            let children: [Node] = adjacentSquares.compactMap {
                let nodePosition = Position(x: currentNode.position.x + $0.x, y: currentNode.position.y + $0.y)
                guard
                    nodePosition.x <= (maze.count-1),
                    nodePosition.x >= 0,
                    nodePosition.y <= (maze[maze.count-1].count-1),
                    nodePosition.y >= 0,
                    maze[nodePosition.x][nodePosition.y] == 0
                else {
                    return nil
                }
                return Node(parent: currentNode, position: nodePosition)
            }
            
            children.forEach { child in
                closedList.forEach { (closedChild) in
                    guard child == closedChild else {
                        return
                    }
                }
                child.g = currentNode.g + 1
                child.h = pow2(child.position.x - endNode.position.x) + pow2(child.position.y - endNode.position.y)
                child.f = child.g + child.h
                openList.forEach { (openNode) in
                    guard (child == openNode) && (child.g > openNode.g) else {
                        return
                    }
                }
                openList.append(child)
            }
        }
        return nil
    }
    
    private func pow2(_ a: Int) -> Int {
        return Int(pow(Double(a),Double(2)))
    }
}


let maze = [
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
]

let start = Position(x: 0, y: 0)
let end = Position(x: 7, y: 6)
let astarPath = Algorithms().astar(maze: maze, start: start, end: end)
