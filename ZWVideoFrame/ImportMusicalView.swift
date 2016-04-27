/*

Copyright (c) 2016, Storehouse Media Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

import UIKit
import PureLayout

final class ImportMusicalView: UIView {
    
    let importButton = UIButton()
    
    let waveformView = UIView()

    
    override init(frame: CGRect) {
         super.init(frame: frame)
        
        importButton.tintColor = UIColor.whiteColor()
        importButton.setBackgroundImage(UIImage.init(imageLiteral: "songchart"), forState: UIControlState.Normal)
        importButton.setBackgroundImage(UIImage.init(imageLiteral: "songchart"), forState: UIControlState.Selected)
        importButton.layer.masksToBounds = true;
        importButton.layer.cornerRadius = 2.0;
        importButton.sizeToFit()
        
        addSubview(importButton)
        addSubview(waveformView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    override func updateConstraints() {
        super.updateConstraints()

        
        importButton.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 4)
        importButton.autoPinEdgeToSuperviewEdge(ALEdge.Top ,withInset: 4)
        importButton.autoSetDimension(ALDimension.Width, toSize: 36)
        importButton.autoSetDimension(ALDimension.Height, toSize: 36)
        
        waveformView.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: importButton, withOffset: 4)
        waveformView.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 4)
        waveformView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        waveformView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        
    }
    
}
