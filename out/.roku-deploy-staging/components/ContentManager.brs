' Note: Partial file, only showing modified functions
Sub startAsyncLoad()
    ' Removed unused 'focusindextoset'
    if m.top.content = invalid then return
    m.content = m.top.content
    m.contentManager.loadContent(m.content)
End Sub

Sub lazyLoadHorizontalRow(rowIndex as Integer)
    ' Removed unused 'itemscount'
    if m.top.content = invalid then return
    row = m.top.content.getChild(rowIndex)
    if row = invalid then return
    m.contentManager.loadRowContent(row, rowIndex)
End Sub

Sub tryToLoadHorizontalPagination()
    ' Removed unused 'previousitemindex'
    if m.top.content = invalid then return
    m.contentManager.loadPaginationContent(m.top.content)
End Sub

Sub onMainContentLoaded()
    ' Removed unused 'rowstoload', 'firstnotloaderow'
    if m.top.content = invalid then return
    m.contentManager.processMainContent(m.top.content)
End Sub

Sub onIdleLoadExtraContent()
    ' Removed unused 'rowscount'
    if m.top.content = invalid then return
    m.contentManager.loadExtraContent(m.top.content)
End Sub