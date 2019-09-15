using System;
using WebSocketSharp.Server;
using System.Collections.Generic;
using System.Data;
using PushServer.MPService;
using System.Threading;
using MobiPlusTools;

namespace MobiPlusServer
{
    [Serializable]
    public class Program //: System.ServiceProcess.ServiceBase
    {        
        public static CacheHandler.CacheObj cacheObj;
        private static int LoopTime = 2000;
        public const string ServiceName1 = "PushServerService";
        //sc.exe delete PushServerService
        //sc create PushServerService binpath= "C:\Projects\MobiPlus_Solution\PushServer\bin\Debug\PushServer.exe"
        private static bool isRunning = false;
        private static int ServerSendMaxRound = 10;
        private static long ServerMaxRoundWaitTime = 30000;
        public static string LogDirectory = @"c:\Loggeer\PushServer\";
        public static string LogFileName = @"PushServer";
        public static string TimeToCheckInMinutes = "10";
        public static bool isToCheckBlocked = false;

        public Program()
        {
           // this.ServiceName = ServiceName1;
            if (System.Configuration.ConfigurationSettings.AppSettings["ServerLoopTime"].ToString() != "")
                LoopTime = Convert.ToInt32(System.Configuration.ConfigurationSettings.AppSettings["ServerLoopTime"].ToString());

            if (System.Configuration.ConfigurationSettings.AppSettings["ServerSendMaxRound"] != null)
                ServerSendMaxRound = Convert.ToInt32(System.Configuration.ConfigurationSettings.AppSettings["ServerSendMaxRound"].ToString());

            if (System.Configuration.ConfigurationSettings.AppSettings["ServerMaxRoundWaitTime"] != null)
                ServerMaxRoundWaitTime = Convert.ToInt64(System.Configuration.ConfigurationSettings.AppSettings["ServerMaxRoundWaitTime"].ToString());

            if (System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"] != null)
                LogDirectory = System.Configuration.ConfigurationSettings.AppSettings["LogDirectory"].ToString();

            if (System.Configuration.ConfigurationSettings.AppSettings["TimeToCheckInMinutes"] != null)
                TimeToCheckInMinutes = System.Configuration.ConfigurationSettings.AppSettings["TimeToCheckInMinutes"].ToString();

            if (System.Configuration.ConfigurationSettings.AppSettings["isToCheckBlocked"] != null)
                isToCheckBlocked = Convert.ToBoolean(System.Configuration.ConfigurationSettings.AppSettings["isToCheckBlocked"].ToString());
        }
        ~Program()
        {
            MobiPlusService WR = new MobiPlusService();
            
            WR.ClearDicManagersConnectedPushServer();
        }
        //protected override void OnStart(string[] args)
        //{
        //    Thread t = new Thread(Program.Start);
        //    t.Start();
        //}



        //protected override void OnStop()
        //{
        //    Tools.AddRowToLog("*******************Service Stopped******************", LogDirectory, LogFileName);

        //    MobiPlusService WR = new MobiPlusService();
        //    WR.ClearDicManagersConnectedPushServer();

        //    Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get("AllConnections");
        //    string[] arr = new string[Dic.Count];
        //    Dic.Keys.CopyTo(arr, 0);
        //    for (int i = 0; i < arr.Length; i++)
        //    {
        //        object d;
        //        if (Dic.TryGetValue(arr[i], out d))
        //        {
        //            PushServer c = (PushServer)d;
        //            c.Disconnct(c);
        //            Tools.AddRowToLog(arr[i] + " Disconnect on stop", LogDirectory, LogFileName);
        //        }
        //    }

        //    Dictionary<string, object> DicManagers = (Dictionary<string, object>)Program.cacheObj.Get("AllManagersConnections");
        //    arr = new string[DicManagers.Count];
        //    DicManagers.Keys.CopyTo(arr, 0);
        //    for (int i = 0; i < arr.Length; i++)
        //    {
        //        object d;
        //        if (DicManagers.TryGetValue(arr[i], out d))
        //        {
        //            PushServer c = (PushServer)d;
        //            c.Disconnct(c);
        //            Tools.AddRowToLog("Manager " + arr[i] + " Disconnect  on stop", LogDirectory, LogFileName);
        //        }
        //    }

        //    Program.Stop();
        //}

        public static void Start()
        {
            try
            {
                Tools.AddRowToLog("\r\n************************** Start **************************", LogDirectory, LogFileName);
                MobiPlusService WR = new MobiPlusService();
                isRunning = true;
                if (cacheObj == null)
                    cacheObj = new CacheHandler.CacheObj();

                var wssv = new WebSocketServer("ws://" + System.Configuration.ConfigurationSettings.AppSettings["ServerHost"].ToString() + ":" + System.Configuration.ConfigurationSettings.AppSettings["ServerPort"].ToString() + "");
                //var wssv = new WebSocketServer("wss://10.0.0.85");

                //wssv.Certificate = new X509Certificate2(@"C:\Projects\MobiPlus_Solution\cert1.pfx","mtns");
                wssv.KeepClean = true;
                wssv.ReuseAddress = true;
                 ////wssv.AddWebSocketService<PushServer>("/PushServer");

                wssv.AddWebSocketService<PushServer>(
                  "/PushServer",
                  () => new PushServer() { Protocol = "soap" });


#if DEBUG
                // Changing the logging level
                ////wssv.Log.Level = LogLevel.Trace;
#endif
                /* For Secure Connection
      var cert = ConfigurationManager.AppSettings ["ServerCertFile"];
      var password = ConfigurationManager.AppSettings ["ServerHost"];
      wssv.Certificate = new X509Certificate2 (cert, password);
       */

                /* For HTTP Authentication (Basic/Digest)
                wssv.AuthenticationSchemes = AuthenticationSchemes.Basic;
                wssv.Realm = "WebSocket Test";
                wssv.UserCredentialsFinder = identity => {
                  var expected = "nobita";
                  return identity.Name == expected
                         ? new NetworkCredential (expected, "password", "gunfighter")
                         : null;
                };
                 */

                // Not to remove inactive clients periodically
                //wssv.KeepClean = false;

                // Adding WebSocket services
                //wssv.AddWebSocketService<Echo>("/Echo");

                wssv.Start();
                Tools.AddRowToLog("AddWebSocketService Start", LogDirectory, LogFileName);
                if (wssv.IsListening)
                {
                    Tools.AddRowToLog("WebSocket push server listening on port: " + wssv.Port.ToString() + ", providing services:", LogDirectory, LogFileName);

                    foreach (var path in wssv.WebSocketServices.Paths)
                        Tools.AddRowToLog("path: " + path.ToString(), LogDirectory, LogFileName);
                }
                long countRownds = 0;
                while (isRunning)
                {
                    try
                    {
                        long counter = 0;
                        Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get("AllConnections");

                        if (Dic != null)
                        {
                            DataTable dt = (DataTable)Program.cacheObj.Get("AllMsgs");

                            if (WR.isToRefreshCacheFunc())
                            {
                                cacheObj.Remove("AllMsgs");
                                dt = null;
                                Tools.AddRowToLog("Refreshing the cache", LogDirectory, LogFileName);
                            }

                            dt = WR.GetServerPushFiles();
                            cacheObj.Add("AllMsgs", dt);

                            DataTable dt2 = dt;
                            bool hasRowsLog = false;

                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                bool isToDelete = false;

                                //copy ws agents connected 
                                Dictionary<string, object>.KeyCollection arr = Dic.Keys;
                                string[] arrAllConnectedWS = new string[arr.Count];
                                arr.CopyTo(arrAllConnectedWS, 0);

                                for (int y = 0; y < arrAllConnectedWS.Length; y++)
                                {
                                    string[] arrDBAgent = dt.Rows[i]["AgentID"].ToString().Split(';');
                                    string[] arrConnectedAgent = arrAllConnectedWS[y].Split(';');
                                    object d;

                                    if (arrDBAgent.Length > 0 && arrConnectedAgent.Length > 0 && Convert.ToInt32(arrConnectedAgent[0]) == Convert.ToInt32(arrDBAgent[0]) && dt.Rows[i]["Message"].ToString().IndexOf("DeleteTablet") == -1)
                                    {

                                        if (Dic.TryGetValue(arrAllConnectedWS[y], out d))
                                        {
                                            if (!hasRowsLog)
                                            {
                                                hasRowsLog = true;
                                                if (dt != null && dt.Rows.Count > 0)
                                                    Tools.AddRowToLog("Rows Found: " + dt.Rows.Count.ToString(), LogDirectory, LogFileName);
                                            }

                                            Tools.AddRowToLog("Found Agent: " + arrAllConnectedWS[y], LogDirectory, LogFileName);

                                            if (counter > 0 && counter % ServerSendMaxRound == 0)
                                            {
                                                Tools.AddRowToLog("Server maximum rounds reached(" + counter.ToString() + ") - Wait: " + (ServerMaxRoundWaitTime / 1000).ToString() + " seconds", LogDirectory, LogFileName);
                                                Thread.Sleep(Convert.ToInt32(ServerMaxRoundWaitTime));
                                            }

                                            PushServer c = (PushServer)d;
                                            if (dt.Rows[i]["Message"].ToString().IndexOf("DeleteTablet") == -1)//push org
                                            {
                                                c.sendMSG(dt.Rows[i]["PushID"].ToString() + ";" + dt.Rows[i]["Message"].ToString(), arrAllConnectedWS[y]);
                                                isToDelete = true;
                                                counter++;
                                                Tools.AddRowToLog(counter.ToString() + "- Send message: " + dt.Rows[i]["PushID"].ToString() + ";" + dt.Rows[i]["Message"].ToString() + "; to: " + arrAllConnectedWS[y], LogDirectory, LogFileName);
                                            }


                                        }
                                    }
                                    else if (isToCheckBlocked && dt.Rows[i]["Message"].ToString().IndexOf("DeleteTablet") > -1)//delete tablet
                                    {
                                        if (Dic.TryGetValue(arrAllConnectedWS[y], out d))
                                        {
                                            PushServer c = (PushServer)d;
                                            string[] arrMSG = dt.Rows[i]["Message"].ToString().Split(';');

                                            if (arrMSG.Length > 1)
                                            {
                                                
                                                if (arrMSG[1] == arrConnectedAgent[1])//same hw
                                                {
                                                    Tools.AddRowToLog(counter.ToString() + "- SarrMSG[1]: " + arrMSG[1].ToString() + ";arrConnectedAgent[1]: " + arrConnectedAgent[1], LogDirectory, LogFileName);
                                                    c.sendMSG(dt.Rows[i]["PushID"].ToString() + ";" + "DeleteTablet", arrAllConnectedWS[y]);
                                                    isToDelete = true;
                                                    counter++;
                                                    Tools.AddRowToLog(counter.ToString() + "- Send message: " + dt.Rows[i]["PushID"].ToString() + ";DeleteTablet; to: " + arrAllConnectedWS[y], LogDirectory, LogFileName);
                                                }
                                            }
                                        }
                                    }
                                }
                                if (isToDelete)
                                {
                                    //remove current agent from the loop and cache
                                    Tools.AddRowToLog("Remove message: (" + dt.Rows[i]["AgentID"].ToString() + "; " + dt.Rows[i]["Message"].ToString() + ") from the cache", LogDirectory, LogFileName);
                                    WR.DeleteServerPushFile(dt2.Rows[i]["PushID"].ToString());

                                    DataView dv = dt.DefaultView;
                                    dv.RowFilter = "AgentID<>'" + dt.Rows[i]["AgentID"].ToString() + "'";

                                    DataTable dt3 = dv.ToTable();

                                    cacheObj.Update("AllMsgs", dt3);

                                }
                            }

                        }
                        Thread.Sleep(LoopTime);


                        if (countRownds % 75 == 0)
                        {
                            if (WR.SetServerPushFilesAgain(TimeToCheckInMinutes))
                            {
                                Tools.AddRowToLog("Set Server Push Files Send Again;Found Messages", LogDirectory, LogFileName);
                                WR.UpdateCache_ServerPushFiles();
                            }
                            else
                            {
                                Tools.AddRowToLog("Set Server Push Files Send Again;Not Found Messages", LogDirectory, LogFileName);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Tools.AddRowToLog("Error occurred:" + ex.ToString(), LogDirectory, LogFileName);
                    }
                    countRownds++;
                }

                wssv.Stop();
            }
            catch (Exception ex)
            {
                Tools.AddRowToLog("Error occurred:" + ex.ToString(), LogDirectory, LogFileName);
            }
            Tools.AddRowToLog("************************** Stoped **************************", LogDirectory, LogFileName);
        }

        private static void Stop()
        {
            isRunning = false;
            Tools.AddRowToLog("Service stoped", LogDirectory, LogFileName);
        }
        public static void Main(string[] args)
        {
            System.ServiceProcess.ServiceBase[] ServicesToRun;

            //ServicesToRun = new System.ServiceProcess.ServiceBase[] { new Program() };
            //System.ServiceProcess.ServiceBase.Run(ServicesToRun);

            Thread t = new Thread(Program.Start);
            t.Start();
        }
    }

}
