' Note: Partial file, only showing modified functions
Sub adjustButtonBarContent()
    ' Removed unused 'padding' variable
    if m.top.content = invalid or m.top.content.getChildCount() = 0 then return
    content = m.top.content
    buttonsCount = content.getChildCount()
    if buttonsCount = 0 then return
    buttonWidth = m.top.width / buttonsCount
    for i = 0 to buttonsCount - 1
        button = content.getChild(i)
        button.width = buttonWidth
        button.height = m.top.height
    end for
End Sub

Sub onAlignmentChanged()
    ' Removed unused 'event' variable
    if m.top.alignment = "left"
        m.buttons.translation = [0, 0]
    else if m.top.alignment = "center"
        m.buttons.translation = [(m.top.width - m.buttons.width) / 2, 0]
    else if m.top.alignment = "right"
        m.buttons.translation = [m.top.width - m.buttons.width, 0]
    end if
End Sub