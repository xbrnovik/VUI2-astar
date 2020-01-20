import UIKit

import UIKit

struct Position {
    let x,y : Int
}

class Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        (lhs.position.x == rhs.position.x) && (lhs.position.y == rhs.position.y)
    }
    
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

class Algo {
    var returnedPath: [Position] = []
    
    func astar(maze: [[Int]], start: Position, end: Position) {
        let startNode = Node(position: start)
        startNode.g = 0
        startNode.h = 0
        startNode.f = 0
        let endNode = Node(position: end)
        endNode.g = 0
        endNode.h = 0
        endNode.f = 0
        var openList: [Node] = []
        var closedList: [Node] = []
        openList.append(startNode)
        
        while openList.count > 0 {
            
            guard let first = openList.first else {
                return
            }
            var currentNode = first
            var currentIndex = 0
            for (index, item) in openList.enumerated() {
                if item.f < currentNode.f {
                    currentNode = item
                    currentIndex = index-1
                }
            }
            
            openList.remove(at: currentIndex)
            closedList.append(currentNode)
            
            if currentNode == endNode {
                var path: [Position] = []
                var current: Node? = currentNode
                while (current != nil) {
                    path.append(current!.position)
                    current = current?.parent
                }
                self.returnedPath = path.reversed()
                return
            }

            var children: [Node] = []
            let adjacentSquares = [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]
            
            for newPosition in adjacentSquares {
                let nodePositionX = currentNode.position.x + newPosition.0
                let nodePositionY = currentNode.position.y + newPosition.1
                let nodePosition = Position(x: nodePositionX, y: nodePositionY)
                
                if (
                nodePosition.x > (maze.count-1) ||
                nodePosition.x < 0 ||
                nodePosition.y > (maze[maze.count-1].count-1) ||
                nodePosition.y < 0) {
                    continue
                }
                
                if maze[nodePosition.x][nodePosition.y] != 0 {
                    continue
                }
                
                let newNode = Node(parent: currentNode, position: nodePosition)
                children.append(newNode)
            }
            print(children.count)
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
                
                print(child.position)
               openList.append(child)
            }
            
        }
        
        
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

let algo = Algo()
algo.astar(maze: maze, start: start, end: end)
print(algo.returnedPath)
