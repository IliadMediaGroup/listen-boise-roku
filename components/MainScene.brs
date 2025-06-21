Sub init()
    print "MainScene: Entering init"
    
    m.buttonBar = m.top.findNode("buttonBar")
    m.buttonBar.visible = false
    print "MainScene: ButtonBar initialized, set to invisible"
    
    m.splashScene = m.top.findNode("splashScene")
    m.splashScene.observeField("splashComplete", "onSplashComplete")
    print "MainScene: Initialized, showing SplashScene, observing splashComplete"
End Sub

Sub show(args as Object)
    print "MainScene: Show called, args = "; args
    
    m.top.currentView = m.splashScene
    m.splashScene.SetFocus(true)
    print "MainScene: Show - Restored focus to SplashScene"
End Sub

Sub onSplashComplete()
    print "MainScene: onSplashComplete called"
    
    m.splashScene.visible = false
    print "MainScene: Hiding SplashScene"
    
    print "MainScene: Creating ListenLiveView"
    m.listenLiveView = m.top.createChild("ListenLiveView")
    
    m.contentNode = CreateObject("roSGNode", "ContentNode")
    
    ' Row 1
    row1 = m.contentNode.CreateChild("ContentNode")
    item1 = row1.CreateChild("ContentNode")
    item1.title = "KOOL 101.5"
    item1.HDPosterUrl = "pkg:/images/kool.png"
    item1.streamUrl = "https://ice5.securenetsystems.net/KKOO"
    item1.metadataUrl = "https://somafm.com/kool/songhistory.html"
    
    item2 = row1.CreateChild("ContentNode")
    item2.title = "The Bull 99.1"
    item2.HDPosterUrl = "pkg:/images/bull.png"
    item2.streamUrl = "https://ice5.securenetsystems.net/KBQI"
    item2.metadataUrl = "https://somafm.com/bull/songhistory.html"
    
    item3 = row1.CreateChild("ContentNode")
    item3.title = "My Country 96.1"
    item3.HDPosterUrl = "pkg:/images/my.png"
    item3.streamUrl = "https://ice5.securenetsystems.net/KYBB"
    item3.metadataUrl = "https://somafm.com/my/songhistory.html"
    
    item4 = row1.CreateChild("ContentNode")
    item4.title = "I-Rock 93.5"
    item4.HDPosterUrl = "pkg:/images/irock.png"
    item4.streamUrl = "https://ice5.securenetsystems.net/KRCK"
    item4.metadataUrl = "https://somafm.com/irock/songhistory.html"
    
    ' Row 2
    row2 = m.contentNode.CreateChild("ContentNode")
    item5 = row2.CreateChild("ContentNode")
    item5.title = "The Fox 94.5"
    item5.HDPosterUrl = "pkg:/images/fox.png"
    item5.streamUrl = "https://ice5.securenetsystems.net/KFXJ"
    item5.metadataUrl = "https://somafm.com/fox/songhistory.html"
    
    item6 = row2.CreateChild("ContentNode")
    item6.title = "Alt 107.1"
    item6.HDPosterUrl = "pkg:/images/alt.png"
    item6.streamUrl = "https://ice5.securenetsystems.net/KALV"
    item6.metadataUrl = "https://somafm.com/alt/songhistory.html"
    
    item7 = row2.CreateChild("ContentNode")
    item7.title = "Bob FM 104.9"
    item7.HDPosterUrl = "pkg:/images/bob.png"
    item7.streamUrl = "https://ice5.securenetsystems.net/KBOD"
    item7.metadataUrl = "https://somafm.com/bob/songhistory.html"
    
    item8 = row2.CreateChild("ContentNode")
    item8.title = "Wild 105.9"
    item8.HDPosterUrl = "pkg:/images/wild.png"
    item8.streamUrl = "https://ice5.securenetsystems.net/KWYD"
    item8.metadataUrl = "https://somafm.com/wild/songhistory.html"
    
    print "MainScene: ContentNode created with 2 rows, 4 items each"
    for i = 0 to m.contentNode.getChildCount() - 1
        row = m.contentNode.getChild(i)
        print "MainScene: Row " + i.ToStr() + " has " + row.getChildCount().ToStr() + " items"
        for j = 0 to row.getChildCount() - 1
            item = row.getChild(j)
            print "MainScene: Item [" + i.ToStr() + ", " + j.ToStr() + "] - Title: " + item.title + ", Poster: " + item.HDPosterUrl
        end for
    end for
    
    m.listenLiveView.content = m.contentNode
    m.listenLiveView.visible = true
    m.listenLiveView.observeField("stationSelected", "onStationSelected")
    print "MainScene: Initialized ListenLiveView with 2 rows, 4 columns each"
End Sub

Sub onStationSelected()
    station = m.listenLiveView.stationSelected
    print "MainScene: Station selected - Title: " + station.title + ", Stream: " + station.streamUrl
    
    m.listenLiveView.visible = false
    m.playbackView = m.top.createChild("PlaybackView")
    m.playbackView.content = station
    m.playbackView.visible = true
    m.top.currentView = m.playbackView
    print "MainScene: Showing PlaybackView"
End Sub