Strict

Private

Import bono
Import mojo.app

Public

Class StateStore
    Private

    Method New()
    End

    Public

    Function Load:Void(obj:Persistable)
        obj.FromString(LoadState())
    End

    Function Save:Void(obj:Persistable)
        SaveState(obj.ToString())
    End
End
