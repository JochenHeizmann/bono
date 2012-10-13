Strict

Private

Import sceneable
Import bono.kernel

Public

Class SceneManager Implements AppObserver
    Private

    Field scenes:StringMap<Sceneable> = New StringMap<Sceneable>()
    Field created:StringSet = New StringSet()
    Field onCreateCaught:Bool
    Field pendingGoto:String
    Field _current:Sceneable
    Field _currentName:String
    Field _previous:Sceneable
    Field _previousName:String

    Public

    Field appEmitter:AppEmitter
    Field keyEmitter:KeyEmitter
    Field touchEmitter:TouchEmitter

    Method OnCreate:Void()
        onCreateCaught = True
        appEmitter.RemoveObserver(Self)

        If pendingGoto.Length() > 0
            Goto(pendingGoto)
            pendingGoto = ""
        End
    End

    Method OnLoading:Void()
    End

    Method OnUpdate:Void(deltatimer:DeltaTimer)
    End

    Method OnRender:Void()
    End

    Method OnResume:Void()
    End

    Method OnSuspend:Void()
    End

    Method New(fps:Int=AppEmitter.DEFAULT_FPS)
        touchEmitter = New TouchEmitter()
        keyEmitter = New KeyEmitter()
        appEmitter = New AppEmitter(fps)
        appEmitter.AddObserver(keyEmitter)
        appEmitter.AddObserver(touchEmitter)
        appEmitter.AddObserver(Self)
        appEmitter.Run()
    End

    Method Add:Void(name:String, scene:Sceneable)
        If scenes.Contains(name)
            Error("There is already a scene named: " + name)
        End

        scenes.Set(name, scene)
        scene.SetSceneManager(Self)
    End

    Method Get:Sceneable(name:String)
        If Not scenes.Contains(name)
            Error("Unknown scene name given: " + name)
        End

        Return scenes.Get(name)
    End

    Method Goto:Void(name:String)
        If name = _currentName Then Return
        If Not onCreateCaught
            pendingGoto = name
            Return
        End

        ChangeCurrentAndPrevious(name)
        HandlePreviousLeave()
        HandleCurrentEnter()
    End

    Method current:Sceneable() Property
        Return _current
    End

    Method currentName:String() Property
        Return _currentName
    End

    Method previous:Sceneable() Property
        Return _previous
    End

    Method previousName:String() Property
        Return _previousName
    End

    Private

    Method ChangeCurrentAndPrevious:Void(name:String)
        _previous = _current
        _previousName = _currentName

        _current = Get(name)
        _currentName = name
    End

    Method HandlePreviousLeave:Void()
        If Not _previous Then Return

        _previous.OnSceneLeave()
        If AppObserver(_previous) Then appEmitter.RemoveObserver(AppObserver(_previous))
        If KeyObserver(_previous) Then keyEmitter.RemoveObserver(KeyObserver(_previous))
        If TouchObserver(_previous) Then touchEmitter.RemoveObserver(TouchObserver(_previous))
    End

    Method HandleCurrentEnter:Void()
        If Not created.Contains(_currentName) Then
            AppObserver(_current).OnCreate()
            created.Insert(_currentName)
        End

        _current.OnSceneEnter()
        If AppObserver(_previous) Then appEmitter.AddObserver(AppObserver(_previous))
        If KeyObserver(_previous) Then keyEmitter.AddObserver(KeyObserver(_previous))
        If TouchObserver(_previous) Then touchEmitter.AddObserver(TouchObserver(_previous))
    End
End