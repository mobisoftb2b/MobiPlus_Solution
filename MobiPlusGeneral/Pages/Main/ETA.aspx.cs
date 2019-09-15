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

public partial class Pages_Main_ETA : System.Web.UI.Page
{
    public string ScriptScr = "";
    public string contentString1 = "";
    public string contentString2 = "";

    public string Road1 = "";
    public static string Hash_WebConnectionString = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }

    }
    private void init()
    {
        string latlon1 = "";
        string latlon2 = "";
        if (Hash_WebConnectionString == "")
        {
            Hash_WebConnectionString = ConfigurationManager.AppSettings["Hash_WebConnectionString"].ToString();
        }

        if (Request.QueryString["AgentID"] != null)
        {
            GeneralService.GeneralService WR = new GeneralService.GeneralService();
            DataTable dtDB = WR.GetLocationToSMS(Request.QueryString["AgentID"].ToString(), Hash_WebConnectionString);

            if (dtDB != null && dtDB.Rows.Count > 0)
            {
                string AgentID = dtDB.Rows[0]["AgentID"].ToString();
                string CustKey1 = dtDB.Rows[0]["CustKey1"].ToString();
                string CustKey2 = dtDB.Rows[0]["CustKey2"].ToString();
                string Lat = dtDB.Rows[0]["Lat"].ToString();
                string Lon = dtDB.Rows[0]["Lon"].ToString();


                DataTable dt = WR.ETA_GetETAQData(AgentID, CustKey1, CustKey2, Hash_WebConnectionString);

                if (dt != null && dt.Rows.Count > 0)
                {
                    aPhone.Attributes["href"] = "tel:" + dt.Rows[0]["Tel"].ToString();

                    string responseFromServer = "";
                    if (Lat == "")
                    {
                        try
                        {
                            //get lat,lon by address 1
                            contentString1 = "<br/>" + dt.Rows[0]["Address1"].ToString().Replace("'", "");
                            string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyDIF59HFtAqfruZHi-VAmlGBn1Ga3vWndM&address=" + dt.Rows[0]["Address1"].ToString() + "&sensor=false";
                            WebRequest request = WebRequest.Create(url);

                            request.Credentials = CredentialCache.DefaultCredentials;
                            // Get the response.
                            WebResponse response = request.GetResponse();
                            // Get the stream containing content returned by the server.
                            Stream dataStream = response.GetResponseStream();
                            // Open the stream using a StreamReader for easy access.
                            StreamReader reader = new StreamReader(dataStream);
                            // Read the content.
                            responseFromServer = reader.ReadToEnd();
                            // Display the content.

                            if (responseFromServer.IndexOf("ZERO_RESULTS") > -1)
                            {
                                //AddRowToLog("ZERO_RESULTS1  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");
                            }
                            else
                            {
                                JObject data = JsonConvert.DeserializeObject<JObject>(responseFromServer);

                                reader.Close();
                                response.Close();

                                if (responseFromServer.IndexOf("ZERO_RESULTS") == -1 && data["status"].ToString() == "\"OVER_QUERY_LIMIT\"")
                                {
                                    //AddRowToLog("google answer: OVER_QUERY_LIMIT; " + data["error_message"].ToString());
                                    //AddRowToLog("Stoping the program...");
                                    //break;
                                    return;
                                }

                                if (data["status"].ToString().IndexOf("ZERO_RESULTS") == -1 && responseFromServer.IndexOf("ZERO_RESULTS") == -1)
                                {
                                    //lat lon
                                    // AddRowToLog("Added successfully CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table with values:" + data["results"].Last["geometry"]["location"]["lat"].ToString() + "; " + data["results"].Last["geometry"]["location"]["lng"].ToString());
                                    latlon1 = data["results"].Last["geometry"]["location"]["lat"].ToString() + "," + data["results"].Last["geometry"]["location"]["lng"].ToString();
                                }
                                else
                                {
                                    //AddRowToLog("ZERO_RESULTS  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            //AddRowToLog("Local Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table; MSG: " + ex.Message.ToString() + "; responseFromServer: " + responseFromServer);
                        }
                    }
                    else
                    {
                        latlon1 = Lat + "," + Lon;
                        try
                        {
                            //get address by lat,lon
                            string url = "https://maps.googleapis.com/maps/api/geocode/json?language=iw&latlng=" + latlon1 + "&key=AIzaSyDIF59HFtAqfruZHi-VAmlGBn1Ga3vWndM";
                            WebRequest request = WebRequest.Create(url);

                            request.Credentials = CredentialCache.DefaultCredentials;
                            // Get the response.
                            WebResponse response = request.GetResponse();
                            // Get the stream containing content returned by the server.
                            Stream dataStream = response.GetResponseStream();
                            // Open the stream using a StreamReader for easy access.
                            StreamReader reader = new StreamReader(dataStream);
                            // Read the content.
                            responseFromServer = reader.ReadToEnd();
                            // Display the content.

                            if (responseFromServer.IndexOf("ZERO_RESULTS") > -1)
                            {
                                //AddRowToLog("ZERO_RESULTS1  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");
                            }
                            else
                            {
                                JObject data = JsonConvert.DeserializeObject<JObject>(responseFromServer);

                                reader.Close();
                                response.Close();

                                contentString1 = "<br/>" + data["results"].First["formatted_address"].ToString().Replace("'", "");
                            }
                        }
                        catch (Exception ex)
                        {
                            //AddRowToLog("Local Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table; MSG: " + ex.Message.ToString() + "; responseFromServer: " + responseFromServer);
                        }
                    }

                    //address 2
                    responseFromServer = "";
                    try
                    {
                        contentString2 = "<br/>" + dt.Rows[0]["Address2"].ToString().Replace("'", "");
                        string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyDIF59HFtAqfruZHi-VAmlGBn1Ga3vWndM&address=" + dt.Rows[0]["Address2"].ToString() + "&sensor=false";
                        WebRequest request = WebRequest.Create(url);

                        request.Credentials = CredentialCache.DefaultCredentials;
                        // Get the response.
                        WebResponse response = request.GetResponse();
                        // Get the stream containing content returned by the server.
                        Stream dataStream = response.GetResponseStream();
                        // Open the stream using a StreamReader for easy access.
                        StreamReader reader = new StreamReader(dataStream);
                        // Read the content.
                        responseFromServer = reader.ReadToEnd();
                        // Display the content.

                        if (responseFromServer.IndexOf("ZERO_RESULTS") > -1)
                        {
                            //AddRowToLog("ZERO_RESULTS1  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");
                        }
                        else
                        {
                            JObject data = JsonConvert.DeserializeObject<JObject>(responseFromServer);

                            reader.Close();
                            response.Close();

                            if (responseFromServer.IndexOf("ZERO_RESULTS") == -1 && data["status"].ToString() == "\"OVER_QUERY_LIMIT\"")
                            {
                                //AddRowToLog("google answer: OVER_QUERY_LIMIT; " + data["error_message"].ToString());
                                //AddRowToLog("Stoping the program...");
                                //break;
                                return;
                            }

                            if (data["status"].ToString().IndexOf("ZERO_RESULTS") == -1 && responseFromServer.IndexOf("ZERO_RESULTS") == -1)
                            {
                                //lat lon
                                latlon2 = data["results"].Last["geometry"]["location"]["lat"].ToString() + "," + data["results"].Last["geometry"]["location"]["lng"].ToString();
                            }
                            else
                            {

                            }
                        }


                    }
                    catch (Exception ex)
                    {
                        //AddRowToLog("Local Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table; MSG: " + ex.Message.ToString() + "; responseFromServer: " + responseFromServer);
                    }

                    string myLatlng = ",center: myLatlng0";
                    string ScriptScr2 = " var myLatlng0 = new google.maps.LatLng(" + latlon1 + "); var myLatlng1 = new google.maps.LatLng(" + latlon2 + ");";
                    Road1 = latlon1 + ", " + latlon2;
                   
                    HeadCallRow1.InnerText = dt.Rows[0]["AgentName"].ToString();

                    ScriptScr = ScriptScr2 + " var infoWindows = []; var mapOptions = {zoom:15 " + myLatlng + ", mapTypeControlOptions:{mapTypeIds: [google.maps.MapTypeId.ROADMAP, google.maps.MapTypeId.HYBRID,google.maps.MapTypeId.SATELLITE]}};var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);" + ScriptScr;
                    if (latlon1 == "" || latlon2 == "")
                    {
                        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "msg1", "alert('לא נמצאו כתובות ללקוחות');", true);

                    }
                }
            }
        }
    }


}