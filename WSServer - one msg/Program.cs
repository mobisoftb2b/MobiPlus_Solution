using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.IO;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.InteropServices;
using MobiPlusTools;
using WSServer.MPService;
using System.Configuration;
using System.Security.Cryptography.X509Certificates;
using CacheHandler;
using System.Data;
using System.ServiceProcess;
using System.Net.Security;
using System.Security.Authentication;


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
        private static int port = 8097;
        private static Thread thread;
        private static StateObject myState = null;
        private static SocketAsyncEventArgs saea = null;

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
        private static MobiPlusService WR = new MobiPlusService();
        private static string DisconectReason = "";

        public Program()
        {
            this.ServiceName = ServiceName1;
        }
        static void Main(string[] args)
        {
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


            port = Convert.ToInt32(System.Configuration.ConfigurationSettings.AppSettings["ServerPort"].ToString());
            string ip = System.Configuration.ConfigurationSettings.AppSettings["ServerHost"].ToString();
            localIPAdress = IPAddress.Parse(ip); //Dns.GetHostAddresses("").Where(i => i.AddressFamily == AddressFamily.InterNetwork).First();

            saea = new SocketAsyncEventArgs();
            saea.Completed += new EventHandler<SocketAsyncEventArgs>(saea_Completed);


            Tools.AddRowToLog("\r\n************************** Start **************************", LogDirectory, LogFileName);

            Tools.AddRowToLog("WebSocket WSServer by MobiSoft listening on ws::" + ip + " port: " + port.ToString() + ";", LogDirectory, LogFileName);

            serverSocket.Bind(new IPEndPoint(localIPAdress, port));
            serverSocket.Listen(128);
            serverSocket.BeginAccept(null, 0, OnAccept, null);

            thread = new Thread(new ThreadStart(PushServer));
            thread.Start();

            Console.Read();
        }
        private static void OnDisconnect(IAsyncResult result)
        {

        }
        private static void OnSend(IAsyncResult result)
        {
        }

        private static void OnReceive(IAsyncResult result)
        {
            try
            {
                myState = (StateObject)result.AsyncState;
                string msg = "";
                Socket handler = myState.workSocket;

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
                    Buffer.BlockCopy(myState.buffer, index, Key, 0, 4);

                    var key = Key;

                    byte[] _data = new byte[bytesRead - 4 - index];
                    Buffer.BlockCopy(myState.buffer, 4 + index, _data, 0, bytesRead - 4 - index);

                    for (long i = 0; i < _data.Length; i++)
                        _data[i] = (byte)(_data[i] ^ key[i % 4]);

                    msg = System.Text.Encoding.UTF8.GetString(_data);
                   
                    if (_data.Length == 2 && _data[0] == 3 && _data[1] == 233)
                    {
                        string disconectReason = "Client close connection";
                        Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
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
                                OnClose(arrCon2[i], "",disconectReason);
                                isClosed = true;
                                break;
                            }
                        }

                        
                    }
                    if (!isClosed)
                    {
                        if (msg.Length > 0)
                            SendMSG(msg.Substring(0, msg.IndexOf("&")), msg.Substring(msg.IndexOf("&") + 1, msg.Length - msg.IndexOf("&") - 1));

                        Register(myState.UserToken);
                    }
                }
               
                
            }
            catch (Exception ex)
            {
                int t = 1;
            }
        }
        private static void SendMSG(string to, string msg)
        {
            Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
            if (Dic != null)
            {
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
                    ((Socket)obj).SendAsync(saea);
                }

            }
        }
        static void saea_Completed(object sender, SocketAsyncEventArgs e)
        {
            Register(e.UserToken.ToString());
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

                        ((Socket)obj).BeginReceive(myState.buffer, 0, 1024, 0
                                                  , new AsyncCallback(OnReceive), myState);
                    }
                }
            }
            catch (Exception ex)
            {
            }
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

                    var i = client.Receive(buffer);
                    headerResponse = (System.Text.Encoding.UTF8.GetString(buffer)).Substring(0, i);
                    // write received data to the console
                    Console.WriteLine(headerResponse);

                    Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                    AgentID = headerResponse.Substring(headerResponse.IndexOf("=") + 1, headerResponse.IndexOf("&") - 1 - headerResponse.IndexOf("="));
                    Tools.AddRowToLog(AgentID.ToString() + " Connected", Program.LogDirectory, Program.LogFileName);

                    if (Dic == null)
                        Dic = new Dictionary<string, object>();
                    object d;
                    if (Dic.TryGetValue(AgentID, out d))
                        Dic[AgentID] = client;
                    else
                        Dic.Add(AgentID, client);

                    if (Program.cacheObj.Get(DicConnectionsName) == null)
                        Program.cacheObj.Add(DicConnectionsName, Dic);
                    else
                        Program.cacheObj.Update(DicConnectionsName, Dic);

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
                    client.Send(System.Text.Encoding.UTF8.GetBytes(response));


                    state.UserToken = AgentID;
                    if (client.Connected)
                    {
                        client.BeginReceive(state.buffer, 0, 1024, 0
                                                  , new AsyncCallback(OnReceive), state);
                    }
                }
            }
            catch (SocketException exception)
            {
                //throw exception;
            }
            finally
            {
                if (serverSocket != null && serverSocket.IsBound)
                {
                    serverSocket.BeginAccept(null, 0, OnAccept, null);
                }
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
                    WR.DeleteFromDicManagersConnectedPushServer(ManagerID.ToString(), out IsAlreadyFillFromPushServer);

                    Dictionary<string, object> DicM = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                    object d = null;

                    if (DicM == null)
                        DicM = new Dictionary<string, object>();

                    if (DicM.TryGetValue(ManagerID, out d))
                    {
                        DicM.Remove(ManagerID);
                        ((Socket)d).Close();
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
}



