Strict

Private

Import bono
Import mojo.graphics

Public

Class Sprite Extends BaseDisplayObject Implements Updateable, Renderable
    Private

    Field currentFrame:Int
    Field frameCount:Int
    Field frameSize:Vector2D
    Field frameTimer:Int
    Field image:Image
    Field renderPos:Vector2D = New Vector2D()
    Field imageName:String
    Field baseRotation:Int
    Field _scale:Vector2D = New Vector2D(1, 1)
    Field lastScale:Vector2D = New Vector2D(1, 1)
    Global cacheImage:StringMap<Image> = New StringMap<Image>()
    Global cacheSize:StringMap<Vector2D> = New StringMap<Vector2D>()

    Public

    Field valign:Int = Align.TOP
    Field halign:Int = Align.LEFT
    Field frameSpeed:Int
    Field loopAnimation:Bool
    Field rotation:Float

    Method New(imageName:String, pos:Vector2D=Null)
        Self.imageName = imageName

        LoadImage()
    End

    Method New(imageName:String, frameSize:Vector2D, frameCount:Int, frameSpeed:Int, pos:Vector2D=Null)
        Self.imageName = imageName
        Self.frameSize = frameSize
        Self.frameCount = frameCount
        Self.frameSpeed = frameSpeed

        LoadImage()
    End

    Method New(imageName:String, image:Image, forcedSize:Vector2D = Null, baseRotation:Int = 0)
        Self.imageName = imageName
        Self.image = image
        Self.baseRotation = baseRotation

        If forcedSize
            SetSize(forcedSize)
        Else
            SetSize(New Vector2D(image.Width(), image.Height()))
        End
    End

    Method Copy:Sprite()
        Local tmp:Sprite = New Sprite(imageName, image, Null, baseRotation)
        tmp.valign = valign
        tmp.halign = halign
        tmp.frameSpeed = frameSpeed
        tmp.loopAnimation = loopAnimation
        tmp.rotation = rotation
        tmp.scale = scale

        Return tmp
    End

    Method GrabSprite:Sprite(name:String, src:Vector2D, size:Vector2D, rotation:Int = 0)
        Local img:Image = image.GrabImage(
            src.x, src.y,
            size.x, size.y,
            1,
            Image.MidHandle)

        Local forcedSize:Vector2D
        Select rotation
        Case 90, 270, -90, -270
            forcedSize = New Vector2D(size.y, size.x)
        Case 0, 180, -180
            ' nothing to do here
        Default
            Throw New InvalidArgumentException(
                "Unable to handle given rotation '" + String(rotation) + "'")
        End

        Return New Sprite(name, img, forcedSize, rotation)
    End

    Method Collide:Bool(checkPos:Vector2D)
        Local offset:Vector2D = New Vector2D()
        Align.Horizontal(offset, Self, halign)
        Align.Vertical(offset, Self, valign)

        Return Super.Collide(checkPos.Copy().Sub(offset))
    End

    Method OnRender:Void()
        GetSize().Div(lastScale).Mul(_scale)
        lastScale.Set(_scale)

        renderPos.Set(GetCenter())
        renderPos.Add(GetPosition())
        Align.Horizontal(renderPos, Self, halign)
        Align.Vertical(renderPos, Self, valign)

        GetColor().Activate()
        DrawImage(
            image,
            renderPos.x, renderPos.y,
            baseRotation + rotation,
            _scale.x, _scale.y,
            currentFrame)
        GetColor().Deactivate()
    End

    Method OnUpdate:Void(deltaTimer:DeltaTimer)
        If frameCount <= 0 Then Return
        If animationIsDone Then Return

        If frameTimer < frameSpeed
            frameTimer += deltaTimer.frameTime
            Return
        End

        If (currentFrame + 1) = frameCount
            If loopAnimation
                currentFrame = 1
            End
        Else
            currentFrame += 1
        End
        frameTimer = 0
    End

    Method Restart:Void()
        currentFrame = 0
    End

    Method animationIsDone:Bool() Property
        If loopAnimation Then Return False
        Return (currentFrame = frameCount)
    End

    Method scale:Vector2D() Property
        Return _scale
    End

    Method scale:Void(newScale:Vector2D) Property
        _scale = newScale
    End

    Method filepath:String() Property
        Return imageName
    End

    Method DrawImageRect:Void(pos:Vector2D, rectPos:Vector2D, rectSize:Vector2D)
        DrawImageRect(pos.x, pos.y, rectPos.x, rectPos.y, rectSize.x, rectSize.y)
    End

    Method DrawImageRect:Void(x:Float, y:Float, srcX:Float, srcY:Float, srcWidth:Float, srcHeight:Float)
        x += GetCenter().x
        y += GetCenter().y
        graphics.DrawImageRect(image, x, y, srcX, srcY, srcWidth, srcHeight, rotation, _scale.x, _scale.y, currentFrame)
    End

    Private

    Method CacheSet:Void(name:String, image:Image, size:Vector2D)
        cacheImage.Set(name, image)
        cacheSize.Set(name, size.Copy())
    End

    Method CacheGetSize:Vector2D(name:String)
        Return cacheSize.Get(name).Copy()
    End

    Method CacheGetImage:Image(name:String)
        Return cacheImage.Get(name)
    End

    Method LoadImage:Void()
        ' Try the cache first ...
        image = CacheGetImage(imageName)
        If image
            SetSize(CacheGetSize(imageName))
        End

        ' ... but handle misses aswell
        If Not image
            If frameSize
                image = graphics.LoadImage(imageName, frameSize.x, frameSize.y, frameCount, Image.MidHandle)
                FailIfImageNotLoaded()
                SetSize(frameSize.Copy())
            Else
                image = graphics.LoadImage(imageName, 1, Image.MidHandle)
                FailIfImageNotLoaded()
                SetSize(New Vector2D(image.Width(), image.Height()))
            End
            CacheSet(imageName, image, GetSize())
        End

        GetSize().Mul(scale)
    End

    Method FailIfImageNotLoaded:Void()
        If Not image Then Throw New RuntimeException(
            "Unable to load image file: " + imageName)
    End
End
