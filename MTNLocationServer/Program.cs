using System;
using System.Data;
using System.IO;
using System.Net;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using MobiPlusTools;

namespace MTNLocationServer
{
    class Program : System.ServiceProcess.ServiceBase
    {
        public static string LogDirectory = @"c:\Loggeer\PushServer\";
        public static string LogFileName = @"LocationServer";

        public Program()
        {
           
        }

        static void Main(string[] args)
        {
            if (System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"] != null)
                LogDirectory = System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"].ToString();

            //while (true)
            if(true)
            {
                try
                {
                    bool IsProxy = false;// Convert.ToBoolean(System.Configuration.ConfigurationSettings.AppSettings["IsProxy"].ToString());

                    AddRowToLog("******************************** START ********************************************");
                    DataTable dt = DAL.DAL.LocationServer_GetData(System.Configuration.ConfigurationSettings.AppSettings["ConnectionStringLocation"].ToString());
                    if (dt != null)
                    {
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            string responseFromServer = "";
                            StreamReader reader = new StreamReader(new MemoryStream());
                            WebResponse response = null;
                            try
                            {
                                AddRowToLog("-------------------------------- Row number: " + (i + 1).ToString() + " --------------------------------------");
                                //WebRequest request = WebRequest.Create("http://www.waze.co.il/WAS/mozi?token=123&address=" + dt.Rows[i]["Address"].ToString() + " " + dt.Rows[i]["City"].ToString());
                                //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyBK8cEQfu8LDwkPihEjhQHcVlbEh_AIDqE&address=" + dt.Rows[i]["Address"].ToString() + "+" + dt.Rows[i]["City"].ToString() + "&sensor=false";
                                //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyBK8cEQfu8LDwkPihEjhQHcVlbEh_AIDqE&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//MobiPlusDubek@gmail.com
                                //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyAO6rjF3yWA4P_7ayRBz-mp6Zmvl15UwFc&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//MobiPlus77@gmail.com
                                //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyCFPq5BTkiZkMSxTCovlrhoeoll95P8AcA&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//PlusMobi77@gmail.com
                                //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyDXoVR4k1_tRdGM59ngY1dcMgMSbS0GbS0&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//YPlusMob55@gmail.com

                                //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyDXoVR4k1_tRdGM59ngY1dcMgMSbS0GbS0&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//YPlusMob55@gmail.com
                                //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyCFPq5BTkiZkMSxTCovlrhoeoll95P8AcA&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//PlusMobi77@gmail.com


                                //string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyAO6rjF3yWA4P_7ayRBz-mp6Zmvl15UwFc&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//MobiPlus77@gmail.com
                                string url = "https://maps.google.com/maps/api/geocode/json?key=AIzaSyCFPq5BTkiZkMSxTCovlrhoeoll95P8AcA&address=" + dt.Rows[i]["Address"].ToString() + "&sensor=false";//PlusMobi77@gmail.com


                                WebRequest request = WebRequest.Create(url);

                                if (dt.Rows[i]["Address"].ToString() != "")
                                {
                                    AddRowToLog("Connect to google...; " + url);
                                    if (IsProxy)
                                    {
                                        WebProxy myProxy = new WebProxy();
                                        // Obtain the Proxy Prperty of the  Default browser.  
                                        myProxy = (WebProxy)request.Proxy;

                                        request.Proxy = myProxy;
                                    }
                                    // If required by the server, set the credentials.
                                    request.Credentials = CredentialCache.DefaultCredentials;
                                    // Get the response.
                                    response = request.GetResponse();
                                    // Display the status.
                                    //Console.WriteLine(((HttpWebResponse)response).StatusDescription);
                                    AddRowToLog("google resonse status: " + ((HttpWebResponse)response).StatusDescription);
                                    // Get the stream containing content returned by the server.
                                    Stream dataStream = response.GetResponseStream();
                                    // Open the stream using a StreamReader for easy access.
                                    reader = new StreamReader(dataStream);
                                    // Read the content.
                                    responseFromServer = reader.ReadToEnd();
                                    // Display the content.
                                }
                                else
                                {
                                    responseFromServer = " ZERO_RESULTS";
                                    AddRowToLog("Address is Empty!!!");
                                }
                                if (responseFromServer.IndexOf("ZERO_RESULTS") > -1)
                                {

                                    DAL.DAL.LocationServer_AddLogLocations(System.Configuration.ConfigurationSettings.AppSettings["ConnectionStringLocation"].ToString(), dt.Rows[i]["CustCode"].ToString(),
                                        dt.Rows[i]["Address"].ToString().Replace("'", ""), dt.Rows[i]["City"].ToString().Replace("'", ""));

                                    AddRowToLog("ZERO_RESULTS1  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");

                                }
                                else
                                {

                                    JObject data = JsonConvert.DeserializeObject<JObject>(responseFromServer);

                                    reader.Close();
                                    response.Close();

                                    if (responseFromServer.IndexOf("ZERO_RESULTS") == -1 && data["status"].ToString() == "\"OVER_QUERY_LIMIT\"")
                                    {
                                        AddRowToLog("google answer: OVER_QUERY_LIMIT; " + data["error_message"].ToString());
                                        AddRowToLog("Stoping the program...");
                                        break;
                                    }

                                    if (data["status"].ToString().IndexOf("ZERO_RESULTS") == -1 && responseFromServer.IndexOf("ZERO_RESULTS") == -1)
                                    {
                                        if (DAL.DAL.LocationServer_AddLocation(System.Configuration.ConfigurationSettings.AppSettings["ConnectionStringLocation"].ToString(), dt.Rows[i]["CustCode"].ToString(),
                                            data["results"].Last["geometry"]["location"]["lat"].ToString(), data["results"].Last["geometry"]["location"]["lng"].ToString(), dt.Rows[i]["Address"].ToString(), dt.Rows[i]["City"].ToString(), dt.Rows[i]["name"].ToString()))
                                        {
                                            AddRowToLog("Added successfully CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table with values:" + data["results"].Last["geometry"]["location"]["lat"].ToString() + "; " + data["results"].Last["geometry"]["location"]["lng"].ToString());
                                        }
                                        else
                                        {
                                            AddRowToLog("Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table with values:" + data["results"].Last["geometry"]["location"]["lat"].ToString() + "; " + data["results"].Last["geometry"]["location"]["lng"].ToString());
                                        }
                                    }
                                    else
                                    {
                                        DAL.DAL.LocationServer_AddLocation(System.Configuration.ConfigurationSettings.AppSettings["ConnectionStringLocation"].ToString(), dt.Rows[i]["CustCode"].ToString(),"0","0", dt.Rows[i]["Address"].ToString(), dt.Rows[i]["City"].ToString(), dt.Rows[i]["name"].ToString());

                                        DAL.DAL.LocationServer_AddLogLocations(System.Configuration.ConfigurationSettings.AppSettings["ConnectionStringLocation"].ToString(), dt.Rows[i]["CustCode"].ToString(),
                                            dt.Rows[i]["Address"].ToString(), dt.Rows[i]["City"].ToString());

                                        AddRowToLog("ZERO_RESULTS  - Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table");
                                    }
                                }


                            }
                            catch (Exception ex)
                            {
                                AddRowToLog("Local Error Added CustKey: " + dt.Rows[i]["CustCode"].ToString() + " to Location table; MSG: " + ex.Message.ToString() + "; responseFromServer: " + responseFromServer);
                            }
                            RowNum++;
                        }

                        AddRowToLog("******************************** END ********************************************");
                        //Thread.Sleep(Convert.ToInt32(System.Configuration.ConfigurationSettings.AppSettings["ServerMaxRoundWaitTime"].ToString()));
                    }
                }
                catch (Exception ex)
                {
                    Tools.AddRowToLog("Global Error, MSG: "+ex.Message.ToString(), Program.LogDirectory, Program.LogFileName);
                }
            }
        }
        private static int RowNum = 1;
        private static void AddRowToLog(string msg)
        {            
            Console.WriteLine(msg);            
            Tools.AddRowToLog("RowNum: "+ RowNum.ToString()+"; " + msg, Program.LogDirectory, Program.LogFileName);
           
        }
    }
}
