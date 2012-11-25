Strict

Private

Import paymentprovider
Import paymentprovideralias

Public

Class PaymentManager
    Private

    Field provider:PaymentProvider
    Global instance:PaymentManager

    Public

    Field idPrefix:String = ""
    Field idAlias:StringMap<String> = New StringMap<String>()

    Method New(provider:PaymentProvider)
        Self.provider = provider
    End

    Method IsPurchased:Bool(id:String)
        Local result:Bool = GetProvider().IsPurchased(ResolveId(id))

        If result
            DebugLog("IsPurchased", ResolveId(id) + " => True")
        Else
            DebugLog("IsPurchased", ResolveId(id) + " => False")
        End

        Return result
    End

    Method Purchase:Void(id:String)
        DebugLog("Purchase", ResolveId(id))
        GetProvider().Purchase(ResolveId(id))
    End

    Method IsProcessing:Bool()
        Return GetProvider().IsProcessing()
    End

    Method RestorePreviousPurchases:Void()
        #If TARGET="ios"
        DebugLog("RestorePreviousPurchases")
        PaymentProviderAlias(GetProvider()).RestorePreviousPurchases()
        #End
    End

    Method GetProvider:PaymentProvider()
        Return provider
    End

    Function GetInstance:PaymentManager()
        If Not instance
            instance = New PaymentManager(New PaymentProviderAlias())
        End

        Return instance
    End

    Private

    Method ResolveId:String(id:String)
        If idAlias.Contains(id)
            Return idPrefix + idAlias.Get(id)
        Else
            Return idPrefix + id
        End
    End

    Method DebugLog:Void(func:String, message:String="")
        #If CONFIG="debug"
        Print "[PaymentManager " + func + "] " + message
        #End
    End
End
