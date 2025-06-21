Sub init()
    print "StationItem: Entering init"
    m.poster = m.top.findNode("poster")
    m.title = m.top.findNode("title")
    m.title.font = m.top.findNode("font")
End Sub

Sub onContentChange()
    content = m.top.itemContent
    if content <> invalid
        print "StationItem: Content set - Title: " + content.title + ", Poster: " + content.HDPosterUrl
        m.poster.uri = content.HDPosterUrl
        if content.HDPosterUrl = "" or content.HDPosterUrl = invalid
            m.poster.uri = "pkg:/images/splash_screen_hd.png" ' Fallback
            print "StationItem: Using fallback poster"
        end if
        m.title.text = content.title
    else
        print "StationItem: Invalid content"
        m.poster.uri = "pkg:/images/splash_screen_hd.png" ' Fallback
        m.title.text = "Unknown"
    end if
End Sub
</xArtifact>

**Changes**:
- Set the `Label`’s `font` field to the `Font` node.
- Added a fallback poster (`splash_screen_hd.png`) if `HDPosterUrl` is empty or invalid.
- Set `title` to “Unknown” if content is invalid.
- Enhanced logging to track fallback usage.

#### 4. ListenLiveView.brs (Updated)
Fix background and improve `onKeyEvent` robustness.

<xaiArtifact artifact_id="2a60bb03-df0c-43b1-b04a-e97e2419bfed" artifact_version_id="5db61817-24cc-44cd-9de1-ece673f98da1" title="ListenLiveView.brs" contentType="text/brightscript">
Sub init()
    print "ListenLiveView: Entering init"
    
    m.grid = m.top.findNode("stationGrid")
    m.grid.numColumns = 4
    m.grid.numRows = 2
    m.grid.itemSize = [200, 240]
    m.grid.itemSpacing = [20, 20]
    m.grid.rowSpacings = [20]
    m.grid.columnWidths = [200, 200, 200, 200]
    
    m.background = m.top.findNode("background")
    m.background.color = "0x000000FF"
    
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
        if rowCol[0] >= 0 and rowCol[1] >= 0 and rowCol[0] < m.grid.numRows and rowCol[1] < m.grid.numColumns and m.grid.content <> invalid
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