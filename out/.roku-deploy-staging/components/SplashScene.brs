Sub Init()
       print "SplashScene: Entering Init"
       m.splashPoster = m.top.FindNode("splashPoster")
       if m.splashPoster = invalid
           print "ERROR: SplashScene - splashPoster not found"
           return
       end if
       m.timer = CreateObject("roSGNode", "Timer")
       m.timer.duration = 3.0 ' 3 second
       m.timer.observeField("fire", "OnTimerFire")
       m.timer.control = "start"
       m.top.setFocus(true)
   End Sub

   Sub OnTimerFire()
       print "SplashScene: Timer fired, loading MainScene"
       m.timer.control = "stop"
       m.timer.unobserveField("fire")
       screen = CreateObject("roSGScreen")
       port = CreateObject("roMessagePort")
       screen.setMessagePort(port)
       screen.CreateScene("MainScene")
       screen.show()
       m.top.getScene().close()
   End Sub