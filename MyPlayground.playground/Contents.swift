import UIKit

import UIKit

struct Position {
    let x,y : Int
}

class Node: Equatable {
    var g: Int = 0
    var h: Int = 0
    var f: Int = 0
    var position: Position
    var parent: Node?
    
    init(parent: Node? = nil, position: Position) {
        self.parent = parent
        self.position = position
    }
    
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
        var astarPath: [Position]? = nil
        
        while openList.count > 0 {
            
            guard
                let currentNode = openList.min(by: { $0.f < $1.f }),
                let currentIndex = openList.firstIndex(of: currentNode)
            else {
                return nil
            }
            
            openList.remove(at: currentIndex)
            closedList.append(currentNode)
            
            if currentNode == endNode {
                var path: [Position] = []
                var current: Node? = currentNode
                while current != nil {
                    path.append(current!.position)
                    current = current?.parent
                }
                astarPath = path.reversed()
                break
            }

            var children: [Node] = []
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
            
            for newPosition in adjacentSquares {
                let nodePosition = Position(x: currentNode.position.x + newPosition.x,
                                            y: currentNode.position.y + newPosition.y)
                
                if ( nodePosition.x > (maze.count-1) || nodePosition.x < 0 || nodePosition.y > (maze[maze.count-1].count-1) || nodePosition.y < 0) {
                    continue
                }
                
                if maze[nodePosition.x][nodePosition.y] != 0 {
                    continue
                }
                
                let newNode = Node(parent: currentNode, position: nodePosition)
                children.append(newNode)
            }
            
            for child in children {
                for closedChild in closedList {
                    if child == closedChild {
                        continue
                    }
                }
                child.g = currentNode.g + 1
                let a = child.position.x - endNode.position.x
                let b = child.position.y - endNode.position.y
                child.h = Int(pow(Double(a),Double(2))) + Int(pow(Double(b),Double(2)))
                child.f = child.g + child.h
                
                for openNode in openList {
                    if (child == openNode) && (child.g > openNode.g) {
                        continue
                    }
                }
                openList.append(child)
            }
            
        }
        return astarPath
        
    }
}


let maze = [[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

let start = Position(x: 0, y: 0)
let end = Position(x: 7, y: 6)

let starPath = Algorithms().astar(maze: maze, start: start, end: end)
print(starPath)
