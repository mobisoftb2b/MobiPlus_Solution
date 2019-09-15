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

public partial class Pages_CustTasksMap : PageBaseCls
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
        var cid = string.IsNullOrEmpty(Request["CountryID"]) ? "1000" : Request["CountryID"];
        var did = string.IsNullOrEmpty(Request["DistrID"]) ? "1000" : Request["DistrID"];
        MPLayoutService WR = new MPLayoutService();
        DataTable dt = WR.GetAgentsL(SessionUserID, cid, did, ConStrings.DicAllConStrings[SessionProjectName]);
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
        string PointsVisits = "";
        string WinMsgs = "";
        string DistanceMsgs = "";
        string latlon1 = "";
        latlon1 = GetCustomCoord();

        string latlonNotFoundCust = "";
        latlonNotFoundCust = GetCustomCoord();

        ScriptScr2 = " var myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
        
        ScriptScr = ScriptScr2 + "var mapOptions = {zoom: 15,center: myLatlng0};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";

        string[] arrDate = txtDate.Value.Split('/');
        DataTable dtPoints = WR.MPLayout_GetCustomersCord(hdnAgentID.Value, arrDate[2] + arrDate[1] + arrDate[0], ConStrings.DicAllConStrings[SessionProjectName],null, null);
        if (dtPoints != null && dtPoints.Rows.Count > 0)
        {
            ScriptScr = "";

            for (int i = 0; i < dtPoints.Rows.Count; i++)
            {
                PointsVisits += dtPoints.Rows[i]["IsVisit"].ToString() + ",";
                if (dtPoints.Rows[i]["Lat"].ToString() != "" && dtPoints.Rows[i]["Lat"].ToString() != "not found")
                {
                    ScriptScr += " var myLatlng" + i.ToString() + " = new google.maps.LatLng(" + dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + ");";
                    Titles += "לקוח: " + dtPoints.Rows[i]["CustID"].ToString() + "\n" + "שם: " + dtPoints.Rows[i]["CustName"].ToString() + "\n" + ";";//+ "כתובת לקוח: " + dtPoints.Rows[i]["Address"].ToString() + "\n" + ";";

                    DistanceMsgs += dtPoints.Rows[i]["Lat"].ToString() + "," + dtPoints.Rows[i]["Lon"].ToString() + "^" + dtPoints.Rows[i]["Address"].ToString() + ";";

                    WinMsgs += "לקוח: " + dtPoints.Rows[i]["CustID"].ToString() + "<br/>" + "שם: " + dtPoints.Rows[i]["CustName"].ToString() + "<br/>" + ";"; //+ "כתובת לקוח: " + dtPoints.Rows[i]["Address"].ToString()  + ";";
                }
                else
                {
                    ScriptScr += " var myLatlng" + i.ToString() + " = new google.maps.LatLng(" + latlonNotFoundCust + ");";
                    Titles += "לקוח: " + dtPoints.Rows[i]["CustID"].ToString() + "\n" + "שם: " + dtPoints.Rows[i]["CustName"].ToString() + "\n" + ";"; //+ "כתובת לקוח: " + dtPoints.Rows[i]["Address"].ToString() + "\n" + ";";

                    DistanceMsgs += latlonNotFoundCust + "^" + dtPoints.Rows[i]["Address"].ToString() + ";";

                    WinMsgs += "לקוח: " + dtPoints.Rows[i]["CustID"].ToString() + "<br/>" + "שם: " + dtPoints.Rows[i]["CustName"].ToString() + ";"; //+ "<br/>" + "כתובת לקוח: " + dtPoints.Rows[i]["Address"].ToString() + ";";
                }
            }

            if (dtPoints.Rows.Count > 0)
                Road1 = dtPoints.Rows[0]["Lat"].ToString() + "," + dtPoints.Rows[0]["Lon"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lat"].ToString() + "," + dtPoints.Rows[dtPoints.Rows.Count - 1]["Lon"].ToString();

            if (dtPoints.Rows.Count == 0)
            {
                latlon1 = "32.2777255,34.8614782";
                ScriptScr += " var myLatlng0 = new google.maps.LatLng(" + latlon1 + ");";
            }
            ScriptScr += "var image = '../../img/Map-PointerRed.png';";
            ScriptScr += "var imageGreen = '../../img/Map-PointerGreen.png';";
            ScriptScr += "var imagePurple = '../../img/Map-PointerPerpel.png';";
            ScriptScr += "var mapOptions = {zoom: 13,center: myLatlng0};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);";
            int countGreen = 1;
            for (int i = 0; i < dtPoints.Rows.Count; i++)
            {
                if (dtPoints.Rows[i]["IsVisit"].ToString() == "0")
                {
                    if (dtPoints.Rows[i]["Lat"].ToString() != "")
                    {
                        ScriptScr += " var marker" + i.ToString() + " = new google.maps.Marker( " +
                               "{ " +
                                "   position: myLatlng" + i.ToString() + ", " +
                                "   map: map, " +
                                "   icon: image, " +
                                "   zIndex: 1, " +
                                "   title: arrTitels[" +i+"] " +
                               "}); ";
                    }
                    else
                    {
                        ScriptScr += " var marker" + i.ToString() + " = new google.maps.Marker( " +
                                 "{ " +
                                  "   position: myLatlng" + i.ToString() + ", " +
                                  "   map: map, " +
                                  "   icon: imagePurple, " +
                                  "   zIndex: 1, " +
                                 "   title: arrTitels[" + i + "] " +
                                 "}); ";

                    }

                }
                else
                {
                    if (dtPoints.Rows[i]["Lat"].ToString() != "" && dtPoints.Rows[i]["Lat"].ToString() != "not found")
                    {
                        ScriptScr += " var marker" + i.ToString() + " = new google.maps.Marker( " +
                              "{ " +
                               "   position: myLatlng" + i.ToString() + ", " +
                               "   map: map, " +
                               "   icon: imageGreen, " +
                               "   zIndex: 1000, " +
                               "   title: '" + countGreen.ToString() + " \\n' + arrTitels[" + i + "] " +
                              "}); ";
                        countGreen++;
                    }
                    else
                    {
                        ScriptScr += " var marker" + i.ToString() + " = new google.maps.Marker( " +
                              "{ " +
                               "   position: myLatlng" + i.ToString() + ", " +
                               "   map: map, " +
                               "   icon: imagePurple, " +
                               "   zIndex: 1, " +
                               "   title: arrTitels[" + i + "] " +
                              "}); ";

                    }
                    
                }

            }



        }
        hdnArrDistanceMsgs.Value = DistanceMsgs;
        hdnArrWinMsgs.Value = WinMsgs;
        hdnArrTitle.Value = Titles.Replace('"','\"');
        hdnArrPointsVisits.Value = PointsVisits.Replace('"', '\"');
        hdnCountPoints.Value = dtPoints.Rows.Count.ToString();
        hdnRoad1.Value = Road1;
        hdnStrScript.Value = ScriptScr;
        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "aa" + DateTime.Now.Ticks.ToString(), "setTimeout('initialize();',7)", true);
    }
}
