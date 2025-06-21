Sub init()
    print "SplashScene: Entering init"
    m.timer = m.top.findNode("splashTimer")
    if m.timer <> invalid
        m.timer.observeField("fire", "onTimerFired")
        m.timer.control = "start"
        print "SplashScene: Timer started, duration: " + m.timer.duration.ToStr()
    else
        print "SplashScene: Error - splashTimer is invalid"
    end if
    m.top.SetFocus(true)
    print "SplashScene: Focus set to SplashScene"
End Sub

Sub onTimerFired()
    print "SplashScene: Timer fired"
    m.top.splashComplete = true
End Sub