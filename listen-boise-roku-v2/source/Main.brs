Sub Main()
       print "Starting Main: Creating roSGScreen"
       screen = CreateObject("roSGScreen")
       if screen = invalid
           print "ERROR: Failed to create roSGScreen"
           return
       end if
       
       m.port = CreateObject("roMessagePort")
       screen.setMessagePort(m.port)
       
       print "Creating StreamScene"
       scene = screen.CreateScene("StreamScene")
       if scene = invalid
           print "ERROR: Failed to create StreamScene"
           return
       end if
       
       print "Showing screen"
       screen.show()
       
       while(true)
           msg = wait(0, m.port)
           msgType = type(msg)
           print "Received message: "; msgType
           if msgType = "roSGScreenEvent"
               if msg.isScreenClosed() then
                   print "Screen closed, exiting"
                   return
               end if
           end if
       end while
   End Sub