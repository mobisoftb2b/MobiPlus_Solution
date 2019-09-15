using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;

public partial class Pages_Compield_AgentMap : PageBaseCls
{
    public string ScriptScr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        MPLayoutService.MPLayoutService WR = new MPLayoutService.MPLayoutService();
        DataTable dt = WR.MPLayout_GetAgentMap(Request.QueryString["AgentId"].ToString(), Request.QueryString["FromDate"].ToString(), "0", ConStrings.DicAllConStrings[SessionProjectName]);
        if(dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
			{
                ScriptScr += " var myLatlng" + i.ToString() + " = new google.maps.LatLng(" + dt.Rows[i]["RealLatitude"].ToString() + ", " + dt.Rows[i]["RealLongtitude"].ToString() + ");";
               
			}

            ScriptScr += "var mapOptions = {zoom: 15,center: myLatlng20};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                ScriptScr += " var marker" + i.ToString() + " = new google.maps.Marker( " +
                            "{ " +
                             "   position: myLatlng" + i.ToString() + ", " +
                             "   map: map, " +
                             "   title: '" + (i + 1).ToString() + ": " + Server.HtmlEncode(dt.Rows[i]["RealAddress"].ToString()) + " - " + Server.HtmlEncode(dt.Rows[i]["CustName"].ToString()) + "' " +
                            "}); ";
            }
        }
       
    }
}
