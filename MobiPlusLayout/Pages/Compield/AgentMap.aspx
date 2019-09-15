<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AgentMap.aspx.cs" Inherits="Pages_Compield_AgentMap" %>

<!DOCTYPE html>
<html>
<head>
    <style type="text/css">
        html, body, #map-canvas
        {
            height: 100%;
            margin: 0;
            padding: 0;
        }
    </style>
  <script type="text/javascript">
 
  </script>
   
</head>
<body onload="try{setTimeout('parent.CloseLoading();',10);}catch(e){}">
     <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?language=<%= Lang %>&ie=UTF8&key=AIzaSyCHUbGQlp0YB6vQlkxosTrbOOwMqWCUHpk">
       
    </script>
    <form runat="server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    </form>
    <div id="map-canvas">
    </div>

    <script type="text/javascript">
       
        function initialize() {
            eval("<%=ScriptScr %>");
        }

        google.maps.event.addDomListener(window, 'load', initialize);
    </script>
</body>
</html>
