# JSONLayout
iOS Auto Layout with JSON and VFL

How to define layout in JSON:
```json
{
    "views": {
        "V1": {
            "type": "UIView",
            "children": {
                "L1": {
                    "type": "UILabel"
                }
            }
        },
        "V2": {
            "type": "UIView",
            "children": {
                "L2": {
                    "type": "UILabel"
                }
            }
        }
    },
    "metrics": {
        "M1": 20.0,
        "M2": 100.0,
    },
    "constraints": {
        "C1": "H:|-M2-[V1(220)]",
        "C2": "H:|-M2-[V2(130)]",
        "C3": "V:|-M2-[V1(120)]-50-[V2(==V1)]",
        "C4": "H:|-M1-[L1(30)]",
        "C5": "H:|-M1-[L2(30)]",
        "C6": "V:|-M1-[L1(30)]",
        "C7": "V:|-M1-[L2(30)]"
    }
}
```
How to use it in code:
```swift
import JSONLayout

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        try? Layout(name: "layout").inflate(in: view)        
        view.findViewByID("V1")?.backgroundColor = UIColor.blue
        view.findViewByID("V2")?.backgroundColor = UIColor.yellow
        view.findViewByID("L1")?.backgroundColor = UIColor.green
        view.findViewByID("L2")?.backgroundColor = UIColor.red
    }

}
```
![alt JSONLayout](https://github.com/maxvol/JSONLayout/blob/master/JSONLayout.jpg?raw=true)

Carthage setup:
```
github "maxvol/JSONLayout" ~> 0.0.1
```
