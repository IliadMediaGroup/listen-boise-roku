' ListenLiveView.brs
Sub Init()
    print "ListenLiveView: Entering Init"
    print "ListenLiveView: Deployed version 9"
    m.stationGrid = m.top.FindNode("stationGrid")

    if m.stationGrid = invalid
        print "ERROR: stationGrid not found"
        return
    end if

    content = CreateObject("roSGNode", "ContentNode")
    m.stations = [
        {url: "https://ice64.securenetsystems.net/KQBL", name: "101.9 The Bull", image: "pkg:/images/bull.png"},
        {url: "https://ice9.securenetsystems.net/KZMG", name: "My 102.7", image: "pkg:/images/my.png"},
        {url: "https://ice64.securenetsystems.net/KSRV", name: "Bob FM 96.1", image: "pkg:/images/bob.png"},
        {url: "https://ice9.securenetsystems.net/KWYD", name: "Wild 101.1", image: "pkg:/images/wild.jpg"},
        {url: "https://ice64.securenetsystems.net/KQBLHD2", name: "I-Rock 99.1 FM", image: "pkg:/images/irock.png"},
        {url: "https://ice64.securenetsystems.net/KSRVHD2", name: "Fox Sports 99.9", image: "pkg:/images/fox.png"},
        {url: "https://ice5.securenetsystems.net/KKOO", name: "101.5 Kool FM", image: "pkg:/images/kool.png"},
        {url: "https://ice9.securenetsystems.net/KQBLHD3", name: "96.5 The Alternative", image: "pkg:/images/alt.png"}
    ]

    for i = 0 to m.stations.Count() - 1
        station = m.stations[i]
        contentChild = content.CreateChild("ContentNode")
        contentChild.title = station.name
        contentChild.HDPosterUrl = station.image
        contentChild.SDPosterUrl = station.image
        print "ListenLiveView: Added station "; i; ": "; station.name; ", image path: "; station.image
    end for

    m.stationGrid.content = content
    print "ListenLiveView: Total stations loaded: "; m.stations.Count()
    print "ListenLiveView: stationGrid focus: "; m.stationGrid.hasFocus()
    print "ListenLiveView: Init complete"
End Sub

Sub OnStationFocused()
    print "ListenLiveView: Station focused at index: "; m.stationGrid.itemFocused
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    print "ListenLiveView: Key event - Key: "; key; ", Press: "; press
    if not press
        return false
    end if

    if key = "OK"
        print "ListenLiveView: OK key pressed, selecting station at index: "; m.stationGrid.itemFocused
        m.top.selectedStationIndex = m.stationGrid.itemFocused
        return true
    end if

    return false
End Function