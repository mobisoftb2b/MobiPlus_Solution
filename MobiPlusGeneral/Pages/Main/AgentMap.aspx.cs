using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Configuration;

public partial class Pages_Compield_AgentMap1 : PageBaseCls
{
    public string ScriptScr = "";
    public string AgentId = "0";
    public string DateMap = "01/01/2000";

    public int DistanceInMetersFromCustomerAddress
    {
        get
        {
            if (Application["DubekMap_DistanceInMetersFromCustomerAddress"] == null)
                Application["DubekMap_DistanceInMetersFromCustomerAddress"] = Convert.ToInt32(ConfigurationManager.AppSettings["DubekMap_DistanceInMetersFromCustomerAddress"].ToString());
            return Convert.ToInt32(Application["DubekMap_DistanceInMetersFromCustomerAddress"]);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            DateMap = DateTime.Now.ToString("dd/MM/yyyy");
            init();
        }
    }
    protected void btnShowAllPoints_Click(object sender, EventArgs e)
    {
        init();
    }
    private void init()
    {
        try
        {
            SessionProjectName = "Dubek";
            string ScriptScr2 = "";
            if (Request.QueryString["User"] != null && Request.QueryString["date"] != null && Request.QueryString["ezor"] != null && Request.QueryString["maslol"] != null)
            {
                DateMap = Request.QueryString["date"].ToString().Substring(6, 2) + "/" + Request.QueryString["date"].ToString().Substring(4, 2) + "/" + Request.QueryString["date"].ToString().Substring(0, 4);
                AgentId = Request.QueryString["User"].ToString();
                GeneralService.GeneralService WR = new GeneralService.GeneralService();
                DataTable dt = null;

                if (hdnAllClick.Value == "0" || (Request.QueryString["maslol"].ToString() == "0" && Request.QueryString["ezor"].ToString() == "0"))
                {
                    if (Request.QueryString["maslol"].ToString() == "0" && Request.QueryString["ezor"].ToString() == "0")
                    {
                        btnShowAllPoints.Style["display"] = "none";
                    }
                    dt = WR.GetUserMap(Request.QueryString["User"].ToString(), Request.QueryString["date"].ToString(), Request.QueryString["ezor"].ToString(), Request.QueryString["maslol"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
                }
                else
                    dt = WR.GetUserMapAllPoints(Request.QueryString["User"].ToString(), Request.QueryString["date"].ToString(), Request.QueryString["ezor"].ToString(), Request.QueryString["maslol"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);

                if (dt != null)
                {

					bool isType2=false;
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        ScriptScr2 += " var myLatlng" + i.ToString() + " = new google.maps.LatLng(" + dt.Rows[i]["Latitude"].ToString() + ", " + dt.Rows[i]["Longtitude"].ToString() + ");";
                        ScriptScr2 += " var myRealLatlng" + i.ToString() + " = new google.maps.LatLng(" + dt.Rows[i]["RealLatitude"].ToString() + ", " + dt.Rows[i]["RealLongtitude"].ToString() + ");";
                    }

                    double Lastlat1 = 0;
                    double Lastlon1 = 0;
                    double AllDistance = 0;

                    string imgSrc = "../../img/ok.png";
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {

                        if (Lastlat1 > 0)
                            AllDistance += distance(Lastlat1, Lastlon1, Convert.ToDouble(dt.Rows[i]["Latitude"].ToString()), Convert.ToDouble(dt.Rows[i]["Longtitude"].ToString()), 'K') * 1000;

                        Lastlat1 = Convert.ToDouble(dt.Rows[i]["Latitude"].ToString());
                        Lastlon1 = Convert.ToDouble(dt.Rows[i]["Longtitude"].ToString());

                        DateMap = Convert.ToDateTime(dt.Rows[i]["MapDate"].ToString()).ToString("dd/MM/yyyy");


                        imgSrc = "../../img/ok.png";
                        string Bikur = "";
                        if (dt.Rows[i]["VisitStatus"].ToString() == "0" || dt.Rows[i]["VisitStatus"].ToString() == "")
                        {
                            Bikur = " לא ";
                            imgSrc = "../../img/close32.png";
                        }
                        string date = dt.Rows[i]["VisitDate"].ToString();
                        if (date != "")
                            date = Convert.ToDateTime(date).ToString("HH:mm");
                        ScriptScr += "var contentString" + i.ToString() + " = '<br/><div class=Title1>לקוח " + dt.Rows[i]["CustCode"].ToString() + "  - " + Server.HtmlEncode(dt.Rows[i]["CustName"].ToString()) + "</div><br/> " +
                            "<table class=tbl><tr><td><div class=data>סטטוס ביקור: " + Bikur + " בוצע ביקור</div><div class=data>כתובת: " + Server.HtmlEncode(dt.Rows[i]["RealAddress"].ToString()) + "</div>" +
                            "<div class=data>שעת ביקור: " + date + "</div></td><td><img src=" + imgSrc + " width=32px/></td></tr></table>';";


                        ScriptScr += "google.maps.event.addListener(map, 'click', function() { " +
                               "closeAllWindows(infoWindows); " +
                               "});";

                        ScriptScr += "  var distance = formatMoney(getDistance(myLatlng" + i.ToString() + ",myRealLatlng" + i.ToString() + "),2); var marker" + i.ToString() + " = new google.maps.Marker( " +
                                    "{ " +
                                     "   position: myLatlng" + i.ToString() + ", " +
                                     "   map: map, " +
                                     "   title: '" + (i + 1).ToString() + " -  distance:  '+distance" +//+ Server.HtmlEncode(dt.Rows[i]["Address"].ToString()) + " - " + "Server.HtmlEncode(dt.Rows[i][CustName].ToString())"
                                     " ,icon: '" + dt.Rows[i]["VisitTypeID"].ToString() + "' == '1' && distance<=" + DistanceInMetersFromCustomerAddress + " ? '../../img/pin_green.png' : '" + dt.Rows[i]["VisitTypeID"].ToString() + "' == '1' ? '../../img/pin_red.png' : '../../img/pin_grey.png' " +
                                    "}); ";

                        ScriptScr += "var address = '" + Server.HtmlEncode(dt.Rows[i]["RealAddress"].ToString()) + "';";
                        ScriptScr += "google.maps.event.addListener(marker" + i.ToString() + ", 'click', function() { " +

                              " var infowindow = new google.maps.InfoWindow({ " +
                           "content: contentString" + i.ToString() + " " +
                           "}); " +
                           "infoWindows.push(infowindow);  " +
                             "closeAllInfoWindowsAndShowNewWindow(map, marker" + i.ToString() + ",infoWindows,infowindow); " +
                        "}); ";
						
						if(dt.Rows[i]["VisitTypeID"].ToString() == "2")
							isType2=true;
                    }
                    string zoom = "15";
                    if (AllDistance > 15000)
                        zoom = "10";
                    else if (AllDistance > 11000)
                        zoom = "11";
                    else if (AllDistance > 9000)
                        zoom = "12";
                    else if (AllDistance > 6000)
                        zoom = "13";


                    if (dt.Rows.Count > 0 && isType2)
                        zoom = "16";

                    string myLatlng = ",center: myLatlng0";
                    if (dt.Rows.Count > 5)
                        myLatlng = ",center: myLatlng6";

                    ScriptScr2 += "$('#map-canvas').show();$('.msgData').hide();";

                    if (dt.Rows.Count == 0)
                    {
                        for (int i = 0; i < 1; i++)
                        {
                            ScriptScr2 += " var myLatlng" + i.ToString() + " = new google.maps.LatLng(32.08493, 34.83523);";
                            ScriptScr2 += " var myRealLatlng" + i.ToString() + " = new google.maps.LatLng(32.08493, 34.83523);";
                        }
                        myLatlng = ",center: myLatlng0";

                        ScriptScr2 += "$('#map-canvas').hide();$('.msgData').show();";
                    }

                    ScriptScr = ScriptScr2 + "var infoWindows = []; var mapOptions = {zoom: " + zoom + myLatlng + "};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);" + ScriptScr;
                }
            }
            else
            {
                Response.Write("לא הוזנו כל הפרמטרים.");
            }
        }
        catch (Exception ex)
        {
        }
    }
    private double distance(double lat1, double lon1, double lat2, double lon2, char unit)
    {

        double theta = lon1 - lon2;
        double dist = Math.Sin(deg2rad(lat1)) * Math.Sin(deg2rad(lat2)) + Math.Cos(deg2rad(lat1)) * Math.Cos(deg2rad(lat2)) * Math.Cos(deg2rad(theta));
        dist = Math.Acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60 * 1.1515;
        if (unit == 'K')
        {
            dist = dist * 1.609344;
        }
        else if (unit == 'N')
        {
            dist = dist * 0.8684;
        }
        return (dist);
    }
    private double deg2rad(double deg)
    {
        return (deg * Math.PI / 180.0);
    }
    private double rad2deg(double rad)
    {
        return (rad / Math.PI * 180.0);
    }
}

