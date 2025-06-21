Sub Main(args as Object)
    print "Main: Starting ListenBoise app"
    if Type(RunUserInterface) = "Function" OR Type(RunUserInterface) = "roFunction"
        print "Main: Calling RunUserInterface"
        RunUserInterface(args)
    else
        print "Main: Error - RunUserInterface not found, likely missing or invalid SGDEX.brs"
        ' Fallback to direct SceneGraph initialization
        screen = CreateObject("roSGScreen")
        m.port = CreateObject("roMessagePort")
        screen.setMessagePort(m.port)
        scene = screen.CreateScene("MainScene")
        scene.launch_args = args
        screen.show()
        print "Main: MainScene displayed (fallback mode)"
        while(true)
            msg = wait(0, m.port)
            if type(msg) = "roSGScreenEvent" and msg.isScreenClosed() then return
        end while
    end if
End Sub

Function GetSceneName() As String
    return "MainScene"
End Function