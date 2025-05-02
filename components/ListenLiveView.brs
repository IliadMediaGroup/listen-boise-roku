Sub init()
    print "ListenLiveView: Entering init"
    
    m.grid = m.top.findNode("stationGrid")
    print "ListenLiveView: Init complete"
End Sub

Sub onContentSet()
    print "ListenLiveView: Content set, updating grid"
    if m.top.content <> invalid
        m.grid.content = m.top.content
        m.grid.SetFocus(true)
    end if
End Sub

Sub onVisibleChange()
    if m.top.visible = true
        print "ListenLiveView: Set focus to grid"
        m.grid.SetFocus(true)
    end if
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    print "ListenLiveView: Key event - Key: " + key + ", Press: " + press.ToStr()
    
    if press and key = "OK"
        row = m.grid.rowItemFocused[0]
        col = m.grid.rowItemFocused[1]
        content = m.grid.content.getChild(row).getChild(col)
        if content <> invalid
            print "ListenLiveView: Selected station at row: " + row.ToStr() + ", col: " + col.ToStr() + ", title: " + content.title
            m.top.stationSelected = content
            handled = true
        else
            print "ListenLiveView: No content found at row: " + row.ToStr() + ", col: " + col.ToStr()
        end if
    end if
    
    return handled
End Function