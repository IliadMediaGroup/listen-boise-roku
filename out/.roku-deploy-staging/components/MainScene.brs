Sub init()
    print "MainScene: Entering init"
    
    ' Station data
    m.stations = [
        { title: "KOOL 101.5", HDPosterUrl: "pkg:/images/kool.png", streamUrl: "https://ice5.securenetsystems.net/KKOO", metadataUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KKOO_history.txt" },
        { title: "101.9 The Bull", HDPosterUrl: "pkg:/images/bull.png", streamUrl: "https://ice64.securenetsystems.net/KQBL", metadataUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBL_history.txt" },
        { title: "My 102.7", HDPosterUrl: "pkg:/images/my.png", streamUrl: "https://ice9.securenetsystems.net/KZMG", metadataUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KZMG_history.txt" },
        { title: "IRock 99.1", HDPosterUrl: "pkg:/images/irock.png", streamUrl: "https://ice64.securenetsystems.net/KQBLHD2", metadataUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KQBLHD2_history.txt" },
        { title: "Fox Sports 99.9", HDPosterUrl: "pkg:/images/fox.png", streamUrl: "https://ice64.securenetsystems.net/KSRVHD2", metadataUrl: "https://streamdb8web.securenetsystems.net/player_status_update/KSRVHD2_history.txt" },
        { title: "96.5 The Alternative", HDPosterUrl: "pkg:/images/alt.png", streamUrl: "https://ice9.securenetsystems.net/KQBLHD3", metadataUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3_history.txt" },
        { title: "Bob FM 96.1", HDPosterUrl: "pkg:/images/bob.png", streamUrl: "https://ice64.securenetsystems.net/KSRV", metadataUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KSRV_history.txt" },
        { title: "Wild 101", HDPosterUrl: "pkg:/images/wild.png", streamUrl: "https://ice9.securenetsystems.net/KWYD", metadataUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KWYD_history.txt" }
    ]
    
    ' Create ContentNode with rows
    contentNode = CreateObject("roSGNode", "ContentNode")
    row1 = contentNode.CreateChild("ContentNode")
    row2 = contentNode.CreateChild("ContentNode")
    
    ' Populate first row (stations 0-3)
    for i = 0 to 3
        station = m.stations[i]
        item = row1.CreateChild("ContentNode")
        item.title = station.title
        item.HDPosterUrl = station.HDPosterUrl
        item.addFields({ streamUrl: station.streamUrl, metadataUrl: station.metadataUrl })
    end for
    
    ' Populate second row (stations 4-7)
    for i = 4 to 7
        station = m.stations[i]
        item = row2.CreateChild("ContentNode")
        item.title = station.title
        item.HDPosterUrl = station.HDPosterUrl
        item.addFields({ streamUrl: station.streamUrl, metadataUrl: station.metadataUrl })
    end for
    
    ' Initialize ListenLiveView
    m.listenLiveView = m.top.createChild("ListenLiveView")
    m.listenLiveView.id = "listenLiveView"
    m.listenLiveView.content = contentNode
    m.listenLiveView.visible = true
    m.listenLiveView.SetFocus(true)
    
    print "MainScene: Initialized ListenLiveView with 2 rows, 4 columns each"
End Sub