Strict

Private

Import bono

Public

Class Align Abstract
    Const TOP:Int = 0
    Const BOTTOM:Int = 1
    Const LEFT:Int = 2
    Const RIGHT:Int = 3
    Const CENTER:Int = 4

    Function Horizontal:Void(pos:Vector2D, obj:Sizeable, mode:Int)
        Select mode
        Case LEFT
            ' Default alignment - nothing to do here
        Case RIGHT
            pos.x -= obj.GetSize().x
        Case CENTER
            pos.x -= obj.GetSize().x / 2
        Default
            Error("Invalid alignment mode (" + mode + ") given")
        End
    End

    Function Vertical:Void(pos:Vector2D, obj:Sizeable, mode:Int)
        Select mode
        Case TOP
            ' Default alignment - nothing to do here
        Case BOTTOM
            pos.y -= obj.GetSize().y
        Case CENTER
            pos.y -= obj.GetSize().y / 2
        Default
            Error("Invalid alignment mode (" + mode + ") given")
        End
    End

    Function Centered:Void(pos:Vector2D, obj:Sizeable)
        Horizontal(pos, obj, CENTER)
        Vertical(pos, obj, CENTER)
    End
End
