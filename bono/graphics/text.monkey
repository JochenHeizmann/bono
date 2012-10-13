Strict

Private

Import bono.graphics
Import bono.kernel
Import bono.utils
Import bono.vendor.angelfont
Import basedisplayobject

Public

Class Text Extends BaseDisplayObject Implements AppObserver
    Private

    Global angelFontStore:StringMap<AngelFont> = New StringMap<AngelFont>()
    Field name:String
    Field _align:Int = ALIGN_LEFT
    Field _text:String = ""

    Public

    Const ALIGN_LEFT:Int = AngelFont.ALIGN_LEFT
    Const ALIGN_CENTER:Int = AngelFont.ALIGN_CENTER
    Const ALIGN_RIGHT:Int = AngelFont.ALIGN_RIGHT

    Method New(name:String, pos:Vector2D=Null)
        If pos = Null Then pos = New Vector2D(0, 0)

        Self.name = name
        Self.pos = pos
    End

    Method OnCreate:Void()
        If Not angelFontStore.Contains(name)
            angelFontStore.Set(name, New AngelFont())
            angelFontStore.Get(name).LoadFont(name)
        End

        text = _text
    End

    Method OnLoading:Void()
    End

    Method OnRender:Void()
        If color Then color.Activate()
        angelFont.DrawText(_text, pos.x, pos.y, _align)
        If color Then color.Deactivate()
    End

    Method OnResume:Void()
    End

    Method OnSuspend:Void()
    End

    Method OnUpdate:Void(deltaTimer:DeltaTimer)
    End

    Method TextWidth:Int(char:String)
        Return angelFont.TextWidth(char)
    End

    Method TextHeight:Int(char:String)
        Return angelFont.TextHeight(char)
    End

    Method text:Void(newText:String) Property
        _text = newText
        If Not angelFont Then Return

        Local width:Float = angelFont.TextWidth(newText)
        Local height:Float = angelFont.TextHeight(newText)
        size = New Vector2D(width, height)
    End

    Method text:String() Property
        Return _text
    End

    Method align:Void(newAlign:Int) Property
        Select newAlign
        Case ALIGN_LEFT, ALIGN_CENTER, ALIGN_RIGHT
            _align = newAlign
        Default
            Error("Invalid align value specified.")
        End
    End

    Method align:Int() Property
        Return _align
    End

    Private

    Method angelFont:AngelFont() Property
        Return angelFontStore.Get(name)
    End
End