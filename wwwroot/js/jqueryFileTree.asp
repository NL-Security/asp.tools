<%
'
' jQuery File Tree ASP (VBS) Connector
' Copyright 2008 Chazzuka
' programmer@chazzuka.com
' http://www.chazzuka.com/
'
' retrive base directory
dim BaseFileDir:BaseFileDir=Request.Form("dir")
' if blank give default value
if len(BaseFileDir)=0 then BaseFileDir="/userfiles/"

' resolve the absolute path
BaseFile = Server.MapPath(BaseFileDir)&"\"
' create FSO
Set ObjFSO = Server.CreateObject("Scripting.FileSystemObject")
' if given folder is exists
if ObjFSO.FolderExists(BaseFile) then
       dim ObjFolder,ObjSubFolder, file,i__Name,i__Ext
       Html = Html +  "<ul class=""jqueryFileTree"" style=""display: none;"">"&VBCRLF
       Set ObjFolder = ObjFSO.GetFolder(BaseFile)
       ' LOOP THROUGH SUBFOLDER
       For Each ObjSubFolder In ObjFolder.SubFolders
               i__Name=ObjSubFolder.name
               Html = Html + "<li class=""directory collapsed"">"&_
                                         "<a href=""#"" rel="""+(BaseFileDir+i__Name+"/")+""">"&_
                                         (i__Name)+"</a></li>"&VBCRLF
       Next
       'LOOP THROUGH FILES
       For Each file In ObjFolder.Files
               ' name
               i__Name = file.name
               ' extension
               i__Ext = LCase(Mid(i__Name, InStrRev(i__Name, ".", -1, 1) + 1))
               Html = Html + "<li class=""file ext_"&i__Ext&""">"&_
                                         "<a href=""#"" rel="""+(BaseFileDir+i__Name)+""">"&_
                                         (i__name)+"</a></li>"&VBCRLF
       Next
       Html = Html +  "</ul>"&VBCRLF
end if

Response.Write Html
%>