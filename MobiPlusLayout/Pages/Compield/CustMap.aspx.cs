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

public partial class Pages_CustMap : PageBaseCls
{
    public string ScriptScr = "";
    public string contentString1 = "contentString1";
    public string contentString2 = "contentString2";
    public string Road1 = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;
        if (!IsPostBack)
        {
            initAgents(sender, e);
        }
    }
    protected void initAgents(object sender, EventArgs e)
    {
        MPLayoutService WR = new MPLayoutService();
        DataTable dt = WR.GetAgents(SessionUserID, ConStrings.DicAllConStrings[SessionProjectName]);
        dt.Rows[0].Delete();
        AgentsList.DataSource = dt;
        AgentsList.DataValueField = "AgentID";
        AgentsList.DataTextField = "AgentName";
        AgentsList.DataBind();
        AgentsList.Focus();
    }

    protected void init(object sender, EventArgs e)
    {
        ScriptScr = "";
        string ScriptScr2 = "";
        MPLayoutService WR = new MPLayoutService();
        Road1 = "";

        string Titles = "";
        string WinMsgs = "";
        string DistanceMsgs = "";
        string latlon1 = "";
        latlon1 = "32.2777255,34.8614782";
        
        ScriptScr2 = " var myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
        
        ScriptScr = ScriptScr2 + "var mapOptions = {zoom: 15,center: myLatlng0};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";

        string[] arrDate = txtDate.Value.Split('/');
        DataTable dtPoints = WR.GetOrdersMapByAgent(hdnAgentID.Value, arrDate[2] + arrDate[1] + arrDate[0], ConStrings.DicAllConStrings[SessionProjectName]);
        if (dtPoints != null && dtPoints.Rows.Count > 0)
        {
            ScriptScr = "";

            for (int i = 0; i < dtPoints.Rows.Count; i++)
            {
                ScriptScr += " var myLatlng" + i.ToString() + " = new google.maps.LatLng(" + dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + ");";
                Titles += "לקוח: " + dtPoints.Rows[i]["CustID"].ToString() + "\n" + "שם: " + dtPoints.Rows[i]["CustName"].ToString() + "\n" + "הזמנה: " + dtPoints.Rows[i]["DocNum"].ToString() + "\n" + "כתובת לקוח: " + dtPoints.Rows[i]["Address"].ToString() + "\n" + ";";

                DistanceMsgs += dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + "^"+ dtPoints.Rows[i]["Address"].ToString() + ";";

                WinMsgs += "לקוח: " + dtPoints.Rows[i]["CustID"].ToString() + "<br/>" + "שם: " + dtPoints.Rows[i]["CustName"].ToString() + "<br/>" + "הזמנה: " + dtPoints.Rows[i]["DocNum"].ToString() + "<br/>" + "כתובת לקוח: " + dtPoints.Rows[i]["Address"].ToString() + "<br/>" + "כתובת הזמנה: " + ";";
            }

            if (dtPoints.Rows.Count > 0)
                Road1 = dtPoints.Rows[0]["Lat"].ToString() + "," + dtPoints.Rows[0]["Lon"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lat"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lon"].ToString();

            if (dtPoints.Rows.Count == 0)
            {
                latlon1 = "32.2777255,34.8614782";
                ScriptScr += " var myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
            }
            ScriptScr += "var image = '../../img/Map-Pointer3.png';";
            ScriptScr += "var mapOptions = {zoom: 13,center: myLatlng0};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";
            for (int i = 1; i < dtPoints.Rows.Count; i++)
            {

                ScriptScr += " var marker" + i.ToString() + " = new google.maps.Marker( " +
                           "{ " +
                            "   position: myLatlng" + i.ToString() + ", " +
                            "   map: map, " +
                            "   icon: image, " +
                            "   title: 'gg' " +
                           "}); ";
            }



        }
        hdnArrDistanceMsgs.Value = DistanceMsgs;
        hdnArrWinMsgs.Value = WinMsgs;
        hdnArrTitle.Value = Titles.Replace('"','\"');
        hdnCountPoints.Value = dtPoints.Rows.Count.ToString();
        hdnRoad1.Value = Road1;
        hdnStrScript.Value = ScriptScr;
        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "aa" + DateTime.Now.Ticks.ToString(), "setTimeout('initialize();',7)", true);
    }
}
