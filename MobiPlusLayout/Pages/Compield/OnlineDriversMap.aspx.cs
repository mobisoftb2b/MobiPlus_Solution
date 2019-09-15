using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_OnlineDriversMap : PageBaseCls
{
    public string ScriptScr = "";
    public string contentString1 = "contentString1";
    public string contentString2 = "contentString2";
    public string Road1 = "";

    public bool isFirst
    {
        get
        {
            if (ViewState["isFirst"] == null)
                ViewState["isFirst"] = "True";
            return Convert.ToBoolean(ViewState["isFirst"].ToString());
        }
        set
        {
            ViewState["isFirst"] = value.ToString();
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;
        if (!IsPostBack)
        {
            isFirst = true;
            initAgents(sender, e);
            GetData(sender,e);
        }
    }
    protected void initAgents(object sender, EventArgs e)
    {
        MPLayoutService WR = new MPLayoutService();
        DataTable dt = WR.GetAgents(SessionUserID,ConStrings.DicAllConStrings[SessionProjectName]);
        AgentsList.DataSource = dt;
        AgentsList.DataValueField = "AgentID";
        AgentsList.DataTextField = "AgentName";
        AgentsList.DataBind();
        AgentsList.Focus();
    }

   protected void GetData(object sender, EventArgs e)
    {
        ScriptScr = "";
        string ScriptScr2 = "";
        hdnStrScript.Value = "";
        MPLayoutService WR = new MPLayoutService();
        Road1 = "";

        string Titles = "";
        string WinMsgs = "";
        string DistanceMsgs = "";
        string latlon1 = "";
        latlon1 = "32.2777255,34.8614782";

        
        if (isFirst)
        {
            ScriptScr2 = " var myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
            if (isFirst)
                ScriptScr = ScriptScr2 + "var mapOptions = {zoom: 13,center: myLatlng0};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";

            string[] arrDate = txtDate.Value.Split('/');
            DataTable dtPoints = WR.MPLayout_GetDriverGPSLocation(AgentsList.SelectedValue, DateTime.Now.Date.ToString("yyyy/MM/dd"), ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtPoints != null && dtPoints.Rows.Count > 0)
            {
                ScriptScr = "";

                for (int i = 0; i < dtPoints.Rows.Count; i++)
                {
                    ScriptScr += " var myLatlng" + i.ToString() + " = new google.maps.LatLng(" + dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + ");";
                    Titles += dtPoints.Rows[i]["Name"].ToString() + ";";

                    DistanceMsgs += dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + "^" + ";";

                    WinMsgs += dtPoints.Rows[i]["Name"].ToString() + ";";
                }

                if (dtPoints.Rows.Count > 0)
                    Road1 = dtPoints.Rows[0]["Lat"].ToString() + "," + dtPoints.Rows[0]["Lon"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lat"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lon"].ToString();

                if (dtPoints.Rows.Count == 0)
                {
                    latlon1 = "32.2777255,34.8614782";
                    ScriptScr += " var myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
                }
                ScriptScr += "var image = '../../img/truck2.png';gMarkers = [];";
                if (isFirst)
                    ScriptScr += "var mapOptions = {zoom: 8,center: myLatlng0};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";

                for (int i = 0; i < dtPoints.Rows.Count; i++)
                {
                    ScriptScr += " var marker" + i.ToString() + " = new MarkerWithLabel({ " +
                    "position: myLatlng" + i.ToString() + ", " +
                    "draggable: false, " +
                    "raiseOnDrag: true, " +
                    "map: map, " +
                    "labelContent: '" + Convert.ToInt64(dtPoints.Rows[i]["AgentCode"].ToString()) + " - " + dtPoints.Rows[i]["Name"].ToString() + "', " +
                    "labelAnchor: new google.maps.Point(34, 0), " +
                    "labelClass: 'labels', " +
                    "icon:image " +
                    "});";
                  
                    ScriptScr += "gMarkers.push(marker" + i.ToString() + ");";
                }



            }
            hdnArrDistanceMsgs.Value = DistanceMsgs;
            hdnArrWinMsgs.Value = WinMsgs;
            hdnArrTitle.Value = Titles.Replace('"', '\"');
            hdnCountPoints.Value = dtPoints.Rows.Count.ToString();
            hdnRoad1.Value = Road1;
            hdnStrScript.Value = ScriptScr;

            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "aa1" + DateTime.Now.Ticks.ToString(), "setTimeout('initMap();',7);", true);
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "aaf" + DateTime.Now.Ticks.ToString(), "setTimeout('Refresh1();',1117);", true);

            isFirst = false;
        }
        else
        {
            ScriptScr2 = " myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
            string[] arrDate = txtDate.Value.Split('/');
            DataTable dtPoints = WR.MPLayout_GetDriverGPSLocation(AgentsList.SelectedValue,DateTime.Now.Date.ToString("yyyy/MM/dd"), ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtPoints != null && dtPoints.Rows.Count > 0)
            {
                ScriptScr = "";

                for (int i = 0; i < dtPoints.Rows.Count; i++)
                {
                    ScriptScr += " myLatlng" + i.ToString() + " = new google.maps.LatLng(" + dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + ");";
                    Titles += dtPoints.Rows[i]["Name"].ToString() + ";";

                    DistanceMsgs += dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + "^" + ";";

                    WinMsgs += dtPoints.Rows[i]["Name"].ToString() + ";";
                }

                if (dtPoints.Rows.Count > 0)
                    Road1 = dtPoints.Rows[0]["Lat"].ToString() + "," + dtPoints.Rows[0]["Lon"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lat"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lon"].ToString();

                if (dtPoints.Rows.Count == 0)
                {
                    latlon1 = "32.2777255,34.8614782";
                    ScriptScr += " myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
                }
                ScriptScr += "image = '../../img/truck2.png';";
                if(AgentsList.SelectedValue!="0")
                    ScriptScr += "var mapOptions = {zoom: 17,center: myLatlng0};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);gMarkers = [];";
                else
                    ScriptScr += "var mapOptions = {zoom: 8,center: myLatlng0};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);gMarkers = [];";

                for (int i = 0; i < dtPoints.Rows.Count; i++)
                {
                    ScriptScr += " marker" + i.ToString() + " = new MarkerWithLabel({ " +
                    "position: myLatlng" + i.ToString() + ", " +
                    "draggable: false, " +
                    "raiseOnDrag: true, " +
                    "map: map, " +
                    "labelContent: '" + Convert.ToInt64(dtPoints.Rows[i]["AgentCode"].ToString()) + " - " + dtPoints.Rows[i]["Name"].ToString() + "', " +
                    "labelAnchor: new google.maps.Point(34, 0), " +
                    "labelClass: 'labels', " +
                    "icon:image " +
                    "});";
                    ScriptScr += "gMarkers.push(marker" + i.ToString() + ");";
                }
                for (int i = 1; i < Convert.ToInt32(hdnCountPoints.Value); i++)
                {
                    if (i > 0)
                        ScriptScr += "marker" + i.ToString() + ".setVisible(false);";
                }
            }
            hdnArrDistanceMsgs.Value = DistanceMsgs;
            hdnArrWinMsgs.Value = WinMsgs;
            hdnArrTitle.Value = Titles.Replace('"', '\"');
            hdnCountPoints.Value = dtPoints.Rows.Count.ToString();
            hdnRoad1.Value = Road1;
            hdnStrScript.Value = ScriptScr;

            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "aa1" + DateTime.Now.Ticks.ToString(), "setTimeout('initMap();',7);", true);
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "aa7" + DateTime.Now.Ticks.ToString(), "setTimeout('Refresh1();',1117);", true);

            isFirst = false;
        }
    }
}
