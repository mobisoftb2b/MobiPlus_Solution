using System;
using System.Threading;
using WebSocketSharp;
using WebSocketSharp.Server;
using System.IO;
using MobiPlusServer;
using PushServer.MPService;
using CacheHandler;
using System.Collections.Generic;
using MobiPlusTools;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Text;

namespace MobiPlusServer
{

    public class PushServer : WebSocketBehavior
    {
        private static int _num = 0;

        private string _name;
        private string _prefix;
        private MobiPlusService WR;
        private static string DicConnectionsName;
        private static string DicManagersConnectionsName;
        // private static CacheObj cacheObj = new CacheObj();
        
        public PushServer()
            : this(null)
        {
            WR = new MobiPlusService();
            DicConnectionsName = "AllConnections";
            DicManagersConnectionsName = "AllManagersConnections";
            
        }
       
        public PushServer(string prefix)
        {
            _prefix = !prefix.IsNullOrEmpty() ? prefix : "anon#";
        }

        private string getName()
        {
            var name = Context.QueryString["name"];
            return !name.IsNullOrEmpty() ? name : (_prefix + getNum());
        }

        private static int getNum()
        {
            return Interlocked.Increment(ref _num);
        }

        protected override void OnOpen()
        {
            var NewWS = Context.QueryString["NewWS"];
            if (NewWS != null)
            {
                var AgentID = Context.QueryString["AgentID"];
                if (AgentID != null)
                {
                    AgentID = !AgentID.IsNullOrEmpty() ? AgentID : ("0");

                    _name = getName();

                    PushServer c = new PushServer();
                    foreach (var s in Sessions.IDs)
                    {
                        if (s == this.ID)
                        {
                            c = (PushServer)Sessions[s];
                            break;
                        }
                    }
                    Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);

                    if (Dic == null)
                        Dic = new Dictionary<string, object>();
                    object d;
                    if (Dic.TryGetValue(AgentID, out d))
                        Dic[AgentID] = c;
                    else
                        Dic.Add(AgentID, c);

                    if (Program.cacheObj.Get(DicConnectionsName) == null)
                        Program.cacheObj.Add(DicConnectionsName, Dic);
                    else
                        Program.cacheObj.Update(DicConnectionsName, Dic);

                    Tools.AddRowToLog(AgentID.ToString() + " Connect", Program.LogDirectory, Program.LogFileName);
                }
                else
                {
                    var ManagerID = Context.QueryString["ManagerID"];
                    if (ManagerID != null)
                    {
                        bool IsAlreadyFillFromPushServer = false;
                        WR.AddToDicManagersConnectedPushServer(ManagerID.ToString(), out IsAlreadyFillFromPushServer);

                        Dictionary<string, object> DicManagers = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);

                        if (DicManagers == null)
                            DicManagers = new Dictionary<string, object>();

                        object d;

                        

                        PushServer c = new PushServer();
                        foreach (var s in Sessions.IDs)
                        {
                            if (s == this.ID)
                            {
                                c = (PushServer)Sessions[s];
                                break;
                            }
                        }

                        

                        if (DicManagers.TryGetValue(ManagerID, out d))
                            DicManagers[ManagerID] = c;
                        else
                            DicManagers.Add(ManagerID, c);

                        if (Program.cacheObj.Get(DicManagersConnectionsName) == null)
                            Program.cacheObj.Add(DicManagersConnectionsName, DicManagers);
                        else
                            Program.cacheObj.Update(DicManagersConnectionsName, DicManagers);

                        Tools.AddRowToLog("Manager:" + ManagerID.ToString() + " Connect", Program.LogDirectory, Program.LogFileName);

                        string[] arrManagersConnected = new string[DicManagers.Keys.Count];
                        DicManagers.Keys.CopyTo(arrManagersConnected, 0);

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
            }
        }
        private string getVal(string val)
        {
            return val.Replace("\"", "").Replace("'", "");
        }
        
        protected override void OnMessage(MessageEventArgs e)
        {
            MobiPlusService WR = new MobiPlusService();

            string[] arrData = e.Data.Split(';');
            try
            {

                if (arrData.Length == 2 && arrData[0] == "isToManager")
                {
                    
                    JObject data = JsonConvert.DeserializeObject<JObject>(arrData[1]);
                   
                    string AgentID = getVal(data["AgentId"].ToString());
                    if(AgentID.Length < 4)
                        AgentID = AgentID.PadLeft(4,'0');

                    WR.AddToPasswordManagerAsync(getVal(data["RequestID"].ToString()), getVal(data["pTime"].ToString()), AgentID, getVal(data["AgentName"].ToString()), getVal(data["EmployeeId"].ToString()), getVal(data["EmployeeName"].ToString()), getVal(data["ActivityCode"].ToString()), getVal(data["ActivityDescription"].ToString()), getVal(data["Cust_Key"].ToString()),
                        getVal(data["CustName"].ToString()), getVal(data["DocType"].ToString()), getVal(data["DocName"].ToString()), getVal(data["Comment"].ToString()), getVal(data["ManagerEmployeeId"].ToString()), getVal(data["ManagerName"].ToString()), getVal(data["StatusChangeTime"].ToString()), getVal(data["RequestStatus"].ToString()), getVal(data["ManagerStatusTime"].ToString()), getVal(data["ManagerComment"].ToString()),
                        getVal(data["ManagerDeviceType"].ToString()), getVal(data["TransmissionState"].ToString()), getVal(data["Subject"].ToString()), getVal(data["IsTest"].ToString()));

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
                            PushServer c = (PushServer)d;
                            string msg = "GET_MANAGER_SYNC_REPLAY;" + getVal(data["AgentName"].ToString()) + ";0"; ;
                            if (getVal(data["RequestStatus"].ToString()) != "0")//ידני
                                msg = "GET_MANAGER_SYNC_REPLAY_MANUAL;" + getVal(data["AgentName"].ToString()) + ";0";

                            c.sendMSGtoManager(msg, arrManagersSelected[i]);
                        }
                    }
                }
                else if (arrData.Length > 2 && arrData[0] == "isToManager" && arrData[2].IndexOf("cancel msg") > -1)//cancel msg
                {
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
                            PushServer c = (PushServer)d;
                            string msg = "cancel msg;0;" + data["RequestID"].ToString();
                            c.sendMSGtoManager(msg, arrManagersSelected[i]);
                        }
                    }

                }
                else if (arrData.Length > 3 && arrData[0].IndexOf("toAgent") > -1)
                {
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
                            PushServer c = (PushServer)d;
                            string msg = "[{\"MSG\":\"Approved MSG REPLAY\",\"Approved\":\"" + arrData[2].Split(':')[1].Trim() + "\",\"Requestid\":\"" + arrData[1].Split(':')[1].Trim() + "\",\"RequestStatus\":\"" + RequestStatus + "\",\"ManagerComment\":\"" + arrData[3].Split(':')[1].Trim() + "\"}]";
                            //msg;approved;requestid;RequestStatus;ManagerComment

                            c.sendMSGToAgent(msg, arrData[0].Split(':')[1].Trim().Replace("'", "").Replace("\"", ""), c);
                        }
                    }

            
                    Dictionary<string, object> DicManagers = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
                    if (DicManagers == null)
                        DicManagers = new Dictionary<string, object>();

                    string[] arrManagersConnected = new string[DicManagers.Keys.Count];
                    string[] arrManagersSelected = new string[DicManagers.Keys.Count];
                    DicManagers.Keys.CopyTo(arrManagersConnected, 0);
                    counter = 0;
                    var ManagerID = Context.QueryString["ManagerID"];
                    ManagerID = !ManagerID.IsNullOrEmpty() ? ManagerID : ("0");

                    for (int i = 0; i < arrManagersConnected.Length; i++)
                    {
                        if (arrManagersConnected[i].IndexOf(ManagerID.Split(';')[0] + ";") == 0 && arrManagersConnected[i] != ManagerID)//found
                        {
                            arrManagersSelected[counter] = arrManagersConnected[i];
                            counter++;
                        }
                    }
                    for (int i = 0; i < arrManagersSelected.Length; i++)
                    {
                        if (arrManagersSelected[i] != null && DicManagers.TryGetValue(arrManagersSelected[i], out d))
                        {
                            PushServer c = (PushServer)d;
                            string msg = "Update_Request;" + arrData[1].Split(':')[1].Trim() + ";" + RequestStatus; //Update_Request;REQUSETID;RequestStatus
                            
                            c.sendMSGtoManager(msg, arrManagersSelected[i]);
                        }
                    }
                }
                else if (arrData.Length > 3 && arrData[0].IndexOf("GetManagersList") > -1)//GetManagersList;1234;7;;
                {
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
                        ((PushServer)d).sendMSGToAgent(";ManagersListReplayToAgent;" + GetJson(dt), arrData[1] + ";" + arrData[2], ((PushServer)d));
                    }
                }
                else if (arrData.Length > 3 && arrData[0].IndexOf("TestSend") > -1)//GetManagersList;1234;7;;
                {
                    Dictionary<string, object> DicAgents = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                    if (DicAgents == null)
                        DicAgents = new Dictionary<string, object>();
                    
                    object d;                    

                    if (DicAgents.TryGetValue(Convert.ToInt64(arrData[1]).ToString() + ";" + arrData[2], out d))
                    {
                        ((PushServer)d).sendMSGToAgent("t;TestReplay;t;t;t", arrData[1] + ";" + arrData[2], ((PushServer)d));
                    }
                }
            }
            catch (Exception ex)
            {
                Tools.AddRowToLog("Error OnMessage: " + ex.Message, Program.LogDirectory, Program.LogFileName);
            }
        }
        
        public string GetJson(DataTable dt)
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
        private bool IsManagerConnected(string ManagerID)
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


        protected override void OnClose(CloseEventArgs e)
        {
            var AgentID = Context.QueryString["AgentID"];
            AgentID = !AgentID.IsNullOrEmpty() ? AgentID : ("0");
            if (AgentID != "0")
            {
                Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
                object d = null;
                if (Dic != null)
                {
                    if (Dic.TryGetValue(AgentID, out d))
                    {
                        Dic.Remove(AgentID);
                        ((PushServer)d).Disconnct(((PushServer)d));
                    }
                }
                Tools.AddRowToLog(AgentID.ToString() + " Disconnected, Reason: " + e.Reason.ToString(), Program.LogDirectory, Program.LogFileName);
            }
            else
            {
                var ManagerID = Context.QueryString["ManagerID"];
                ManagerID = !ManagerID.IsNullOrEmpty() ? ManagerID : ("0");
                if (ManagerID != "0")
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
                        ((PushServer)d).Disconnct(((PushServer)d));
                    }
                    Tools.AddRowToLog("Manager " + ManagerID.ToString() + " Disconnected, Reason: " + e.Reason.ToString(), Program.LogDirectory, Program.LogFileName);

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
        public void sendMSG(string txt, string mAgentID)
        {
            Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicConnectionsName);
            if (Dic != null)
            {
                object obj = new object();
                if (Dic.TryGetValue(mAgentID, out obj))
                {
                    Action<bool> completed = null;
                    ((PushServer)obj).SendAsync(txt, completed);
                    //((PushServer)obj).Send(txt);
                }

            }
            //{
            //    //System.Threading.ThreadPool.QueueUserWorkItem(delegate
            //    //{
            //        var name = Context.QueryString["name"];
            //        var msg = !name.IsNullOrEmpty()
            //                  ? String.Format("'{0}' to {1}", txt, name)
            //                  : txt;

            //        Send(msg);
            //    //}, null);
        }
        public void sendMSGToAgent(string txt, string mAgentID, PushServer obj)
        {
            Action<bool> completed = null;
            obj.SendAsync(txt, completed);
        }
        public void sendMSGAsBlobToAgent(string txt, string mAgentID, PushServer obj)
        {
            Action<bool> completed = null;
            obj.SendAsync(GetBytes(txt), completed);
        }
        static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }

        public void sendMSGtoManager(string txt, string managerID)
        {
            Dictionary<string, object> Dic = (Dictionary<string, object>)Program.cacheObj.Get(DicManagersConnectionsName);
            if (Dic != null)
            {
                object obj = new object();
                if (Dic.TryGetValue(managerID, out obj))
                {
                    Action<bool> completed = null;
                    ((PushServer)obj).SendAsync(txt, completed);
                    //((PushServer)obj).Send(txt);
                }

            }

        }
        public void sendFile(string path)
        {
            try
            {
                byte[] bFile = File.ReadAllBytes(path);

                Send(bFile);
            }
            catch (Exception Ex)
            {
            }
        }
        public bool Disconnct(PushServer obj)
        {
            try
            {
                ((PushServer)obj).Sessions[obj.ID].Context.WebSocket.Close();

                return true;
            }
            catch (Exception ex)
            {
            }
            return false;
        }
    }
}
