Sub init()
    print "ListenLiveView: Entering init"
    
    m.grid = m.top.findNode("stationGrid")
    m.grid.numColumns = 4
    m.grid.numRows = 2
    m.grid.itemSize = [200, 240]
    m.grid.itemSpacing = [20, 20]
    m.grid.rowSpacings = [20]
    m.grid.columnWidths = [200, 200, 200, 200]
    
    ' Set background to black
    m.top.backgroundUri = ""
    m.top.backgroundColor = "0x000000FF"
    
    print "ListenLiveView: Init complete, grid configured for 2 rows, 4 columns"
End Sub

Sub onContentSet()
    print "ListenLiveView: Content set, updating grid"
    if m.top.content <> invalid
        print "ListenLiveView: Content has " + m.top.content.getChildCount().ToStr() + " rows"
        for i = 0 to m.top.content.getChildCount() - 1
            row = m.top.content.getChild(i)
            print "ListenLiveView: Row " + i.ToStr() + " has " + row.getChildCount().ToStr() + " items"
        end for
        m.grid.content = m.top.content
        m.grid.SetFocus(true)
        print "ListenLiveView: Grid content set, focus applied"
    else
        print "ListenLiveView: Invalid content"
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
        rowCol = m.grid.rowItemSelected
        print "ListenLiveView: OK pressed, rowItemSelected = [" + rowCol[0].ToStr() + ", " + rowCol[1].ToStr() + "]"
        if rowCol[0] >= 0 and rowCol[1] >= 0 and m.grid.content <> invalid
            row = m.grid.content.getChild(rowCol[0])
            if row <> invalid
                content = row.getChild(rowCol[1])
                if content <> invalid
                    index = rowCol[0] * m.grid.numColumns + rowCol[1]
                    print "ListenLiveView: Selected station at index: " + index.ToStr() + ", title: " + content.title
                    m.top.stationSelected = content
                    handled = true
                else
                    print "ListenLiveView: No content at column: " + rowCol[1].ToStr()
                end if
            else
                print "ListenLiveView: No content at row: " + rowCol[0].ToStr()
            end if
        else
            print "ListenLiveView: Invalid rowItemSelected or content"
        end if
    end if
    
    return handled
End Function