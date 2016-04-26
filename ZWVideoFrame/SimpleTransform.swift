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

import Foundation
import CoreGraphics
import Advance

struct SimpleTransform {
    var scale: CGFloat = 1.0
    var rotation: CGFloat = 0.0
    
    init() {}
    
    init(scale: CGFloat, rotation: CGFloat) {
        self.scale = scale
        self.rotation = rotation
    }
    
    var affineTransform: CGAffineTransform {
        var t = CGAffineTransformIdentity
        t = CGAffineTransformRotate(t, rotation)
        t = CGAffineTransformScale(t, scale, scale)
        return t
    }
}

extension SimpleTransform: VectorConvertible {
    typealias Vector = Vector2
    
    var vector: Vector {
        return Vector2(Scalar(scale), Scalar(rotation))
    }
    
    init(vector: Vector) {
        scale = CGFloat(vector.x)
        rotation = CGFloat(vector.y)
    }
}

func ==(lhs: SimpleTransform, rhs: SimpleTransform) -> Bool {
    return lhs.scale == rhs.scale
        && lhs.rotation == rhs.rotation
}