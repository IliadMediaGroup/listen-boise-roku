Sub init()
    print "ListenLiveView: Entering init"
    m.stationGrid = m.top.FindNode("stationGrid")
    if m.stationGrid = invalid
        print "ListenLiveView: ERROR: stationGrid not found"
        return
    end if
    m.stationGrid.itemComponentName = "StationItem"
    m.stationGrid.observeField("hasFocus", "onGridFocusChange")
    m.stationGrid.observeField("itemSelected", "onItemSelected")
    m.top.observeField("content", "onContentSet")
    m.top.observeField("visible", "onVisibleChange")
    print "ListenLiveView: Init complete"
End Sub

Sub onContentSet()
    print "ListenLiveView: Content set, updating grid"
    if m.top.content = invalid
        print "ListenLiveView: ERROR: Content is invalid"
        return
    end if
    m.stationGrid.content = m.top.content
    if m.stationGrid.hasFocus()
        print "ListenLiveView: Grid already has focus"
    else
        m.stationGrid.SetFocus(true)
        print "ListenLiveView: Set focus to grid"
    end if
End Sub

Sub onGridFocusChange()
    print "ListenLiveView: Grid hasFocus: "; m.stationGrid.hasFocus()
    if m.stationGrid.hasFocus() and m.stationGrid.visible
        m.stationGrid.SetFocus(true)
    end if
End Sub

Sub onItemSelected()
    selectedIndex = m.stationGrid.itemSelected
    print "ListenLiveView: Item selected at index: "; selectedIndex
    if selectedIndex >= 0 and m.stationGrid.content <> invalid
        m.top.stationSelected = m.stationGrid.content.GetChild(selectedIndex)
    else
        print "ListenLiveView: ERROR: Invalid selection or content"
    end if
End Sub

Sub onVisibleChange()
    print "ListenLiveView: Visible changed to: "; m.top.visible
    if m.top.visible and m.stationGrid <> invalid
        m.stationGrid.SetFocus(true)
    else
        print "ListenLiveView: ERROR: Cannot set focus, grid invalid or not visible"
    end if
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    print "ListenLiveView: Key event - Key: "; key; ", Press: "; press
    if press and m.stationGrid <> invalid
        if key = "up" or key = "down" or key = "left" or key = "right"
            return false
        end if
    end if
    return false
End Function