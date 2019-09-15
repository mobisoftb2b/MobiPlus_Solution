using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Security.Cryptography;
using System.Runtime.InteropServices;
using MobiPlusTools;
using WSServer.MPService;
using System.Data;
using System.Timers;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;


namespace WSServer
{
    [Serializable]
    public class Program : System.ServiceProcess.ServiceBase
    {
        private static byte[] buffer = new byte[1024];
        private static Socket serverSocket = new Socket(AddressFamily.InterNetwork,
        SocketType.Stream, ProtocolType.IP);
        private static string guid = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
        private static Socket[] Clients = new Socket[10];
        private static int counbter = 0;
        private static IPAddress localIPAdress;
        private static int port = 8098;
        private static Thread thread;
        private static Thread threadStayAWake;
        private static Thread threadClosing;
        private static StateObject myState = null;
        private static StateObject myStateManager = null;
        private static SocketAsyncEventArgs saea = null;
        private static SocketAsyncEventArgs saeaManager = null;

        public static CacheHandler.CacheObj cacheObj;
        private static int LoopTime = 2000;
        public const string ServiceName1 = "WSServerService";
        //sc.exe delete PushServerService
        //sc create PushServerService binpath= "C:\Projects\MobiPlus_Solution\PushServer\bin\Debug\PushServer.exe"
        private static bool isRunning = false;
        private static int ServerSendMaxRound = 10;
        private static long ServerMaxRoundWaitTime = 30000;
        public static string LogDirectory = @"c:\Loggeer\WSServer\";
        public static string LogFileName = @"WSServer";
        public static string TimeToCheckInMinutes = "10";
        public static bool isToCheckBlocked = false;
        private static string DicConnectionsName = "AllConnections";
        private static string DicManagersConnectionsName = "AllManagersConnections";
        public static short ServerSocketTtl = 30;
        public static short CheckSocketTtl = 1;
        private static MobiPlusService WR = new MobiPlusService();
        private static string DisconectReason = "";
        private static Dictionary<string, ObjConnected> DicAllSessions = new Dictionary<string, ObjConnected>();
        private static Dictionary<string, ObjConnected> DicAllSessionsAgents = new Dictionary<string, ObjConnected>();
        private static string SessionTimeOut = "600";
        private static object obj = new object();

        protected override void OnStart(string[] args)
        {
            Tools.AddRowToLog("*******************Service Start******************", LogDirectory, LogFileName);
            Thread t = new Thread(start);
            t.Start();
        }



        protected override void OnStop()
        {
            isRunning = false;
            Tools.AddRowToLog("*******************Service Stopped******************", LogDirectory, LogFileName);
        }

        public Program()
        {
            this.ServiceName = ServiceName1;
            if (System.Configuration.ConfigurationSettings.AppSettings["WebServiceURL"].ToString() != "")
                WR.Url = System.Configuration.ConfigurationSettings.AppSettings["WebServiceURL"].ToString();

            if (System.Configuration.ConfigurationSettings.AppSettings["SessionTimeOut"].ToString() != "")
                SessionTimeOut = System.Configuration.ConfigurationSettings.AppSettings["SessionTimeOut"].ToString();

        }
        private static void CurrentDomain_ProcessExit(object sender, EventArgs e)
        {
            Console.WriteLine("exit");
            //Console.Read();
        }

        static bool exitSystem = false;

        #region Trap application termination
        [DllImport("Kernel32")]
        private static extern bool SetConsoleCtrlHandler(EventHandler handler, bool add);

        private delegate bool EventHandler(CtrlType sig);
        static EventHandler _handler;

        enum CtrlType
        {
            CTRL_C_EVENT = 0,
            CTRL_BREAK_EVENT = 1,
            CTRL_CLOSE_EVENT = 2,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT = 6
        }
        private static void StayAWake()
        {
            long counter = 0;
            while (isRunning)
            {
                try
                {
                    Console.WriteLine("StayAWake: " + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"));
                    Console.WriteLine("");

                    Tools.AddRowToLog("WSServer StayAWake", Program.LogDirectory, Program.LogFileName);
                    if (DicAllSessions != null && DicAllSessions.Values != null && DicAllSessions.Values.Count > 0 && counter % 5 == 0)
                    {
                        counter = 0;
                        // Thread.Sleep(10000);
                        Dictionary<string, ObjConnected>.ValueCollection arr7 = DicAllSessions.Values;
                        ObjConnected[] arrAllConnectedWS2 = new ObjConnected[arr7.Count];
                        arr7.CopyTo(arrAllConnectedWS2, 0);

                        Dictionary<string, ObjConnected>.KeyCollection arr2 = DicAllSessions.Keys;
                        string[] arrCon2 = new string[arr2.Count];
                        arr2.CopyTo(arrCon2, 0);


                        for (int i = 0; i < arrAllConnectedWS2.Length; i++)
                        {
                            try
                            {
                                SocketConnected(((ObjConnected)arrAllConnectedWS2[i]).clientSocket, arrCon2[i], false);
                            }
                            catch (Exception ex)
                            {
                            }
                        }

                    }
                }
                catch (Exception ex)
                {
                }


                try
                {
                    Console.WriteLine("StayAWake: " + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"));
                    Console.WriteLine("");

                    Tools.AddRowToLog("WSServer StayAWake", Program.LogDirectory, Program.LogFileName);
                    if (DicAllSessionsAgents != null && DicAllSessionsAgents.Values != null && DicAllSessionsAgents.Values.Count > 0)
                    {
                        // Thread.Sleep(10000);
                        Dictionary<string, ObjConnected>.ValueCollection arr7 = DicAllSessionsAgents.Values;
                        ObjConnected[] arrAllConnectedWS2 = new ObjConnected[arr7.Count];
                        arr7.CopyTo(arrAllConnectedWS2, 0);

                        Dictionary<string, ObjConnected>.KeyCollection arr2 = DicAllSessionsAgents.Keys;
                        string[] arrCon2 = new string[arr2.Count];
                        arr2.CopyTo(arrCon2, 0);

                        for (int i = 0; i < arrAllConnectedWS2.Length; i++)
                        {
                            try
                            {
                                SocketConnected(((ObjConnected)arrAllConnectedWS2[i]).clientSocket, arrCon2[i], true);
                            }
                            catch (Exception ex)
                            {
                            }
                        }

                    }
                }
                catch (Exception ex)
                {
                }
                counter++;
                Thread.Sleep(1000 * 10 * 1);//10 sec
            }
        }
        private static bool Handler(CtrlType sig)
        {
            Console.WriteLine("Exiting system due to external CTRL-C, or process kill, or shutdown");
            Console.WriteLine("");

            string disconectReason = " Client close connection 5";
            Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
            if (Dic != null && Dic.Values != null && Dic.Values.Count > 0)
            {
                Dictionary<string, object>.ValueCollection arr = Dic.Values;
                Socket[] arrAllConnectedWS = new Socket[arr.Count];
                arr.CopyTo(arrAllConnectedWS, 0);

                Dictionary<string, object>.KeyCollection arr2 = Dic.Keys;
                string[] arrCon2 = new string[arr2.Count];
                arr2.CopyTo(arrCon2, 0);


                for (int i = 0; i < arrAllConnectedWS.Length; i++)
                {
                    try
                    {
                        if (!((Socket)arrAllConnectedWS[i]).Connected)
                            OnClose(arrCon2[i], "", disconectReason);
                    }
                    catch (Exception ex)
                    {
                    }
                }
                Thread.Sleep(5000); //simulate some cleanup delay
            }
            Console.WriteLine("Cleanup complete");

            //allow main to run off
            exitSystem = true;

            //shutdown right away so there are no lingering threads
            Environment.Exit(-1);

            return true;
        }
        #endregion
        public static void start()
        {
            Main(null);
        }

        static void Main(string[] args)
        {
            System.ServiceProcess.ServiceBase[] ServicesToRun;

            ServicesToRun = new System.ServiceProcess.ServiceBase[] { new Program() };
            System.ServiceProcess.ServiceBase.Run(ServicesToRun);



            // Some biolerplate to react to close window event, CTRL-C, kill, etc
            _handler += new EventHandler(Handler);
            SetConsoleCtrlHandler(_handler, true);

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

            if (System.Configuration.ConfigurationSettings.AppSettings["ServerSocketTtl"] != null)
                ServerSocketTtl = Convert.ToInt16(System.Configuration.ConfigurationSettings.AppSettings["ServerSocketTtl"].ToString());

            if (System.Configuration.ConfigurationSettings.AppSettings["CheckSocketTtl"] != null)
                CheckSocketTtl = Convert.ToInt16(System.Configuration.ConfigurationSettings.AppSettings["CheckSocketTtl"].ToString());


            port = Convert.ToInt32(System.Configuration.ConfigurationSettings.AppSettings["ServerPort"].ToString());
            string ip = System.Configuration.ConfigurationSettings.AppSettings["ServerHost"].ToString();
            localIPAdress = IPAddress.Parse(ip); //Dns.GetHostAddresses("").Where(i => i.AddressFamily == AddressFamily.InterNetwork).First();

            saea = new SocketAsyncEventArgs();
            saea.Completed += new EventHandler<SocketAsyncEventArgs>(saea_Completed);

            saeaManager = new SocketAsyncEventArgs();
            saeaManager.Completed += new EventHandler<SocketAsyncEventArgs>(saea_Completed_Manager);

            // saeaManager.AcceptSocket.IsConnected


            Tools.AddRowToLog("\r\n************************** Start **************************", LogDirectory, LogFileName);

            Tools.AddRowToLog("WebSocket WSServer by MobiSoft listening on ws::" + ip + " port: " + port.ToString() + ";", LogDirectory, LogFileName);


            serverSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.KeepAlive, 1);
            //serverSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.DontRoute, 1);
            serverSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, 1);
            serverSocket.LingerState = new LingerOption(true, 10);
            serverSocket.NoDelay = true;
            serverSocket.ReceiveTimeout = 1000;
            serverSocket.SendTimeout = 1000;
            serverSocket.Ttl = ServerSocketTtl;

            serverSocket.Bind(new IPEndPoint(localIPAdress, port));
            serverSocket.Listen(128);
            serverSocket.BeginAccept(null, 0, OnAccept, null);



            isRunning = true;
            thread = new Thread(new ThreadStart(PushServer));
            thread.Start();

            threadStayAWake = new Thread(new ThreadStart(StayAWake));
            threadStayAWake.Start();

            threadClosing = new Thread(new ThreadStart(ListenToClosing));
            threadClosing.Start();

            Console.Read();



            //hold the console so it doesn’t run off the end
            while (!exitSystem)
            {
                Thread.Sleep(500);
            }


        }

        private static void OnDisconnect(IAsyncResult result)
        {
        }
        private static void OnSend(IAsyncResult result)
        {
        }
        private static void socket_SocketClosed(Socket socket)
        {
            // do what you want
        }
        private static void OnAccept(IAsyncResult result)
        {
            Socket client = null;
            var AgentID = "";
            StateObject state = new StateObject();
            try
            {
                string headerResponse = "";
                if (serverSocket != null && serverSocket.IsBound)
                {
                    int index = 0;
                    for (int i2 = 0; i2 < Clients.Length; i2++)
                    {
                        if (Clients[i2] == null || (Clients[i2] != null && !Clients[i2].Connected))
                        {
                            index = i2;
                            break;
                        }
                    }
                    client = serverSocket.EndAccept(result);

                    int size = Marshal.SizeOf(new uint());

                    var inOptionValues = new byte[size * 3];

                    BitConverter.GetBytes((uint)(1)).CopyTo(inOptionValues, 0);
                    BitConverter.GetBytes((uint)100).CopyTo(inOptionValues, size);
                    BitConverter.GetBytes((uint)100).CopyTo(inOptionValues, size * 2);

                    ((Socket)client).IOControl(IOControlCode.KeepAliveValues, inOptionValues, null);



                    //var socket = new CustomSocket(client.AddressFamily,client.SocketType,client.ProtocolType);

                    //socket.SocketClosed += socket_SocketClosed;
                    //socket.EventsEnabled = true;




                    if (client.Connected)
                    {
                        //serverSocket.Begin(true, OnDisconnect, null);

                        var i = client.Receive(buffer);
                        try
                        {
                            headerResponse = (System.Text.Encoding.UTF8.GetString(buffer)).Substring(0, i);
                            // write received data to the console
                            Console.WriteLine(headerResponse);
                        }
                        catch (Exception ex)
                        {
                            headerResponse = "";
                        }
                        if (headerResponse.Length > 0 && headerResponse.IndexOf("MobiPlusService") == -1)
                        {
                            Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                            Dictionary<string, object> DicManagers = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                            try
                            {
                                if (headerResponse.Replace("NewWS=true&", "").IndexOf("HTTP/1.1") == -1)
                                    AgentID = headerResponse.Replace("NewWS=true&", "").Substring(headerResponse.Replace("NewWS=true&", "").IndexOf("=") + 1, headerResponse.Replace("NewWS=true&", "").IndexOf("&") - 1 - headerResponse.Replace("NewWS=true&", "").IndexOf("="));
                                else
                                    AgentID = headerResponse.Replace("NewWS=true&", "").Substring(headerResponse.Replace("NewWS=true&", "").IndexOf("=") + 1, headerResponse.Replace("NewWS=true&", "").IndexOf(";") - 1 - headerResponse.Replace("NewWS=true&", "").IndexOf("=")) + ";";
                            }
                            catch (Exception ex)
                            {
                                AgentID = headerResponse;//se.IndexOf("&") - 1);
                            }
                            Tools.AddRowToLog(AgentID.ToString() + " Connected", Program.LogDirectory, Program.LogFileName);

                            if (headerResponse.IndexOf("ManagerID=") == -1)
                            {
                                if (Dic == null)
                                    Dic = new Dictionary<string, object>();
                                object d;
                                if (Dic.TryGetValue(AgentID, out d))
                                    Dic[AgentID] = client;
                                else
                                    Dic.Add(AgentID, client);

                                try
                                {
                                    ObjConnected c;
                                    if (DicAllSessionsAgents.TryGetValue(AgentID, out c))
                                        DicAllSessionsAgents[AgentID] = new ObjConnected(client);
                                    else
                                        DicAllSessionsAgents.Add(AgentID, new ObjConnected(client));
                                }
                                catch (Exception ex)
                                {

                                }

                                if (Program.cacheObj.Get(DicConnectionsName) == null)
                                    Program.cacheObj.Add(DicConnectionsName, Dic);
                                else
                                    Program.cacheObj.Update(DicConnectionsName, Dic);

                                Tools.AddRowToLog("Agent:" + AgentID.ToString() + " Connect", Program.LogDirectory, Program.LogFileName);
                                state.IsManager = false;

                                try
                                {
                                    ObjConnected c;
                                    if (DicAllSessions.TryGetValue(AgentID, out c))
                                        DicAllSessions[AgentID] = new ObjConnected(client);
                                    else
                                        DicAllSessions.Add(AgentID, new ObjConnected(client));
                                }
                                catch (Exception ex)
                                {

                                }

                            }
                            else
                            {
                                bool IsAlreadyFillFromPushServer = false;
                                WR.AddToDicManagersConnectedPushServer(AgentID.ToString(), out IsAlreadyFillFromPushServer);
                                string[] arrManagersConnected = new string[0];
                                if (DicManagers != null)
                                {
                                    arrManagersConnected = new string[DicManagers.Keys.Count];
                                    DicManagers.Keys.CopyTo(arrManagersConnected, 0);
                                }

                                if (DicManagers == null)
                                    DicManagers = new Dictionary<string, object>();
                                //object d;
                                //if (DicManagers.TryGetValue(AgentID+"_0", out d))
                                //{
                                //    if (d == client)
                                //    {
                                //        DicManagers[AgentID + "_0"] = client;
                                //    }
                                //    else
                                //    {
                                //        DicManagers.Add(AgentID + "_" + DicManagers.Count.ToString(), client);
                                //    }
                                //}
                                //else
                                //{
                                //    DicManagers.Add(AgentID + "_" + DicManagers.Count.ToString(), client);
                                //}
                                DicManagers.Add(AgentID + "_" + DateTime.Now.Ticks.ToString(), client);

                                try
                                {
                                    ObjConnected c;
                                    if (DicAllSessions.TryGetValue(AgentID + "_" + DateTime.Now.Ticks.ToString(), out c))
                                        DicAllSessions[AgentID + "_" + DateTime.Now.Ticks.ToString()] = new ObjConnected(client);
                                    else
                                        DicAllSessions.Add(AgentID + "_" + DateTime.Now.Ticks.ToString(), new ObjConnected(client));
                                }
                                catch (Exception ex)
                                {

                                }

                                if (Program.cacheObj.Get(DicManagersConnectionsName) == null)
                                    Program.cacheObj.Add(DicManagersConnectionsName, DicManagers);
                                else
                                    Program.cacheObj.Update(DicManagersConnectionsName, DicManagers);

                                Tools.AddRowToLog("Manager:" + AgentID.ToString() + " Connect", Program.LogDirectory, Program.LogFileName);
                                state.IsManager = true;
                                if (!IsAlreadyFillFromPushServer)
                                {
                                    StringBuilder sb = new StringBuilder();
                                    for (int t = 0; t < arrManagersConnected.Length; t++)
                                    {
                                        sb.Append(arrManagersConnected[t].Split(';')[0] + ";");
                                    }

                                    WR.FillAllFromPushServer(sb.ToString());
                                }
                            }


                        }
                        // Create the state object.

                        state.workSocket = client;

                        Clients[index] = client;
                        counbter++;
                        if (counbter > 9)
                            counbter = 0;


                    }
                    if (client != null)
                    {
                        /* Handshaking and managing ClientSocket */
                        var key = "";
                        try
                        {
                            key = headerResponse.Replace("ey:", "`")
                                      .Split('`')[1]                     // dGhlIHNhbXBsZSBub25jZQ== \r\n .......
                                      .Replace("\r", "").Split('\n')[0]  // dGhlIHNhbXBsZSBub25jZQ==
                                      .Trim();
                        }
                        catch (Exception ex)
                        {
                            key = "dGhlIHNhbXBsZSBub25jZQ==";
                        }
                        // key should now equal dGhlIHNhbXBsZSBub25jZQ==
                        var test1 = AcceptKey(ref key);

                        var newLine = "\r\n";

                        var response = "HTTP/1.1 101 Switching Protocols" + newLine
                             + "Upgrade: websocket" + newLine
                             + "Connection: Upgrade" + newLine
                             + "Sec-WebSocket-Accept: " + test1 + newLine + newLine
                             //+ "Sec-WebSocket-Protocol: chat, superchat" + newLine
                             //+ "Sec-WebSocket-Version: 13" + newLine
                             ;

                        // which one should I use? none of them fires the onopen method 
                        if (client.Connected)
                            client.Send(System.Text.Encoding.UTF8.GetBytes(response));


                        state.UserToken = AgentID;
                        if (client.Connected)
                        {

                            client.BeginReceive(state.buffer, 0, 1024, 0
                                                      , new AsyncCallback(OnReceive), state);
                        }
                    }
                }
            }
            catch (SocketException ex)
            {
                Tools.AddRowToLog("Error occurred (OnAccept - SocketException):" + ex.ToString(), LogDirectory, LogFileName);
                try
                {
                    OnAccept(result);
                }
                catch (Exception ex1)
                { }

            }
            catch (Exception ex)
            {
                Tools.AddRowToLog("Error occurred (OnAccept - Exception):" + ex.ToString(), LogDirectory, LogFileName);
            }
            finally
            {
                try
                {
                    if (serverSocket != null && serverSocket.IsBound)
                    {
                        serverSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.KeepAlive, 1);
                        serverSocket.LingerState = new LingerOption(true, 10);
                        serverSocket.NoDelay = true;
                        serverSocket.ReceiveTimeout = 1000;
                        serverSocket.SendTimeout = 1000;
                        serverSocket.Ttl = ServerSocketTtl;
                        serverSocket.BeginAccept(null, 0, OnAccept, null);
                    }
                }
                catch (Exception ex)
                {
                    Tools.AddRowToLog("Error occurred finally (OnAccept - Exception):" + ex.ToString(), LogDirectory, LogFileName);
                }
            }

            Tools.AddRowToLog(DicAllSessions.Count.ToString("N0") + " Users connected", LogDirectory, LogFileName);
        }
        private static string getVal(string val)
        {
            return val.Replace("\"", "").Replace("'", "");
        }
        private static bool IsManagerConnected(string ManagerID)
        {
            Dictionary<string, object> DicManagers = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
            if (DicManagers == null)
                DicManagers = new Dictionary<string, object>();

            string[] arrConnected = new string[DicManagers.Keys.Count];
            DicManagers.Keys.CopyTo(arrConnected, 0);

            for (int i = 0; i < arrConnected.Length; i++)
            {
                if (arrConnected[i].IndexOf(ManagerID + ";") == 0)//found
                {
                    return true;
                }
            }

            return false;
        }
        public static string GetJson(DataTable dt)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new

            System.Web.Script.Serialization.JavaScriptSerializer();
            List<Dictionary<string, object>> rows =
              new List<Dictionary<string, object>>();
            Dictionary<string, object> row = null;

            serializer.MaxJsonLength = Int32.MaxValue;

            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    if (col.DataType == typeof(String))
                        row.Add(col.ColumnName.Trim(), Uri.EscapeDataString(dr[col].ToString().Replace("'", "").Replace("\"", "''").Replace("\\", "/")));
                    else
                        row.Add(col.ColumnName.Trim(), dr[col]);
                }
                rows.Add(row);
            }
            return serializer.Serialize(rows);
        }
        private static void AfterSend(IAsyncResult result)
        {
            try
            {
                Thread.Sleep(10000);
                ((ObjConnected)DicAllSessions[((StateObject)result.AsyncState).UserToken]).clientSocket.Shutdown(SocketShutdown.Both);
                ((ObjConnected)DicAllSessions[((StateObject)result.AsyncState).UserToken]).clientSocket.Close();
                // ((ObjConnected)DicAllSessions[((StateObject)result.AsyncState).UserToken]).clientSocket.Dispose();
                ((ObjConnected)DicAllSessions[((StateObject)result.AsyncState).UserToken]).clientSocket.Disconnect(true);


                ObjConnected r;
                if (DicAllSessions.TryGetValue(((StateObject)result.AsyncState).UserToken, out r))
                    DicAllSessions.Remove(((StateObject)result.AsyncState).UserToken);

                OnClose(((StateObject)result.AsyncState).UserToken, "", "Server close connection after send replay to agent");
            }
            catch (Exception ex)
            {
            }
        }
        public static bool SendWSMsg(string from, string to, string msg)
        {
            try
            {
                SendMSG(to, msg);
            }
            catch (Exception ex)
            {
                Tools.AddRowToLog("Error SendWSMsg (SendWSMsg - Exception (from: " + from + ")):" + ex.ToString(), LogDirectory, LogFileName);
                return false;
            }

            return true;
        }

        private static void OnReceive(IAsyncResult result)
        {
            StateObject myStateTmp = (StateObject)result.AsyncState;
            try
            {
                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                Dictionary<string, object> DicAgents = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                if (Dic != null)
                {
                    object val;
                    if (myStateTmp.buffer[0] == 0 && ((Dic != null && Dic.TryGetValue(myStateTmp.UserToken, out val)) || (DicAgents != null && DicAgents.TryGetValue(myStateTmp.UserToken, out val))))
                    {
                        ((Socket)myStateTmp.workSocket).Shutdown(SocketShutdown.Both);
                        ((Socket)myStateTmp.workSocket).Close();

                        if (myStateTmp.IsManager)
                            OnClose("", myStateTmp.UserToken, "Client Close Connection 6");
                        else
                            OnClose(myStateTmp.UserToken, "", "Client Close Connection 6");

                        return;
                    }
                }
            }
            catch (SocketException ex)
            {

            }
            catch (Exception ex1)
            {

            }

            try
            {
                string msg = "";
                Socket handler = myStateTmp.workSocket;
                if (handler.Connected)
                {
                    // Read data from the client socket. 
                    int bytesRead = handler.EndReceive(result);

                    int index = 2;
                    bool isClosed = false;
                    if (bytesRead > 0)
                    {
                        if (bytesRead > 125)
                        {
                            index = 4;
                        }
                        byte[] Key = new byte[4];
                        Buffer.BlockCopy(myStateTmp.buffer, index, Key, 0, 4);

                        var key = Key;

                        byte[] _data = new byte[bytesRead - 4 - index];
                        Buffer.BlockCopy(myStateTmp.buffer, 4 + index, _data, 0, bytesRead - 4 - index);

                        for (long i = 0; i < _data.Length; i++)
                            _data[i] = (byte)(_data[i] ^ key[i % 4]);

                        msg = System.Text.Encoding.UTF8.GetString(_data);

                        Console.WriteLine("Message: " + msg);
                        string userID = "0";
                        string headerResponse = (System.Text.Encoding.UTF8.GetString(buffer));


                        if (_data.Length == 2 && _data[0] == 3 && (_data[1] == 232 || _data[1] == 233))
                        {
                            Thread.Sleep(3000);

                            if (headerResponse.ToLower().IndexOf("managerid=") == -1)
                            {
                                string disconectReason = " Client close connection 1";
                                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                                if (Dic != null)
                                {


                                    Dictionary<string, object>.ValueCollection arr = Dic.Values;
                                    Socket[] arrAllConnectedWS = new Socket[arr.Count];
                                    arr.CopyTo(arrAllConnectedWS, 0);

                                    Dictionary<string, object>.KeyCollection arr2 = Dic.Keys;
                                    string[] arrCon2 = new string[arr2.Count];
                                    arr2.CopyTo(arrCon2, 0);


                                    for (int i = 0; i < arrAllConnectedWS.Length; i++)
                                    {
                                        if (((Socket)arrAllConnectedWS[i]) == handler)
                                        {
                                            OnClose(arrCon2[i], "", disconectReason);
                                            //OnClose("", arrCon2[i], disconectReason);
                                            isClosed = true;
                                            break;
                                        }
                                    }
                                }
                                else
                                {
                                    disconectReason = " Client close connection 2";
                                    Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                                    if (Dic != null)
                                    {
                                        if (headerResponse.ToLower().IndexOf("managerid=") > -1)
                                        {
                                            Dictionary<string, object>.ValueCollection arr = Dic.Values;
                                            Socket[] arrAllConnectedWS = new Socket[arr.Count];
                                            arr.CopyTo(arrAllConnectedWS, 0);

                                            Dictionary<string, object>.KeyCollection arr2 = Dic.Keys;
                                            string[] arrCon2 = new string[arr2.Count];
                                            arr2.CopyTo(arrCon2, 0);


                                            for (int i = 0; i < arrAllConnectedWS.Length; i++)
                                            {
                                                if (((Socket)arrAllConnectedWS[i]) == handler)
                                                {
                                                    OnClose(arrCon2[i], "", disconectReason);
                                                    isClosed = true;
                                                    break;
                                                }
                                            }
                                        }


                                    }

                                }

                            }
                            else
                            {
                                string disconectReason = " Client close connection 3";
                                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                                if (Dic != null)
                                {


                                    Dictionary<string, object>.ValueCollection arr = Dic.Values;
                                    Socket[] arrAllConnectedWS = new Socket[arr.Count];
                                    arr.CopyTo(arrAllConnectedWS, 0);

                                    Dictionary<string, object>.KeyCollection arr2 = Dic.Keys;
                                    string[] arrCon2 = new string[arr2.Count];
                                    arr2.CopyTo(arrCon2, 0);


                                    for (int i = 0; i < arrAllConnectedWS.Length; i++)
                                    {
                                        if (((Socket)arrAllConnectedWS[i]) == handler)
                                        {
                                            OnClose("", arrCon2[i], disconectReason);
                                            isClosed = true;
                                            break;
                                        }
                                    }
                                }
                                else
                                {
                                    disconectReason = " Client close connection 4";
                                    Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                                    if (Dic != null)
                                    {
                                        if (headerResponse.ToLower().IndexOf("managerid=") > -1)
                                        {
                                            Dictionary<string, object>.ValueCollection arr = Dic.Values;
                                            Socket[] arrAllConnectedWS = new Socket[arr.Count];
                                            arr.CopyTo(arrAllConnectedWS, 0);

                                            Dictionary<string, object>.KeyCollection arr2 = Dic.Keys;
                                            string[] arrCon2 = new string[arr2.Count];
                                            arr2.CopyTo(arrCon2, 0);


                                            for (int i = 0; i < arrAllConnectedWS.Length; i++)
                                            {
                                                if (((Socket)arrAllConnectedWS[i]) == handler)
                                                {
                                                    OnClose("", arrCon2[i], disconectReason);
                                                    isClosed = true;
                                                    break;
                                                }
                                            }
                                        }


                                    }

                                }
                            }
                        }
                        if (!isClosed)
                        {
                            if (msg.Length > 0)
                            {
                                //try
                                //{
                                //    SendMSG(msg.Substring(0, msg.IndexOf("&")), msg.Substring(msg.IndexOf("&") + 1, msg.Length - msg.IndexOf("&") - 1));
                                //}
                                //catch (Exception ex)
                                //{
                                //    Tools.AddRowToLog("Error occurred (SendMSG):" + ex.ToString(), LogDirectory, LogFileName);
                                //}




                                MobiPlusService WR = new MobiPlusService();
                                if (System.Configuration.ConfigurationSettings.AppSettings["WebServiceURL"] != null)
                                    WR.Url = (System.Configuration.ConfigurationSettings.AppSettings["WebServiceURL"].ToString());


                                string[] arrData = msg.Split(';');
                                try
                                {
                                    if (arrData.Length == 2 && arrData[0] == "isToManager")
                                    {
                                        myStateManager = myStateTmp;
                                        JObject data = JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(arrData[1]);

                                        string AgentID = getVal(data["AgentId"].ToString());
                                        if (AgentID.Length < 4)
                                            AgentID = AgentID.PadLeft(4, '0');

                                        WR.AddToPasswordManagerAsync(getVal(data["RequestID"].ToString()), getVal(data["pTime"].ToString()), AgentID, getVal(data["AgentName"].ToString()), getVal(data["EmployeeId"].ToString()), getVal(data["EmployeeName"].ToString()), getVal(data["ActivityCode"].ToString()), getVal(data["ActivityDescription"].ToString()), getVal(data["Cust_Key"].ToString()),
                                            getVal(data["CustName"].ToString()), getVal(data["DocType"].ToString()), getVal(data["DocName"].ToString()), getVal(data["Comment"].ToString()), getVal(data["ManagerEmployeeId"].ToString()), getVal(data["ManagerName"].ToString()), getVal(data["StatusChangeTime"].ToString()), getVal(data["RequestStatus"].ToString()), getVal(data["ManagerStatusTime"].ToString()), getVal(data["ManagerComment"].ToString()),
                                            getVal(data["ManagerDeviceType"].ToString()), getVal(data["TransmissionState"].ToString()), getVal(data["Subject"].ToString()), getVal(data["IsTest"].ToString()), getVal(data["DocNum"].ToString()));

                                        object d;
                                        Dictionary<string, object> DicManagers = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                                        if (DicManagers == null)
                                            DicManagers = new Dictionary<string, object>();

                                        string[] arrManagersConnected = new string[DicManagers.Keys.Count];
                                        string[] arrManagersSelected = new string[DicManagers.Keys.Count];
                                        DicManagers.Keys.CopyTo(arrManagersConnected, 0);
                                        int counter = 0;
                                        for (int i = 0; i < arrManagersConnected.Length; i++)
                                        {
                                            if (arrManagersConnected[i].IndexOf(data["ManagerEmployeeId"].ToString().Replace("'", "").Replace("\"", "") + ";") == 0)//found
                                            {
                                                arrManagersSelected[counter] = arrManagersConnected[i];
                                                counter++;
                                            }
                                        }
                                        for (int i = 0; i < arrManagersSelected.Length; i++)
                                        {
                                            if (arrManagersSelected[i] != null && DicManagers.TryGetValue(arrManagersSelected[i], out d))
                                            {
                                                string msgToSendToSend = "GET_MANAGER_SYNC_REPLAY;" + getVal(data["AgentName"].ToString()) + ";0"; ;
                                                if (getVal(data["RequestStatus"].ToString()) != "0")//ידני
                                                    msgToSendToSend = "GET_MANAGER_SYNC_REPLAY_MANUAL;" + getVal(data["AgentName"].ToString()) + ";0";

                                                SendMSGToManager(arrManagersSelected[i], msgToSendToSend);

                                                try
                                                {
                                                    ObjConnected c;
                                                    if (DicAllSessions.TryGetValue(arrManagersSelected[i], out c))
                                                        c.dtSession = DateTime.Now;
                                                }
                                                catch (Exception ex)
                                                {

                                                }

                                                //RegisterManager(arrManagersSelected[i]);
                                            }
                                        }
                                        //if (counter == 0)
                                        {
                                            myStateTmp.workSocket.BeginReceive(myStateTmp.buffer, 0, 1024, 0
                                                      , new AsyncCallback(OnReceive), myStateTmp);

                                            Register(myStateTmp.UserToken);
                                            // RegisterManager(myStateTmp.UserToken);
                                        }

                                    }
                                    else if (arrData.Length > 2 && arrData[0] == "isToManager" && arrData[2].IndexOf("cancel msg") > -1)//cancel msg
                                    {
                                        myStateManager = myStateTmp;
                                        JObject data = JsonConvert.DeserializeObject<JObject>(arrData[1]);

                                        string RequestStatus = "1001";

                                        WR.UpdatePasswordManagerAsync(data["RequestID"].ToString().Replace("'", "").Replace("\"", ""), RequestStatus, "");
                                        object d;
                                        Dictionary<string, object> DicManagers = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                                        if (DicManagers == null)
                                            DicManagers = new Dictionary<string, object>();

                                        string[] arrManagersConnected = new string[DicManagers.Keys.Count];
                                        string[] arrManagersSelected = new string[DicManagers.Keys.Count];
                                        DicManagers.Keys.CopyTo(arrManagersConnected, 0);
                                        int counter = 0;
                                        for (int i = 0; i < arrManagersConnected.Length; i++)
                                        {
                                            if (arrManagersConnected[i].IndexOf(data["ManagerEmployeeId"].ToString().Replace("'", "").Replace("\"", "") + ";") == 0)//found
                                            {
                                                arrManagersSelected[counter] = arrManagersConnected[i];
                                                counter++;
                                            }
                                        }
                                        for (int i = 0; i < arrManagersSelected.Length; i++)
                                        {
                                            if (arrManagersSelected[i] != null && DicManagers.TryGetValue(arrManagersSelected[i], out d))
                                            {
                                                string msgToSendToSend = "cancel msg;0;" + data["RequestID"].ToString();
                                                SendMSGToManager(arrManagersSelected[i], msgToSendToSend);

                                                try
                                                {
                                                    string[] arrManagersSessions = new string[DicAllSessions.Keys.Count];
                                                    DicAllSessions.Keys.CopyTo(arrManagersSessions, 0);
                                                    for (int t = 0; t < arrManagersSessions.Length; t++)
                                                    {
                                                        if (arrManagersSessions[t].IndexOf(arrManagersSelected[i]) > -1)
                                                        {
                                                            ((ObjConnected)DicAllSessions[arrManagersSessions[t]]).dtSession = DateTime.Now;
                                                        }

                                                    }
                                                }
                                                catch (Exception ex)
                                                {

                                                }
                                                //RegisterManager(arrManagersSelected[i]);
                                            }
                                        }
                                        // if (counter == 0)
                                        {

                                            myStateTmp.workSocket.BeginReceive(myStateTmp.buffer, 0, 1024, 0
                                                     , new AsyncCallback(OnReceive), myStateTmp);

                                            Register(myStateTmp.UserToken);
                                            //RegisterManager(myStateTmp.UserToken);
                                        }
                                    }
                                    else if (arrData.Length > 3 && arrData[0].IndexOf("toAgent") > -1)
                                    {
                                        myState = myStateTmp;
                                        //on android device  - mConnection.sendTextMessage("toAgent:" + AgentID + ";RequestId:" + requestId +";isApproved:"+isApproved+";ManagerComment:"+ManagerComment);
                                        string RequestStatus = "0";
                                        if (arrData[2].Split(':')[1].Trim() == "true")
                                            RequestStatus = "2";
                                        else
                                            RequestStatus = "3";

                                        WR.UpdatePasswordManagerAsync(arrData[1].Split(':')[1].Trim(), RequestStatus, arrData[3].Split(':')[1].Trim());
                                        object d;
                                        Dictionary<string, object> DicAgents = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                                        if (DicAgents == null)
                                            DicAgents = new Dictionary<string, object>();

                                        string[] arrConnected = new string[DicAgents.Keys.Count];
                                        string[] arrSelected = new string[DicAgents.Keys.Count];
                                        DicAgents.Keys.CopyTo(arrConnected, 0);
                                        int counter = 0;
                                        for (int i = 0; i < arrConnected.Length; i++)
                                        {
                                            if (arrConnected[i].IndexOf(Convert.ToInt64(arrData[0].Split(':')[1].Trim().Replace("'", "").Replace("\"", "")).ToString() + ";") == 0)//found
                                            {
                                                arrSelected[counter] = arrConnected[i];
                                                counter++;
                                            }
                                        }
                                        for (int i = 0; i < arrSelected.Length; i++)
                                        {
                                            if (arrSelected[i] != null && DicAgents.TryGetValue(arrSelected[i], out d))
                                            {
                                                string msgToSendToSend = "[{\"MSG\":\"Approved MSG REPLAY\",\"Approved\":\"" + arrData[2].Split(':')[1].Trim() + "\",\"Requestid\":\"" + arrData[1].Split(':')[1].Trim() + "\",\"RequestStatus\":\"" + RequestStatus + "\",\"ManagerComment\":\"" + arrData[3].Split(':')[1].Trim() + "\"}]";
                                                //msg;approved;requestid;RequestStatus;ManagerComment
                                                SendMSG(arrData[0].Split(':')[1].Trim().Replace("'", "").Replace("\"", ""), msgToSendToSend);

                                                try
                                                {
                                                    string[] arrSessions = new string[DicAllSessions.Keys.Count];
                                                    DicAllSessions.Keys.CopyTo(arrSessions, 0);
                                                    for (int t = 0; t < arrSessions.Length; t++)
                                                    {
                                                        if (arrSessions[t].IndexOf(arrData[0].Split(':')[1].Trim().Replace("'", "").Replace("\"", "")) > -1)
                                                        {
                                                            ((ObjConnected)DicAllSessions[arrSessions[t]]).dtSession = DateTime.Now;
                                                        }

                                                    }
                                                }
                                                catch (Exception ex)
                                                {

                                                }

                                                //Register(arrSelected[i]);
                                            }
                                        }
                                        //if (counter == 0)
                                        {
                                            //Register(myStateTmp.UserToken);
                                            RegisterManager(myStateTmp.UserToken);
                                        }

                                        Dictionary<string, object> DicManagers = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                                        if (DicManagers == null)
                                            DicManagers = new Dictionary<string, object>();

                                        string[] arrManagersConnected = new string[DicManagers.Keys.Count];
                                        string[] arrManagersSelected = new string[DicManagers.Keys.Count];
                                        DicManagers.Keys.CopyTo(arrManagersConnected, 0);
                                        counter = 0;

                                        var AgentID = msg.Substring(msg.IndexOf(':') + 1, msg.IndexOf(':') - 3);
                                        if (AgentID == null)
                                            AgentID = "0";
                                        if (AgentID.Length > 0 && AgentID[0] == '0')
                                            AgentID = AgentID.Substring(1, AgentID.Length - 1);

                                        //for (int i = 0; i < arrManagersConnected.Length; i++)
                                        //{
                                        //    if (arrManagersConnected[i].IndexOf(ManagerID.Split(';')[0] + ";") == 0 && arrManagersConnected[i].IndexOf(ManagerID+";")==0)//found
                                        //    {
                                        //        arrManagersSelected[counter] = arrManagersConnected[i];
                                        //        counter++;
                                        //    }
                                        //}
                                        Dictionary<string, object>.ValueCollection arr2 = DicManagers.Values;
                                        Socket[] arrCon233 = new Socket[arr2.Count];
                                        arr2.CopyTo(arrCon233, 0);


                                        for (int i = 0; i < arrCon233.Length; i++)
                                        {
                                            if (((Socket)arrCon233[i]) == handler)
                                            {
                                                arrManagersSelected[counter] = arrManagersConnected[i];
                                                counter++;
                                            }
                                        }
                                        Thread.Sleep(500);
                                        for (int i = 0; i < arrManagersSelected.Length; i++)
                                        {
                                            if (arrManagersSelected[i] != null && DicManagers.TryGetValue(arrManagersSelected[i], out d))
                                            {
                                                string msgToSend1 = "Update_Request;" + arrData[1].Split(':')[1].Trim() + ";" + RequestStatus; //Update_Request;REQUSETID;RequestStatus

                                                //myStateManager = myStateTmp;
                                                SendMSGToManager(arrManagersSelected[i], msgToSend1);

                                                try
                                                {
                                                    string[] arrManagersSessions = new string[DicAllSessions.Keys.Count];
                                                    DicAllSessions.Keys.CopyTo(arrManagersSessions, 0);
                                                    for (int t = 0; t < arrManagersSessions.Length; t++)
                                                    {
                                                        if (arrManagersSessions[t].IndexOf(arrManagersSelected[i]) > -1)
                                                        {
                                                            ((ObjConnected)DicAllSessions[arrManagersSessions[t]]).dtSession = DateTime.Now;
                                                        }

                                                    }
                                                }
                                                catch (Exception ex)
                                                {

                                                }
                                                //RegisterManager(arrManagersSelected[i]);
                                            }
                                        }
                                        //if (counter == 0)
                                        {
                                            myStateTmp.workSocket.BeginReceive(myStateTmp.buffer, 0, 1024, 0
                                                     , new AsyncCallback(OnReceive), myStateTmp);

                                            Register(myStateTmp.UserToken);
                                            //RegisterManager(myStateTmp.UserToken);
                                        }
                                    }
                                    else if (arrData.Length > 1 && arrData[0] == "isTestToManager")
                                    {
                                        //JObject data = JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(arrData[1]);

                                        ObjConnected d;
                                        string[] arrManagersConnected = new string[DicAllSessions.Keys.Count];
                                        string[] arrManagersSelected = new string[DicAllSessions.Keys.Count];
                                        DicAllSessions.Keys.CopyTo(arrManagersConnected, 0);
                                        int counter = 0;
                                        for (int i = 0; i < arrManagersConnected.Length; i++)
                                        {
                                            if (arrManagersConnected[i].IndexOf(arrData[1].Replace("'", "").Replace("\"", "") + ";") == 0)//found
                                            {
                                                arrManagersSelected[counter] = arrManagersConnected[i];
                                                counter++;
                                            }
                                        }
                                        for (int i = 0; i < arrManagersSelected.Length; i++)
                                        {
                                            if (arrManagersSelected[i] != null && DicAllSessions.TryGetValue(arrManagersSelected[i], out d))
                                            {
                                                string msgToSendToSend = arrData[0];

                                                SendMSGToTester(arrManagersSelected[i], msgToSendToSend);

                                                try
                                                {
                                                    ObjConnected c;
                                                    if (DicAllSessions.TryGetValue(arrManagersSelected[i], out c))
                                                        c.dtSession = DateTime.Now;
                                                }
                                                catch (Exception ex)
                                                {

                                                }

                                                //RegisterManager(arrManagersSelected[i]);
                                            }
                                        }
                                        //if (counter == 0)
                                        {
                                            myStateTmp.workSocket.BeginReceive(myStateTmp.buffer, 0, 1024, 0
                                                      , new AsyncCallback(OnReceive), myStateTmp);

                                            Register(myStateTmp.UserToken);
                                            // RegisterManager(myStateTmp.UserToken);
                                        }
                                    }
                                    else if (arrData.Length > 1 && arrData[0] == "toAgentTesterMSG")
                                    {
                                        //JObject data = JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(arrData[1]);

                                        ObjConnected d;
                                        string[] arrManagersConnected = new string[DicAllSessions.Keys.Count];
                                        string[] arrManagersSelected = new string[DicAllSessions.Keys.Count];
                                        DicAllSessions.Keys.CopyTo(arrManagersConnected, 0);
                                        int counter = 0;
                                        for (int i = 0; i < arrManagersConnected.Length; i++)
                                        {
                                            if (arrManagersConnected[i].IndexOf(arrData[1].Replace("'", "").Replace("\"", "") + ";") == 0)//found
                                            {
                                                arrManagersSelected[counter] = arrManagersConnected[i];
                                                counter++;
                                            }
                                        }
                                        for (int i = 0; i < arrManagersSelected.Length; i++)
                                        {
                                            if (arrManagersSelected[i] != null && DicAllSessions.TryGetValue(arrManagersSelected[i], out d))
                                            {
                                                string msgToSendToSend = arrData[0];

                                                SendMSGToTester(arrManagersSelected[i], msgToSendToSend);

                                                try
                                                {
                                                    ObjConnected c;
                                                    if (DicAllSessions.TryGetValue(arrManagersSelected[i], out c))
                                                        c.dtSession = DateTime.Now;
                                                }
                                                catch (Exception ex)
                                                {

                                                }

                                                //RegisterManager(arrManagersSelected[i]);
                                            }
                                        }
                                        //if (counter == 0)
                                        {
                                            myStateTmp.workSocket.BeginReceive(myStateTmp.buffer, 0, 1024, 0
                                                      , new AsyncCallback(OnReceive), myStateTmp);

                                            Register(myStateTmp.UserToken);
                                            // RegisterManager(myStateTmp.UserToken);
                                        }
                                    }
                                    else if (arrData.Length > 3 && arrData[0].IndexOf("GetManagersList") > -1)//GetManagersList;1234;7;;
                                    {
                                        myState = myStateTmp;
                                        Dictionary<string, object> DicAgents = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                                        if (DicAgents == null)
                                            DicAgents = new Dictionary<string, object>();
                                        DataTable dt = WR.GetManagersForTabletUI(arrData[3]);

                                        dt.Columns.Add("isConnected");
                                        object d;
                                        if (dt != null)
                                        {
                                            for (int i = 0; i < dt.Rows.Count; i++)
                                            {
                                                if (IsManagerConnected(dt.Rows[i]["EmployeeId"].ToString()))
                                                {
                                                    dt.Rows[i]["isConnected"] = "true";
                                                }
                                                else
                                                {
                                                    dt.Rows[i]["isConnected"] = "false";
                                                }
                                            }
                                        }

                                        if (DicAgents.TryGetValue(Convert.ToInt64(arrData[1]).ToString() + ";" + arrData[2], out d))
                                        {
                                            SendMSG(arrData[1] + ";" + arrData[2], ";ManagersListReplayToAgent;" + GetJson(dt));
                                            //Register(arrData[1] + ";" + arrData[2]);
                                        }
                                        //Register(myStateTmp.UserToken);
                                        RegisterManager(myStateTmp.UserToken);
                                    }
                                    else if (arrData.Length > 3 && arrData[0].IndexOf("TestSend") > -1)//GetManagersList;1234;7;;
                                    {
                                        myState = myStateTmp;
                                        Dictionary<string, object> DicAgents = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                                        if (DicAgents == null)
                                            DicAgents = new Dictionary<string, object>();

                                        object d;

                                        if (DicAgents.TryGetValue(Convert.ToInt64(arrData[1]).ToString() + ";" + arrData[2], out d))
                                        {
                                            SendMSG(arrData[1] + ";" + arrData[2], "t;TestReplay;t;t;t");
                                            //Register(arrData[1] + ";" + arrData[2]);
                                        }
                                        myStateTmp.workSocket.BeginReceive(myStateTmp.buffer, 0, 1024, 0
                                                     , new AsyncCallback(OnReceive), myStateTmp);

                                        RegisterManager(myStateTmp.UserToken);
                                    }

                                }
                                catch (Exception ex)
                                {
                                    //Register(myStateTmp.UserToken);
                                    //RegisterManager(myStateTmp.UserToken);
                                    Tools.AddRowToLog("Error OnMessage: " + ex.Message, Program.LogDirectory, Program.LogFileName);

                                    if (DicAllSessions != null && DicAllSessions.Values != null && DicAllSessions.Values.Count > 0)
                                    {
                                        // Thread.Sleep(10000);
                                        Dictionary<string, ObjConnected>.ValueCollection arr7 = DicAllSessions.Values;
                                        ObjConnected[] arrAllConnectedWS2 = new ObjConnected[arr7.Count];
                                        arr7.CopyTo(arrAllConnectedWS2, 0);

                                        Dictionary<string, ObjConnected>.KeyCollection arr2 = DicAllSessions.Keys;
                                        string[] arrCon2 = new string[arr2.Count];
                                        arr2.CopyTo(arrCon2, 0);

                                        Dictionary<string, object> DicManagersa = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                                        Dictionary<string, object> DicAgentsa = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                                        for (int i = 0; i < arrAllConnectedWS2.Length; i++)
                                        {
                                            try
                                            {
                                                var AgentID = msg.Substring(msg.IndexOf(':') + 1, msg.IndexOf(':') - 3);
                                                if (AgentID == null)
                                                    AgentID = "0";
                                                if (AgentID.Length > 0 && AgentID[0] == '0')
                                                    AgentID = AgentID.Substring(1, AgentID.Length - 1);

                                                if (arrCon2[i] == AgentID)
                                                {
                                                    //((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Shutdown(SocketShutdown.Both);
                                                    //((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Close();
                                                    DicAllSessions.Remove(arrCon2[i]);

                                                    object d;
                                                    if (DicManagersa.TryGetValue(arrCon2[i], out d))
                                                        DicManagersa.Remove(arrCon2[i]);

                                                    if (DicAgentsa.TryGetValue(arrCon2[i], out d))
                                                        DicAgentsa.Remove(arrCon2[i]);

                                                    OnClose(arrCon2[i], "", "Session Error  - Server close connection");

                                                    try
                                                    {
                                                        ((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Shutdown(SocketShutdown.Both);
                                                    }
                                                    catch (Exception ex1)
                                                    { }

                                                    try
                                                    {
                                                        ((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Close();
                                                    }
                                                    catch (Exception ex1)
                                                    { }

                                                    try
                                                    {
                                                        ((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Disconnect(true);
                                                    }
                                                    catch (Exception ex1)
                                                    { }

                                                    try
                                                    {
                                                        //((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Dispose();
                                                    }
                                                    catch (Exception ex1)
                                                    { }
                                                }
                                            }
                                            catch (Exception ex1)
                                            {
                                            }
                                        }

                                    }
                                }
                            }

                            //Register(myState.UserToken);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                try
                {
                    Tools.AddRowToLog("Error occurred (OnReceive):" + ex.ToString(), LogDirectory, LogFileName);

                    ((Socket)myStateTmp.workSocket).Shutdown(SocketShutdown.Both);
                    ((Socket)myStateTmp.workSocket).Close();

                    if (myStateTmp.IsManager)
                        OnClose("", myStateTmp.UserToken, "Client Close Connection");
                    else
                        OnClose(myStateTmp.UserToken, "", "Client Close Connection");

                    return;
                }
                catch (Exception e2x)
                { }


            }


        }
        private static void SendMSG(string to, string msg)
        {
            lock (obj)
            {
                int max = 15;
                string[] arrSelected = new string[max];
                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);

                Dictionary<string, object>.KeyCollection arr2 = Dic.Keys;
                string[] arrCon2 = new string[arr2.Count];
                arr2.CopyTo(arrCon2, 0);

                int Counter = 0;
                if (to.Length > 0 && to[0] == '0')
                    to = Convert.ToInt64(to).ToString();// .Substring(1, to.Length-2);
                for (int i = 0; i < arrCon2.Length; i++)
                {
                    if (arrCon2[i].IndexOf(to + ";") > -1 || arrCon2[i].IndexOf(to) > -1)
                    {
                        arrSelected[Counter] = arrCon2[i];
                        Counter++;

                        if (Counter > max - 1)
                            Counter = 0;
                    }
                }


                if (Dic != null)
                {
                    for (int g = 0; g < arrSelected.Length; g++)
                    {
                        if (arrSelected[g] != null)
                        {
                            to = arrSelected[g];
                            object obj = new object();
                            if (Dic.TryGetValue(to, out obj))
                            {
                                int bytesRead = msg.Length;
                                int index = 2;
                                if (bytesRead > 125)
                                    index = 4;

                                bytesRead = bytesRead + index;

                                byte[] arr = System.Text.Encoding.UTF8.GetBytes(msg);
                                byte[] sendBuffer = new byte[arr.Length + index];

                                if (bytesRead < 126)
                                {
                                    sendBuffer[0] = 0x81; // last frame, text
                                    sendBuffer[1] = (byte)arr.Length; // not masked, length 3

                                }
                                else// 126 up to 65535
                                {
                                    sendBuffer[0] = 0x81; // last frame, text
                                    sendBuffer[1] = (byte)126;
                                    int len = arr.Length;
                                    sendBuffer[2] = (byte)((len >> 8) & (byte)255);
                                    sendBuffer[3] = (byte)(len & (byte)255);
                                }

                                Buffer.BlockCopy(arr, 0, sendBuffer, index, arr.Length);

                                saea.SetBuffer(sendBuffer, 0, sendBuffer.Length);
                                saea.UserToken = to;
                                Thread.Sleep(100);
                                try
                                {
                                    StateObject state = new StateObject();
                                    state.workSocket = ((Socket)obj);
                                    state.UserToken = to;


                                    try
                                    {
                                        SocketConnected(((Socket)obj), to, false);
                                    }
                                    catch (Exception ex)
                                    { }

                                    if (((Socket)obj).Connected)
                                    {
                                        ((Socket)obj).BeginSend(sendBuffer, 0, sendBuffer.Length, SocketFlags.None, new AsyncCallback(AfterSend), state);
                                    }
                                    else
                                    {
                                        try
                                        {
                                            ObjConnected y;
                                            if (DicAllSessions.TryGetValue(to, out y))
                                                DicAllSessions.Remove(to);

                                            OnClose(to, "", "Session Closed  - Server close connection");


                                            try
                                            {
                                                ((Socket)obj).Shutdown(SocketShutdown.Both);
                                            }
                                            catch (Exception ex)
                                            { }

                                            try
                                            {
                                                ((Socket)obj).Close();
                                            }
                                            catch (Exception ex)
                                            { }

                                            try
                                            {
                                                ((Socket)obj).Disconnect(true);
                                            }
                                            catch (Exception ex)
                                            { }

                                            try
                                            {
                                                //((Socket)obj).Dispose();
                                            }
                                            catch (Exception ex)
                                            { }

                                        }
                                        catch (Exception ex)
                                        {
                                            Tools.AddRowToLog("((Socket)obj).SendAsync, " + ex.Message, Program.LogDirectory, Program.LogFileName);
                                        }
                                    }
                                    //if (!((Socket)obj).SendAsync(saea))
                                    //{
                                    //    for (int i = 0; i < 5; i++)
                                    //    {
                                    //        Thread.Sleep(200);
                                    //        if (!((Socket)obj).SendAsync(saea))
                                    //        {

                                    //        }
                                    //        else
                                    //        {
                                    //            break;
                                    //        }
                                    //    }
                                    //}

                                }
                                catch (Exception ex)
                                { }

                                if (arrSelected.Length - 1 > g)
                                    Thread.Sleep(1500);
                            }
                        }

                    }
                }
            }
            //Register(to);
        }
        private static void SendMSGToManager(string to, string msg)
        {
            lock (obj)
            {
                int max = 15;
                string[] arrSelected = new string[max];
                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);

                Dictionary<string, object>.KeyCollection arr2 = Dic.Keys;
                string[] arrCon2 = new string[arr2.Count];
                arr2.CopyTo(arrCon2, 0);

                int Counter = 0;
                for (int i = 0; i < arrCon2.Length; i++)
                {
                    if (arrCon2[i].IndexOf(to + ";") > -1 || arrCon2[i].IndexOf(to) > -1)
                    {
                        arrSelected[Counter] = arrCon2[i];
                        Counter++;

                        if (Counter > max - 1)
                            Counter = 0;
                    }
                }


                if (Dic != null)
                {
                    for (int g = 0; g < arrSelected.Length; g++)
                    {
                        if (arrSelected[g] != null)
                        {
                            to = arrSelected[g];
                            object obj = new object();
                            if (Dic.TryGetValue(to, out obj))
                            {
                                int bytesRead = msg.Length;
                                int index = 2;
                                if (bytesRead > 125)
                                    index = 4;

                                bytesRead = bytesRead + index;

                                byte[] arr = System.Text.Encoding.UTF8.GetBytes(msg);
                                byte[] sendBuffer = new byte[arr.Length + index];

                                if (bytesRead < 126)
                                {
                                    sendBuffer[0] = 0x81; // last frame, text
                                    sendBuffer[1] = (byte)arr.Length; // not masked, length 3

                                }
                                else// 126 up to 65535
                                {
                                    sendBuffer[0] = 0x81; // last frame, text
                                    sendBuffer[1] = (byte)126;
                                    int len = arr.Length;
                                    sendBuffer[2] = (byte)((len >> 8) & (byte)255);
                                    sendBuffer[3] = (byte)(len & (byte)255);
                                }

                                Buffer.BlockCopy(arr, 0, sendBuffer, index, arr.Length);

                                saeaManager.SetBuffer(sendBuffer, 0, sendBuffer.Length);
                                saeaManager.UserToken = to;

                                //SocketConnected(((Socket)obj), to);
                                if (((Socket)obj).Connected)
                                {
                                    ((Socket)obj).SendAsync(saeaManager);
                                }

                                if (arrSelected.Length - 1 > g)
                                    Thread.Sleep(500);
                            }
                        }

                    }
                }
            }
            //RegisterManager(to);
        }
        private static void SendMSGToAgent(string to, string msg)
        {
            lock (obj)
            {
                int max = 15;
                string[] arrSelected = new string[max];
                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);

                Dictionary<string, object>.KeyCollection arr2 = Dic.Keys;
                string[] arrCon2 = new string[arr2.Count];
                arr2.CopyTo(arrCon2, 0);

                int Counter = 0;
                for (int i = 0; i < arrCon2.Length; i++)
                {
                    if (arrCon2[i].IndexOf(to + ";") > -1 || arrCon2[i].IndexOf(to) > -1)
                    {
                        arrSelected[Counter] = arrCon2[i];
                        Counter++;

                        if (Counter > max - 1)
                            Counter = 0;
                    }
                }


                if (Dic != null)
                {
                    for (int g = 0; g < arrSelected.Length; g++)
                    {
                        if (arrSelected[g] != null)
                        {
                            to = arrSelected[g];
                            object obj = new object();
                            if (Dic.TryGetValue(to, out obj))
                            {
                                int bytesRead = msg.Length;
                                int index = 2;
                                if (bytesRead > 125)
                                    index = 4;

                                bytesRead = bytesRead + index;

                                byte[] arr = System.Text.Encoding.UTF8.GetBytes(msg);
                                byte[] sendBuffer = new byte[arr.Length + index];

                                if (bytesRead < 126)
                                {
                                    sendBuffer[0] = 0x81; // last frame, text
                                    sendBuffer[1] = (byte)arr.Length; // not masked, length 3

                                }
                                else// 126 up to 65535
                                {
                                    sendBuffer[0] = 0x81; // last frame, text
                                    sendBuffer[1] = (byte)126;
                                    int len = arr.Length;
                                    sendBuffer[2] = (byte)((len >> 8) & (byte)255);
                                    sendBuffer[3] = (byte)(len & (byte)255);
                                }

                                Buffer.BlockCopy(arr, 0, sendBuffer, index, arr.Length);

                                saeaManager.SetBuffer(sendBuffer, 0, sendBuffer.Length);
                                saeaManager.UserToken = to;

                                //SocketConnected(((Socket)obj), to);
                                if (((Socket)obj).Connected)
                                {
                                    ((Socket)obj).SendAsync(saeaManager);
                                }

                                if (arrSelected.Length - 1 > g)
                                    Thread.Sleep(500);
                            }
                        }

                    }
                }
            }
            //RegisterManager(to);
        }
        private static void SendMSGToTester(string to, string msg)
        {
            lock (obj)
            {
                int max = 15;
                string[] arrSelected = new string[max];
                Dictionary<string, ObjConnected> Dic = DicAllSessions;

                Dictionary<string, ObjConnected>.KeyCollection arr2 = Dic.Keys;
                string[] arrCon2 = new string[arr2.Count];
                arr2.CopyTo(arrCon2, 0);

                int Counter = 0;
                for (int i = 0; i < arrCon2.Length; i++)
                {
                    if (arrCon2[i].IndexOf(to + ";") > -1 || arrCon2[i].IndexOf(to) > -1)
                    {
                        arrSelected[Counter] = arrCon2[i];
                        Counter++;

                        if (Counter > max - 1)
                            Counter = 0;
                    }
                }


                if (Dic != null)
                {
                    for (int g = 0; g < arrSelected.Length; g++)
                    {
                        if (arrSelected[g] != null)
                        {
                            to = arrSelected[g];
                            ObjConnected obj;
                            if (Dic.TryGetValue(to, out obj))
                            {
                                int bytesRead = msg.Length;
                                int index = 2;
                                if (bytesRead > 125)
                                    index = 4;

                                bytesRead = bytesRead + index;

                                byte[] arr = System.Text.Encoding.UTF8.GetBytes(msg);
                                byte[] sendBuffer = new byte[arr.Length + index];

                                if (bytesRead < 126)
                                {
                                    sendBuffer[0] = 0x81; // last frame, text
                                    sendBuffer[1] = (byte)arr.Length; // not masked, length 3

                                }
                                else// 126 up to 65535
                                {
                                    sendBuffer[0] = 0x81; // last frame, text
                                    sendBuffer[1] = (byte)126;
                                    int len = arr.Length;
                                    sendBuffer[2] = (byte)((len >> 8) & (byte)255);
                                    sendBuffer[3] = (byte)(len & (byte)255);
                                }

                                Buffer.BlockCopy(arr, 0, sendBuffer, index, arr.Length);

                                saeaManager.SetBuffer(sendBuffer, 0, sendBuffer.Length);
                                saeaManager.UserToken = to;

                                //SocketConnected(((Socket)obj), to);
                                if (((Socket)obj.clientSocket).Connected)
                                {
                                    ((Socket)obj.clientSocket).SendAsync(saeaManager);
                                }
                                //else
                                //{
                                //    try
                                //    {
                                //        ObjConnected y;
                                //        if (DicAllSessions.TryGetValue(to, out y))
                                //            DicAllSessions.Remove(to);

                                //        OnClose(to, "", "Session Closed  - Server close connection");

                                //        try
                                //        {
                                //            ((Socket)obj).Shutdown(SocketShutdown.Both);
                                //        }
                                //        catch (Exception ex)
                                //        { }

                                //        try
                                //        {
                                //            ((Socket)obj).Close();
                                //        }
                                //        catch (Exception ex)
                                //        { }

                                //        try
                                //        {
                                //            ((Socket)obj).Disconnect(true);
                                //        }
                                //        catch (Exception ex)
                                //        { }

                                //        try
                                //        {
                                //            //((Socket)obj).Dispose();
                                //        }
                                //        catch (Exception ex)
                                //        { }
                                //    }
                                //    catch (Exception ex)
                                //    {
                                //        Tools.AddRowToLog("((Socket)obj).SendAsync, " + ex.Message, Program.LogDirectory, Program.LogFileName);
                                //    }
                                //}


                                if (arrSelected.Length - 1 > g)
                                    Thread.Sleep(500);
                            }
                        }

                    }
                }
            }
            //RegisterManager(to);
        }
        static void saea_Completed(object sender, SocketAsyncEventArgs e)
        {
            Register(e.UserToken.ToString());
        }
        static void saea_Completed_Manager(object sender, SocketAsyncEventArgs e)
        {
            RegisterManager(e.UserToken.ToString());
        }
        private static void Register(string UserToken)
        {
            try
            {
                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                if (Dic != null)
                {
                    object obj = new object();
                    if (Dic.TryGetValue(UserToken.ToString(), out obj))
                    {
                        StateObject myState = new StateObject();
                        myState.UserToken = UserToken;
                        myState.workSocket = ((Socket)obj);
                        //Thread.Sleep(2000);


                    }
                    else
                    {
                        int t = 1;
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }
        private static void RegisterManager(string UserToken)
        {
            try
            {
                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                if (Dic != null)
                {
                    object obj = new object();
                    if (Dic.TryGetValue(UserToken.ToString(), out obj))
                    {
                        StateObject myStateManager = new StateObject();
                        myStateManager.UserToken = UserToken;
                        myStateManager.workSocket = ((Socket)obj);
                        //Thread.Sleep(2000);


                    }
                    else
                    {
                        int t = 1;
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }

        static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }
        public static T[] SubArray<T>(T[] data, int index, int length)
        {
            T[] result = new T[length];
            Array.Copy(data, index, result, 0, length);
            return result;
        }

        private static string AcceptKey(ref string key)
        {
            string longKey = key + guid;
            byte[] hashBytes = ComputeHash(longKey);
            return Convert.ToBase64String(hashBytes);
        }

        static SHA1 sha1 = SHA1CryptoServiceProvider.Create();
        private static byte[] ComputeHash(string str)
        {
            return sha1.ComputeHash(System.Text.Encoding.ASCII.GetBytes(str));
        }

        private static void Stop()
        {
            isRunning = false;
            Tools.AddRowToLog("Service stoped", LogDirectory, LogFileName);
        }
        private static void PushServer()
        {
            try
            {

                isRunning = true;
                if (cacheObj == null)
                    cacheObj = new CacheHandler.CacheObj();

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
                            Tools.AddRowToLog(string.Format("DataTable count - {0}", dt.Rows.Count.ToString()), LogDirectory, LogFileName);
                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                bool isToDelete = false;

                                //copy ws agents connected 
                                Dictionary<string, object>.KeyCollection arr = Dic.Keys;
                                string[] arrAllConnectedWS = new string[arr.Count];
                                arr.CopyTo(arrAllConnectedWS, 0);

                                Tools.AddRowToLog(string.Format("arrAllConnectedWS count - {0}", arrAllConnectedWS.Length.ToString()), LogDirectory, LogFileName);
                                for (int y = 0; y < arrAllConnectedWS.Length; y++)
                                {
                                    string[] arrDBAgent = dt.Rows[i]["AgentID"].ToString().Split(';');
                                    string[] arrConnectedAgent = arrAllConnectedWS[y].Split(';');
                                    object d;

                                    Tools.AddRowToLog(string.Format("arrDBAgent count - {0}", arrDBAgent.Length.ToString()), LogDirectory, LogFileName);
                                    Tools.AddRowToLog(string.Format("arrConnectedAgent count - {0}", arrConnectedAgent.Length.ToString()), LogDirectory, LogFileName);
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

                                            if (dt.Rows[i]["Message"].ToString().IndexOf("DeleteTablet") == -1)//push org
                                            {
                                                SendMSG(arrAllConnectedWS[y], dt.Rows[i]["PushID"].ToString() + ";" + dt.Rows[i]["Message"].ToString());
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
                                            string[] arrMSG = dt.Rows[i]["Message"].ToString().Split(';');

                                            if (arrMSG.Length > 1)
                                            {
                                                if (arrMSG[1] == arrConnectedAgent[1])//same hw
                                                {
                                                    Tools.AddRowToLog(counter.ToString() + "- SarrMSG[1]: " + arrMSG[1].ToString() + ";arrConnectedAgent[1]: " + arrConnectedAgent[1], LogDirectory, LogFileName);
                                                    SendMSG(arrAllConnectedWS[y], dt.Rows[i]["PushID"].ToString() + ";" + "DeleteTablet");
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

                //wssv.Stop();
            }
            catch (Exception ex)
            {
                Tools.AddRowToLog("Error occurred:" + ex.ToString(), LogDirectory, LogFileName);
            }
            Tools.AddRowToLog("************************** Stoped **************************", LogDirectory, LogFileName);
        }
        private static void ListenToClosing()
        {
            Thread.Sleep(10000);
            while (isRunning)
            {
                try
                {
                    //DicAllSessions
                    //if (DicAllSessions != null && DicAllSessions.Values != null && DicAllSessions.Values.Count > 0)
                    //{
                    //    // Thread.Sleep(10000);
                    //    Dictionary<string, ObjConnected>.ValueCollection arr7 = DicAllSessions.Values;
                    //    ObjConnected[] arrAllConnectedWS2 = new ObjConnected[arr7.Count];
                    //    arr7.CopyTo(arrAllConnectedWS2, 0);

                    //    Dictionary<string, ObjConnected>.KeyCollection arr2 = DicAllSessions.Keys;
                    //    string[] arrCon2 = new string[arr2.Count];
                    //    arr2.CopyTo(arrCon2, 0);

                    //    Dictionary<string, object> DicManagersa = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                    //    Dictionary<string, object> DicAgentsa = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                    //    for (int i = 0; i < arrAllConnectedWS2.Length; i++)
                    //    {
                    //        try
                    //        {

                    //            if (((ObjConnected)arrAllConnectedWS2[i]).dtSession.AddSeconds(Convert.ToInt32(SessionTimeOut)) < DateTime.Now)
                    //            {
                    //                try
                    //                {
                    //                    ((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Shutdown(SocketShutdown.Both);
                    //                }
                    //                catch (Exception ex1)
                    //                { }

                    //                try
                    //                {
                    //                    ((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Close();
                    //                }
                    //                catch (Exception ex1)
                    //                { }

                    //                try
                    //                {
                    //                    ((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Disconnect(true);
                    //                }
                    //                catch (Exception ex1)
                    //                { }

                    //                try
                    //                {
                    //                    //((ObjConnected)arrAllConnectedWS2[i]).clientSocket.Dispose();
                    //                }
                    //                catch (Exception ex1)
                    //                { }

                    //                DicAllSessions.Remove(arrCon2[i]);

                    //                object d;
                    //                if (DicManagersa.TryGetValue(arrCon2[i], out d))
                    //                    DicManagersa.Remove(arrCon2[i]);

                    //                if (DicAgentsa.TryGetValue(arrCon2[i], out d))
                    //                    DicAgentsa.Remove(arrCon2[i]);

                    //                OnClose(arrCon2[i], "", "Session TimeOut  - Server close connection");
                    //            }
                    //        }
                    //        catch (Exception ex)
                    //        {
                    //        }
                    //    }

                    //}

                    Dictionary<string, object> Dic7 = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                    if (Dic7 != null && Dic7.Values != null && Dic7.Values.Count > 0)
                    {
                        // Thread.Sleep(10000);
                        Dictionary<string, object>.ValueCollection arr7 = Dic7.Values;
                        Socket[] arrAllConnectedWS2 = new Socket[arr7.Count];
                        arr7.CopyTo(arrAllConnectedWS2, 0);

                        Dictionary<string, object>.KeyCollection arr2 = Dic7.Keys;
                        string[] arrCon2 = new string[arr2.Count];
                        arr2.CopyTo(arrCon2, 0);


                        for (int i = 0; i < arrAllConnectedWS2.Length; i++)
                        {
                            try
                            {

                                if (!((Socket)arrAllConnectedWS2[i]).Connected)
                                {
                                    OnClose(arrCon2[i], "", "Server seen close connection");
                                    Thread.Sleep(5000);

                                }
                            }
                            catch (Exception ex)
                            {
                            }
                        }

                    }

                    Dic7 = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                    if (Dic7 != null && Dic7.Values != null && Dic7.Values.Count > 0)
                    {
                        //Thread.Sleep(30000);
                        Dictionary<string, object>.ValueCollection arr7 = Dic7.Values;
                        Socket[] arrAllConnectedWS2 = new Socket[arr7.Count];
                        arr7.CopyTo(arrAllConnectedWS2, 0);

                        Dictionary<string, object>.KeyCollection arr2 = Dic7.Keys;
                        string[] arrCon2 = new string[arr2.Count];
                        arr2.CopyTo(arrCon2, 0);


                        for (int i = 0; i < arrAllConnectedWS2.Length; i++)
                        {
                            try
                            {
                                bool blockingState = ((Socket)arrAllConnectedWS2[i]).Blocking;
                                try
                                {
                                    byte[] tmp = new byte[1];

                                    ((Socket)arrAllConnectedWS2[i]).Blocking = false;
                                    //((Socket)arrAllConnectedWS2[i]).Send(tmp, 0, 0);
                                    /////SendMSGToManager(arrCon2[i], "");
                                    //Console.WriteLine("Connected!");
                                }
                                catch (SocketException e)
                                {
                                    // 10035 == WSAEWOULDBLOCK 
                                    if (e.NativeErrorCode.Equals(10035))
                                    {
                                        // Console.WriteLine("Still Connected, but the Send would block");
                                    }
                                    else
                                    {
                                        OnClose("", arrCon2[i], arrCon2[i] + " - Disconnected: error code " + e.NativeErrorCode + "!");
                                        //Console.WriteLine("Disconnected: error code {0}!", e.NativeErrorCode);
                                    }
                                }
                                finally
                                {
                                    ((Socket)arrAllConnectedWS2[i]).Blocking = blockingState;
                                }


                                //if (!((Socket)arrAllConnectedWS2[i]).Connected)
                                // if (!((Socket)arrAllConnectedWS2[i]).Connected)
                                /*if (!SocketExtensions.IsConnected(((Socket)arrAllConnectedWS2[i])))
                                {
                                    //Thread.Sleep(1000);
                                    OnClose("", arrCon2[i], "Server seen close connection");
                                }*/
                            }
                            catch (Exception ex)
                            {
                            }
                        }

                    }
                    Thread.Sleep(30000);
                }
                catch (Exception ex)
                {
                    Tools.AddRowToLog("Error ListenToClosing, Reason: " + ex.Message, Program.LogDirectory, Program.LogFileName);

                }

            }
        }
        private static Socket ms;
        private static string mClientID;
        static System.Timers.Timer aTimer;

        public static void SocketConnected(Socket s, string ClientID, bool isAgent)
        {
            aTimer = new System.Timers.Timer();
            // Socket ms = s;
            ms = s;
            mClientID = ClientID;
            bool blockingState = ms.Blocking;

            try
            {
                byte[] tmp = new byte[1];
                tmp[0] = 1;
                byte[] tmp2 = new byte[256];

                //ms.Blocking = false;
                ms.NoDelay = false;
                ms.Ttl = CheckSocketTtl;
                ms.SendTimeout = 100;
                //ms.Send(tmp, 0, SocketFlags.None);
                //ms.Send(System.Text.Encoding.UTF8.GetBytes("TestSend"));
                //ms.Send(tmp, 1, SocketFlags.None);

                if (!isAgent)
                    SendMSGToManager(ClientID, "Update_Request;0;0;0");
                else
                    SendMSGToAgent(ClientID, "TestReplay");

                if (!SocketExtensions.IsConnected(ms))
                {
                    DisConnectVlint(ms, mClientID);
                }
                else if (!ms.Connected)
                {
                    DisConnectVlint(ms, mClientID);
                }
                //////////////ms.Blocking = false;
                //////////////ms.ReceiveTimeout = 500;
                //////////////ms.Receive(tmp2, SocketFlags.Peek);

                ////if (ms.Poll(0, SelectMode.SelectRead))
                ////{
                ////    byte[] buff = new byte[1];
                ////    if (ms.Receive(buff, SocketFlags.Peek) == 0)
                ////    {
                ////        // Client disconnected
                ////        DisConnectVlint(ms, mClientID);
                ////    }
                ////}

                //ms.Blocking = false;
                //ms.Send(tmp, 0, SocketFlags.Peek);

                ////ms.Poll(5000, SelectMode.SelectRead);

                //////aTimer.Elapsed += new ElapsedEventHandler(OnTimedEventSocketConnected);
                //////aTimer.Interval = 1000;
                //////aTimer.Enabled = true;

                //if (ms.Poll(5000, SelectMode.SelectRead) && ms.Available == 0)
                //{
                //    DisConnectVlint(ms, mClientID);
                //}


                //if (!ms.Connected)
                //{
                //    DisConnectVlint(s, ClientID);
                //}




                //return true;
            }
            catch (SocketException e)
            {
                // 10035 == WSAEWOULDBLOCK
                if (e.NativeErrorCode.Equals(10035))
                {
                    //return true;
                }
                else
                {
                    DisConnectVlint(ms, mClientID);
                }
            }
            finally
            {
                //ms.Blocking = blockingState;
            }

            //////// Socket ms1 = s;

            //////// //ms = s;
            ////////// Program.mClientID = ClientID;

            //////// if (DicAllSessions != null && DicAllSessions.Values != null && DicAllSessions.Values.Count > 0)
            //////// {
            ////////     // Thread.Sleep(10000);
            ////////     Dictionary<string, ObjConnected>.ValueCollection arr7 = DicAllSessions.Values;
            ////////     ObjConnected[] arrAllConnectedWS2 = new ObjConnected[arr7.Count];
            ////////     arr7.CopyTo(arrAllConnectedWS2, 0);

            ////////     Dictionary<string, ObjConnected>.KeyCollection arr2 = DicAllSessions.Keys;
            ////////     string[] arrCon2 = new string[arr2.Count];
            ////////     arr2.CopyTo(arrCon2, 0);

            ////////     Dictionary<string, object> DicManagersa = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
            ////////     Dictionary<string, object> DicAgentsa = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
            ////////     for (int i = 0; i < arrAllConnectedWS2.Length; i++)
            ////////     {
            ////////         try
            ////////         {
            ////////             //SocketConnected(((ObjConnected)arrAllConnectedWS2[i]).clientSocket, arrCon2[i]);
            ////////             try
            ////////             {
            ////////                 if (ms1 == ((ObjConnected)arrAllConnectedWS2[i]).clientSocket)
            ////////                 {
            ////////                     Socket ms = ((ObjConnected)arrAllConnectedWS2[i]).clientSocket;
            ////////                     string mClientID = arrCon2[i];

            ////////                     ////bool part1 = ms.Poll(3000, SelectMode.SelectRead);
            ////////                     ////bool part2 = (ms.Available == 0);


            ////////                     ////if (part1 && part2)



            ////////                     {


            ////////                     }
            ////////                 }
            ////////             }
            ////////             catch (Exception ex1)
            ////////             { }
            ////////         }
            ////////         catch (Exception ex)
            ////////         {
            ////////         }
            ////////     }

            //////// }

            //bool part1 = s.Poll(3000, SelectMode.SelectRead);
            //mainClientID = ClientID;
            //s = s;
            ////System.Timers.Timer aTimer = new System.Timers.Timer();
            ////aTimer.Elapsed += new ElapsedEventHandler(OnTimedEventSocketConnected);
            ////aTimer.Interval = 2000;
            ////aTimer.Enabled = true;
        }
        private static void DisConnectVlint(Socket ms, string mClientID)
        {

            Dictionary<string, object> DicManagersa = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
            Dictionary<string, object> DicAgentsa = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
            try
            {
                OnClose(mClientID, "", "Session Close By Loop  - Server close connection");

                ms.Shutdown(SocketShutdown.Both);
            }
            catch (Exception ex1)
            { }

            try
            {
                ms.Close();
            }
            catch (Exception ex1)
            { }

            try
            {
                ms.Disconnect(true);
            }
            catch (Exception ex1)
            { }

            try
            {
                //s.Dispose();
            }
            catch (Exception ex1)
            { }

            try
            {
                DicAllSessions.Remove(mClientID);
            }
            catch (Exception ex1)
            { }

            try
            {
                object d;
                if (DicManagersa.TryGetValue(mClientID, out d))
                    DicManagersa.Remove(mClientID);
            }
            catch (Exception ex1)
            { }

            try
            {
                object d;
                if (DicAgentsa.TryGetValue(mClientID, out d))
                    DicAgentsa.Remove(mClientID);
            }
            catch (Exception ex1)
            { }
        }
        private static void OnTimedEventSocketConnected(object sender, ElapsedEventArgs e)
        {
            if (ms.Poll(5000, SelectMode.SelectRead) && ms.Available == 0)
            {
                DisConnectVlint(ms, mClientID);
            }
            aTimer.Enabled = false;
            ////Dictionary<string, object> DicManagersa = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
            ////Dictionary<string, object> DicAgentsa = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);

            ////if (!ms.Connected)
            ////{
            ////    try
            ////    {
            ////        OnClose(mClientID, "", "Session Close By Loop  - Server close connection");

            ////        ms.Shutdown(SocketShutdown.Both);
            ////    }
            ////    catch (Exception ex1)
            ////    { }

            ////    try
            ////    {
            ////        ms.Close();
            ////    }
            ////    catch (Exception ex1)
            ////    { }

            ////    try
            ////    {
            ////        ms.Disconnect(true);
            ////    }
            ////    catch (Exception ex1)
            ////    { }

            ////    try
            ////    {
            ////        //s.Dispose();
            ////    }
            ////    catch (Exception ex1)
            ////    { }

            ////    try
            ////    {
            ////        DicAllSessions.Remove(mClientID);
            ////    }
            ////    catch (Exception ex1)
            ////    { }

            ////    try
            ////    {
            ////        object d;
            ////        if (DicManagersa.TryGetValue(mClientID, out d))
            ////            DicManagersa.Remove(mClientID);
            ////    }
            ////    catch (Exception ex1)
            ////    { }

            ////    try
            ////    {
            ////        object d;
            ////        if (DicAgentsa.TryGetValue(mClientID, out d))
            ////            DicAgentsa.Remove(mClientID);
            ////    }
            ////    catch (Exception ex1)
            ////    { }







            ////}
        }

        private static void OnClose(string agentID, string managerID, string disconectReason)
        {
            var AgentID = agentID;
            //AgentID = !AgentID.IsNullOrEmpty() ? AgentID : ("0");
            if (AgentID.Length > 1)
            {
                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                object d = null;
                if (Dic != null)
                {
                    if (Dic.TryGetValue(AgentID, out d))
                    {
                        Dic.Remove(AgentID);
                        ((Socket)d).Close();
                    }
                }
                Tools.AddRowToLog(AgentID.ToString() + " Disconnected, Reason:" + disconectReason, Program.LogDirectory, Program.LogFileName);
            }
            else
            {
                var ManagerID = managerID;
                //ManagerID = !ManagerID.IsNullOrEmpty() ? ManagerID : ("0");
                if (ManagerID.Length > 1)
                {
                    bool IsAlreadyFillFromPushServer = false;
                    string mngID = ManagerID;
                    if (mngID.IndexOf(";") > -1)
                        mngID = mngID.Split(';')[0];
                    WR.DeleteFromDicManagersConnectedPushServer(mngID.ToString(), out IsAlreadyFillFromPushServer);

                    Dictionary<string, object> DicM = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                    object d = null;

                    if (DicM == null)
                        DicM = new Dictionary<string, object>();

                    if (DicM.TryGetValue(ManagerID, out d))
                    {
                        DicM.Remove(ManagerID);
                        //((Socket)d).Shutdown(SocketShutdown.Both);
                        //((Socket)d).Close();
                    }
                    Tools.AddRowToLog("Manager " + ManagerID.ToString() + " Disconnected, Reason: " + disconectReason, Program.LogDirectory, Program.LogFileName);

                    string[] arrManagersConnected = new string[DicM.Keys.Count];
                    DicM.Keys.CopyTo(arrManagersConnected, 0);

                    if (!IsAlreadyFillFromPushServer)
                    {
                        StringBuilder sb = new StringBuilder();
                        for (int i = 0; i < arrManagersConnected.Length; i++)
                        {
                            sb.Append(arrManagersConnected[i].Split(';')[0] + ";");
                        }

                        WR.FillAllFromPushServer(sb.ToString());
                    }
                }
            }
            //Sessions.Broadcast(String.Format("{0} got logged off...", _name));
        }
    }
    public static class SocketExtensions
    {
        public static bool IsConnected(this Socket socket)
        {
            try
            {
                return !(socket.Poll(1000, SelectMode.SelectRead) && socket.Available == 0);
            }
            catch (SocketException) { return false; }
        }
    }

}



