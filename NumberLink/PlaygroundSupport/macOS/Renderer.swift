import Cocoa

extension Board: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        let base = NSView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: CGFloat(size.width) * Const.squareSize.width + Const.lineWidth,
                height: CGFloat(size.height) * Const.squareSize.height + Const.lineWidth
            )
        )

        for row in 0...size.width {
            addLine(
                base: base,
                index: row,
                interval: (x: Const.squareSize.width, y: 0),
                size: CGSize(width: Const.lineWidth, height: base.frame.size.height)
            )
        }

        for column in 0...size.height {
            addLine(
                base: base,
                index: column,
                interval: (x: 0, y: Const.squareSize.height),
                size: CGSize(width: base.frame.size.width, height: Const.lineWidth)
            )
        }
        
        for pin in pins {
            addPin(base: base, pin: pin)
        }

        return base
    }
    
    private func addLine(base: NSView, index: Int, interval: (x: CGFloat, y: CGFloat), size: CGSize) {
        let line = NSView(
            frame: CGRect(
                x: CGFloat(index) * interval.x,
                y: CGFloat(index) * interval.y,
                width: size.width,
                height: size.height
            )
        )

        line.wantsLayer = true
        line.layer?.backgroundColor = CGColor.white

        base.addSubview(line)
    }

    private func addPin(base: NSView, pin: Pin) {
        let width = Const.squareSize.width - Const.lineWidth
        let height = Const.fontSize * 1.2

        for position in pin.pairs {
            let label = NSTextField(
                frame: CGRect(
                    x: CGFloat(position.rawValue % size.width) * Const.squareSize.width + Const.lineWidth,
                    y: CGFloat(size.height - position.rawValue / size.width - 1) * Const.squareSize.height + Const.lineWidth + (Const.squareSize.height - Const.lineWidth - height) / 2.0,
                    width: width,
                    height: height
                )
            )

            label.drawsBackground = false
            label.isBordered = false
            label.isEditable = false
            label.isSelectable = false
            label.stringValue = "\(pin.id.rawValue)"
            label.font = NSFont.systemFont(ofSize: Const.fontSize)
            label.textColor = Const.textColorSet[(pin.id.rawValue - 1) % Const.textColorSet.count]
            label.alignment = .center

            base.addSubview(label)
        }
    }

    private enum Const {
        static let lineWidth: CGFloat = 1.0
        static let squareSize: CGSize = CGSize(width: 49 + Const.lineWidth, height: 49 + Const.lineWidth)
        static let fontSize: CGFloat = 24
        static let textColorSet: [NSColor] = [.green, .cyan, .yellow, .magenta, .orange]
    }
}
