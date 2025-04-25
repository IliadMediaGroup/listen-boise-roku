' main.brs
Sub Main()
    print "Starting Main: Creating roSGScreen"
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.SetMessagePort(m.port)
    
    print "Creating MainScene"
    scene = screen.CreateScene("MainScene")
    screen.Show()
    
    print "Showing screen"
    while(true)
        msg = wait(0, m.port)
        if type(msg) = "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        end if
    end while
End Sub