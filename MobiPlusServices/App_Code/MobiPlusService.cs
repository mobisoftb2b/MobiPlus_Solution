using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data;
using System.Web.Script.Serialization;
using System.Text;


using System.Configuration;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Web.Caching;
using System.IO;
using System.IO.Compression;
using Ionic.Zip;
using System.Diagnostics;
using CacheHandler;
using System.Drawing;
using MobiPlusTools;
using Newtonsoft.Json;
using System.Runtime.Serialization;
using System.Net;
using Newtonsoft.Json.Linq;

[WebService(Namespace = "http://microsoft.com/webservices/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class MobiPlusService : ServiceBaseCls
{
    #region Private Variables
    private Stopwatch timer = new Stopwatch();
    private static readonly Object obj = new Object();
    public static bool isToRefreshCache = false;
    private Dictionary<string, FilesNDirs> DicAllArrList = new Dictionary<string, FilesNDirs>();
    private Dictionary<string, FileInfo> DicAllfilesList = new Dictionary<string, FileInfo>();
    private string LogDir = ConfigurationManager.AppSettings["LogDirectory"].ToString();
    public static bool isToCheckBlocked = false;

    public static string StraussOnDB = "[sides-android].dbo.";
    public static string MobiPlusWebOnDB = "mobipluswebsides.dbo.";

    private static Dictionary<string, string> dicManagersConnectedToPushServer = new Dictionary<string, string>();
    private static bool isAlreadyFillFromPushServer = false;

    private static string MapsServerAddress = "";
    private static string MapsSendDemoSMSTo = "";
    private static string SMSMaps = "";
    private static string SMSMaps2 = "";

    private static string GeneralDir = "";

    #endregion

    #region Constractor
    public MobiPlusService()
    {
        try
        {
            if (ConfigurationManager.AppSettings["LogDirectory"] != null)
                LogDir = ConfigurationManager.AppSettings["LogDirectory"].ToString();

            if (ConfigurationManager.AppSettings["isToCheckBlocked"] != null)
                isToCheckBlocked = Convert.ToBoolean(ConfigurationManager.AppSettings["isToCheckBlocked"].ToString());

            if (!(Directory.Exists(ConfigurationManager.AppSettings["ZipFiles"].ToString())))
            {
                Directory.CreateDirectory(ConfigurationManager.AppSettings["ZipFiles"].ToString());
            }

            if (!(Directory.Exists(ConfigurationManager.AppSettings["UploadFiles"].ToString())))
            {
                Directory.CreateDirectory(ConfigurationManager.AppSettings["UploadFiles"].ToString());
            }

            if (!(Directory.Exists(ConfigurationManager.AppSettings["TmpFiles"].ToString())))
            {
                Directory.CreateDirectory(ConfigurationManager.AppSettings["TmpFiles"].ToString());
            }
            if (!(Directory.Exists(ConfigurationManager.AppSettings["ArchiveFiles"].ToString())))
            {
                Directory.CreateDirectory(ConfigurationManager.AppSettings["ArchiveFiles"].ToString());
            }

            if (ConfigurationManager.AppSettings["StraussOnDB"] != null)
                StraussOnDB = ConfigurationManager.AppSettings["StraussOnDB"].ToString();
            if (ConfigurationManager.AppSettings["MobiPlusWebOnDB"] != null)
                MobiPlusWebOnDB = ConfigurationManager.AppSettings["MobiPlusWebOnDB"].ToString();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    #endregion

    #region Public Actions
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void GetAPKFile()
    {
        try
        {
            //lock (obj)
            {


                byte[] arrBytes = new Byte[0];
                if (File.Exists(ConfigurationManager.AppSettings["ApkSrc"].ToString()))
                {
                    ResponsBytesApp(File.ReadAllBytes(ConfigurationManager.AppSettings["ApkSrc"].ToString()), "apk");
                }
                else
                {
                    throw new Exception(ConfigurationManager.AppSettings["ApkSrc"].ToString() + " Not Exist");
                }
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void GetFileDirect(string FileName)
    {
        try
        {
            //lock (obj)
            {
                FileName = FileName.Replace("/", "\\");

                byte[] arrBytes = new Byte[0];
                if (File.Exists(ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName))
                {
                    ResponsBytesTest(File.ReadAllBytes(ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName), "zip");
                }
                else
                {
                    throw new Exception(FileName + " Not Exist");
                }
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void GetDocument(string FileName, string Date, string Pass)
    {
        try
        {
            if (Pass != "MTN2016")
                return;

            if (GeneralDir=="" && System.Configuration.ConfigurationManager.AppSettings["DocManagementDir"] != null)
                GeneralDir = System.Configuration.ConfigurationManager.AppSettings["DocManagementDir"].ToString();

            FileInfo fi = new FileInfo(GeneralDir + FileName);
            if (Date != "" && fi.CreationTime < Convert.ToDateTime(Date))
            {
                ResponseToUpload(208, "208 Not Need to Download");
                return;
            }

            Context.Response.Clear();
            switch (FileName.Split('.')[1].ToLower())
            {
                case "pdf":
                    Context.Response.ContentType = "application/pdf";
                    break;
                case "txt":
                    Context.Response.ContentType = "text/plain";
                    break;
                case "xls":
                    Context.Response.ContentType = "application/vnd.ms-excel";
                    break;
                case "xlsx":
                    Context.Response.ContentType = "application/vnd.ms-excel";
                    break;
                case "doc":
                    Context.Response.ContentType = "application/msword";
                    break;
                case "docx":
                    Context.Response.ContentType = "application/msword";
                    break;
                case "ppt":
                    Context.Response.ContentType = "application/vnd.ms-powerpoint";
                    break;
                case "pptx":
                    Context.Response.ContentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                    break;
                case "png":
                    Context.Response.ContentType = "image/png";
                    break;
                case "jpg":
                    Context.Response.ContentType = "image/jpeg";
                    break;
            }

           


            byte[] file = File.ReadAllBytes(Server.UrlDecode(GeneralDir + FileName).Replace("~", "\\"));
            Context.Response.AddHeader("content-disposition", "attachment;    filename=file." + FileName.Split('.')[1]);
            Context.Response.AddHeader("File-Name", "file." + FileName.Split('.')[1]);
            Context.Response.AddHeader("content-length", file.Length.ToString());
            Context.Response.BinaryWrite(file);
            //Context.Response.Flush();
            //Context.Response.End();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }

        ResponseToUpload(200, "OK");
        return;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void GetFile(string FileName)
    {
        try
        {
            //lock (obj)
            {
                Session["test"] = true;
                string AgentID = Context.Request.QueryString["AgentID"] == null ? "0" : Context.Request.QueryString["AgentID"].ToString();
                string LogID = "0";
                timer.Reset();
                timer.Start();

                DataTable dtt = DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                if (dtt != null && dtt.Rows.Count > 0)
                    LogID = dtt.Rows[0][0].ToString();
                FileName = FileName.Replace("/", "\\");

                byte[] arrBytes = new Byte[0];
                if (File.Exists(ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName))
                {
                    if (FileName.ToLower().IndexOf(".zip") > -1)
                    {
                        //Context.Response.Buffer = false;
                        //Context.Response.TransmitFile(ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName);
                        ResponsBytes(File.ReadAllBytes(ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName), "zip");

                        timer.Stop();

                        DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                    }
                    else
                    {
                        string fName = FileName.Split('\\')[FileName.Split('\\').Length - 1];
                        string resFile = ConfigurationManager.AppSettings["ZipFiles"].ToString() + fName + ".zip";
                        string srcFile = ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName;

                        CreateZip(srcFile, resFile);

                        //Context.Response.Buffer = false;
                        //Context.Response.TransmitFile(resFile);
                        ResponsBytes(File.ReadAllBytes(resFile), "zip");

                        timer.Stop();

                        DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                    }
                }
                else
                {
                    throw new Exception(FileName + " Not Exist");
                }
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void DownloadFile(string FileName)
    {
        try
        {
            //lock (obj)
            {
                string AgentID = Context.Request.QueryString["AgentID"] == null ? "0" : Context.Request.QueryString["AgentID"].ToString();
                string LogID = "0";
                timer.Reset();
                timer.Start();

                DataTable dtt = DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                if (dtt != null && dtt.Rows.Count > 0)
                    LogID = dtt.Rows[0][0].ToString();
                FileName = FileName.Replace("/", "\\");

                byte[] arrBytes = new Byte[0];
                if (File.Exists(ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName))
                {
                    ResponsBytes(File.ReadAllBytes(ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName), FileName.Split('.')[FileName.Split('.').Length - 1]);

                    timer.Stop();

                    DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                }
                else
                {
                    throw new Exception(FileName + " Not Exist");
                }
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string UploadStrFile(string FileName, string strFile)
    {
        try
        {
            byte[] bFile = Convert.FromBase64String(strFile);
            return UploadFile(FileName, bFile);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "SERVER FAIL";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string UploadFile(string FileName, byte[] bFile)
    {
        try
        {
            string AgentID = "";
            string tmp = "";

            if (FileName.IndexOf("DB") > -1)
            {
                tmp = FileName.Substring(FileName.IndexOf("DB") + 2, FileName.Length - (FileName.IndexOf("DB") + 2));
                AgentID = tmp.Split('_')[0];
            }
            else
            {
                tmp = FileName.Substring(FileName.IndexOf("X") + 1, FileName.Length - (FileName.IndexOf("X") + 1));
                AgentID = tmp.Split('_')[0];
            }


            string Dir = ConfigurationManager.AppSettings["UploadFiles"].ToString();
            File.WriteAllBytes(Dir + FileName, bFile);

            string DirArchive = ConfigurationManager.AppSettings["ArchiveFiles"].ToString();
            DirArchive += @"\" + AgentID + @"\";

            if (!(Directory.Exists(DirArchive)))
            {
                Directory.CreateDirectory(DirArchive);
            }

            File.WriteAllBytes(DirArchive + FileName, bFile);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "SERVER FAIL";
        }
        return "OK";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string UploadSplitedFile(string FileName, byte[] bFile, string Pass)
    {
        if (Pass != "Mobi2015MTN")
            return "FAIL";
        try
        {
            string Dir = ConfigurationManager.AppSettings["UploadFiles"].ToString() + "SplitedZip\\";
            if (!(Directory.Exists(Dir)))
            {
                Directory.CreateDirectory(Dir);
            }
            File.WriteAllBytes(Dir + FileName, bFile);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "SERVER FAIL";
        }
        return "OK";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string UploadFile_DblCheck(string FileName, byte[] bFile)
    {
        try
        {
            string AgentID = "";
            string tmp = "";

            if (FileName.IndexOf("DB") > -1)
            {
                tmp = FileName.Substring(FileName.IndexOf("DB") + 2, FileName.Length - (FileName.IndexOf("DB") + 2));
                AgentID = tmp.Split('_')[0];
            }
            else
            {
                tmp = FileName.Substring(FileName.IndexOf("X") + 1, FileName.Length - (FileName.IndexOf("X") + 1));
                AgentID = tmp.Split('_')[0];
            }


            string Dir = ConfigurationManager.AppSettings["UploadFiles"].ToString();
            File.WriteAllBytes(Dir + "tmp_" + FileName, bFile);

            string DirArchive = ConfigurationManager.AppSettings["ArchiveFiles"].ToString();
            DirArchive += @"\" + AgentID + @"\";

            if (!(Directory.Exists(DirArchive)))
            {
                Directory.CreateDirectory(DirArchive);
            }

            File.WriteAllBytes(DirArchive + FileName, bFile);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "SERVER FAIL";
        }
        return "OK";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string HandShake(string FileName)
    {
        try
        {

            string Dir = ConfigurationManager.AppSettings["UploadFiles"].ToString();
            System.IO.File.Move(Dir + "tmp_" + FileName, Dir + FileName);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "SERVER FAIL";
        }
        return "OK";
    }
    //[WebMethod(EnableSession = true)]
    //[ScriptMethod(UseHttpGet = true)]
    //public string UploadFile(string FileName, byte[] bFile)
    //{
    //    try
    //    {
    //        string AgentID = "";
    //        string tmp = "";

    //        if (FileName.IndexOf("DB") > -1)
    //        {
    //            tmp = FileName.Substring(FileName.IndexOf("DB") + 2, FileName.Length - (FileName.IndexOf("DB") + 2));
    //            AgentID = tmp.Split('_')[0];
    //        }
    //        else
    //        {
    //            tmp = FileName.Substring(FileName.IndexOf("X") + 1, FileName.Length - (FileName.IndexOf("X") + 1));
    //            AgentID = tmp.Split('_')[0];
    //        }


    //        string Dir = ConfigurationManager.AppSettings["UploadFiles"].ToString();
    //        File.WriteAllBytes(Dir + FileName, bFile);

    //        string DirArchive = ConfigurationManager.AppSettings["ArchiveFiles"].ToString();
    //        DirArchive += @"\" + AgentID + @"\";

    //        if (!(Directory.Exists(DirArchive)))
    //        {
    //            Directory.CreateDirectory(DirArchive);
    //        }

    //        File.WriteAllBytes(DirArchive + FileName, bFile);
    //    }
    //    catch (Exception ex)
    //    {
    //        Tools.HandleError(ex, LogDir);
    //        return "SERVER FAIL";
    //    }
    //    return "OK";
    //}
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string CheckIfFileExsits(string FileName)
    {
        try
        {
            string AgentID = "";
            string tmp = "";

            if (FileName.IndexOf("DB") > -1)
            {
                tmp = FileName.Substring(FileName.IndexOf("DB") + 2, FileName.Length - (FileName.IndexOf("DB") + 2));
                AgentID = tmp.Split('_')[0];
            }
            else
            {
                tmp = FileName.Substring(FileName.IndexOf("X") + 1, FileName.Length - (FileName.IndexOf("X") + 1));
                AgentID = tmp.Split('_')[0];
            }

            string DirArchive = ConfigurationManager.AppSettings["ArchiveFiles"].ToString();
            DirArchive += @"\" + AgentID + @"\";

            if (File.Exists(DirArchive + FileName))
                return "EXISTS";
            else
                return "NOT EXISTS";
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "SERVER FAIL";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void GetIsThereNewVersion(string AgentID, string FromVersion, string ProjectType = "1")
    {
        /*ProjectType = 1 = סוכנים*/
        /*ProjectType = 2 = מנהלים*/
        /*ProjectType = 3 = פרופילים*/
        try
        {
            DataTable dt = DAL.DAL.GetServerVersion(AgentID, FromVersion, ProjectType);
            string res = "{\"fromSw\":\"\",\"id\":" + AgentID + ",\"toSw\":\"\",\"userid\":\"" + AgentID + "\"}";
            if (dt != null && dt.Rows.Count > 0)
            {
                res = "{\"toSw\":\"" + dt.Rows[0]["NewVersion"].ToString() + "\"}";
            }
            ResponseJSON(res);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void GetIsThereNewLayoutVersion(string AgentID, string FromVersion, string ProjectType = "1")
    {
        /*ProjectType = 1 = סוכנים*/
        /*ProjectType = 2 = מנהלים*/
        try
        {
            DataTable dt = DAL.DAL.GetServerLayoutVersion(AgentID, FromVersion, ProjectType);
            string res = "{\"fromSw\":\"\",\"id\":" + AgentID + ",\"toSw\":\"\",\"userid\":\"" + AgentID + "\"}";
            if (dt != null && dt.Rows.Count > 0)
            {
                res = "{\"toSw\":\"" + dt.Rows[0]["NewVersion"].ToString() + "\"}";
            }
            ResponseJSON(res);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool SendMail(string To, string MSG, string bFile, string FileName, string Pass)
    {
        if (Pass != "MTN")
            return false;

        return Tools.SendMail(To, MSG, bFile, FileName);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool Delete_PushServerSender_By_AgentID(string Password, string AgentID)
    {
        if (Password == "MobiP9977")
            return DAL.DAL.Delete_PushServerSender_By_AgentID(AgentID);
        else
        {
            Tools.HandleError(new Exception("****** Delete_AndroidAssignedAgents_By_AgentID ****** with password: " + Password + "; From IP: " + System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName()).AddressList.GetValue(0).ToString()), LogDir);
            return false;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool Delete_AndroidAssignedAgents_By_AgentID(string Password, string AgentID)
    {
        if (Password == "MobiP9977")
            return DAL.DAL.Delete_AndroidAssignedAgents_By_AgentID(AgentID);
        else
        {
            Tools.HandleError(new Exception("****** Delete_AndroidAssignedAgents_By_AgentID ****** with password: " + Password + "; From IP: " + System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName()).AddressList.GetValue(0).ToString()), LogDir);
            return false;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool AddToDicManagersConnectedPushServer(string ManagerID, out bool IsAlreadyFillFromPushServer)
    {
        IsAlreadyFillFromPushServer = isAlreadyFillFromPushServer;
        try
        {
            string OldManger = "";
            if (dicManagersConnectedToPushServer.TryGetValue(ManagerID.Split(';')[0], out OldManger))
            {
                if (OldManger != String.Empty)
                {//alersy exsits
                    return false;
                }
            }

            dicManagersConnectedToPushServer.Add(ManagerID.Split(';')[0], DateTime.Now.ToLongDateString() + " " + DateTime.Now.ToLongTimeString());

            return true;
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return false;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool DeleteFromDicManagersConnectedPushServer(string ManagerID, out bool IsAlreadyFillFromPushServer)
    {
        IsAlreadyFillFromPushServer = isAlreadyFillFromPushServer;
        try
        {
            string OldManger = "";
            if (dicManagersConnectedToPushServer.TryGetValue(ManagerID, out OldManger))
            {
                if (OldManger != String.Empty)
                {//alersy exsits
                    dicManagersConnectedToPushServer.Remove(ManagerID);
                    return true;
                }
            }

            return true;
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return false;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool FillAllFromPushServer(string ManagersList)
    {
        try
        {
            string[] arr = ManagersList.Split(';');
            if (arr != null)
            {
                dicManagersConnectedToPushServer.Clear();
                for (int i = 0; i < arr.Length; i++)
                {
                    string val = "";
                    if (arr[i] != String.Empty && !dicManagersConnectedToPushServer.TryGetValue(arr[i], out val))
                        dicManagersConnectedToPushServer.Add(arr[i], DateTime.Now.ToLongDateString() + " " + DateTime.Now.ToLongTimeString());
                }
            }
            isAlreadyFillFromPushServer = true;
            return true;
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return false;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool ClearDicManagersConnectedPushServer()
    {
        try
        {
            dicManagersConnectedToPushServer.Clear();

            return true;
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return false;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void GetAllManagersConnectedPushServer()
    {
        try
        {
            Dictionary<string, string>.KeyCollection arr = dicManagersConnectedToPushServer.Keys;
            string[] arrAllConnectedWS = new string[arr.Count];
            arr.CopyTo(arrAllConnectedWS, 0);

            DataTable dt = new DataTable("dicManagersConnectedToPushServer");
            dt.Columns.Add("ManagerID");
            for (int i = 0; i < arrAllConnectedWS.Length; i++)
            {
                DataRow dr = dt.NewRow();
                dr["ManagerID"] = arrAllConnectedWS[i].Split(';')[0];
                dt.Rows.Add(dr);
            }

            if (dt != null)
            {
                ResponseJSON(GetJson(dt));
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    #region DNB
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void DNBGetZipFile(string FileName)
    {
        try
        {
            //lock (obj)
            {
                string AgentID = Context.Request.QueryString["AgentID"] == null ? "0" : Context.Request.QueryString["AgentID"].ToString();
                string LogID = "0";
                timer.Reset();
                timer.Start();

                DataTable dtt = DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                if (dtt != null && dtt.Rows.Count > 0)
                    LogID = dtt.Rows[0][0].ToString();
                FileName = FileName.Replace("/", "\\");

                byte[] arrBytes = new Byte[0];
                if (File.Exists(ConfigurationManager.AppSettings["DNBFiles"].ToString() + FileName))
                {
                    if (FileName.ToLower().IndexOf(".zip") > -1)
                    {
                        //Context.Response.Buffer = false;
                        //Context.Response.TransmitFile(ConfigurationManager.AppSettings["SrcFiles"].ToString() + FileName);
                        ResponsBytes(File.ReadAllBytes(ConfigurationManager.AppSettings["DNBFiles"].ToString() + FileName), "zip");

                        timer.Stop();

                        DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                    }
                }
                else
                {
                    throw new Exception("Not Exist");
                }
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string DNBUploadStrFile(string FileName, string strFile)
    {
        try
        {
            string AgentID = FileName.Split('_')[1];
            byte[] bFile = Convert.FromBase64String(strFile);
            return DNBUploadFile(FileName, bFile, AgentID);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "SERVER FAIL";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string DNBUploadFile(string FileName, byte[] bFile, string AgentID)
    {
        try
        {
            string Dir = ConfigurationManager.AppSettings["UploadFiles"].ToString();
            if (!(Directory.Exists(Dir)))
            {
                Directory.CreateDirectory(Dir);
            }
            File.WriteAllBytes(Dir + FileName, bFile);

            string DirArchive = ConfigurationManager.AppSettings["ArchiveFiles"].ToString();
            DirArchive += @"\" + AgentID + @"\";

            if (!(Directory.Exists(DirArchive)))
            {
                Directory.CreateDirectory(DirArchive);
            }

            File.WriteAllBytes(DirArchive + FileName, bFile);
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return "SERVER FAIL";
        }
        return "OK";
    }
    #endregion

    #region dynamic db
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void RunQuery(string Query, string pass)
    {
        string type = "1";//strauss
        RunQueryTodb(Query, pass, type);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void RunQueryTodb(string Query, string pass, string type)
    {
        if (pass != "mtns")
        {
            return;
        }

        try
        {
            //replace delete strings
            Query = Query.ToLower().Replace("truncate ", "").Replace("drop ", "").Replace("create ", "").Replace("alter ", "");//Replace("delete ", "").

            Query = Query.Replace("strauss.dbo.", "");

            switch (type)
            {
                case "1"://strauss                    
                    Query = Query.Replace(" from ", " from " + StraussOnDB);
                    //Query = Query.Replace("update ", "update " + StraussOnDB);
                    Query = Query.Replace("into ", "into " + StraussOnDB);
                    Query = Query.Replace("join ", "join " + StraussOnDB);
                    Query = Query.Replace("dbname.", StraussOnDB);
                    break;
                case "2"://mobi plus web
                    Query = Query.Replace(" from ", " from " + MobiPlusWebOnDB);
                    //Query = Query.Replace("update ", "update " + MobiPlusWebOnDB);
                    Query = Query.Replace("into ", "into " + MobiPlusWebOnDB);
                    Query = Query.Replace("join ", "join " + MobiPlusWebOnDB);
                    Query = Query.Replace("dbname.", MobiPlusWebOnDB);

                    break;
            }

            Query = Query.Replace("n'", "N'");

            StringBuilder sb = new StringBuilder();
            DataTable dt = DAL.ClientDAL.RunQuery(Query);
            if (dt != null)
            {
                sb.Append("[");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sb.Append("{");
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        sb.Append("\"" + dt.Columns[j].ColumnName + "\":\"" + HttpContext.Current.Server.UrlEncode(dt.Rows[i][dt.Columns[j].ColumnName].ToString().Replace("\"", "''").Replace("+", "%2B")) + "\"");
                        if (j != dt.Columns.Count - 1)
                        {
                            sb.Append(",");
                        }

                    }
                    sb.Append("}");
                    if (i != dt.Rows.Count - 1)
                    {
                        sb.Append(",");
                    }
                }
                sb.Append("]");
            }

            ResponseJSON(sb.ToString());
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void RunSP(string spName, string spParameters, string pass)
    {
        if (pass != "mtns")
        {
            return;
        }
        try
        {
            //spParameters exmpale = "UserID:1;WidgetID:1;";
            StringBuilder sb = new StringBuilder();
            DataTable dt = DAL.ClientDAL.RunSP(spName, spParameters);
            if (dt != null)
            {
                sb.Append("[");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sb.Append("{");
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        sb.Append("\"" + dt.Columns[j].ColumnName + "\":\"" + HttpContext.Current.Server.UrlEncode(dt.Rows[i][dt.Columns[j].ColumnName].ToString()) + "\"");
                        if (j != dt.Columns.Count - 1)
                        {
                            sb.Append(",");
                        }
                    }
                    sb.Append("}");
                    if (i != dt.Rows.Count - 1)
                    {
                        sb.Append(",");
                    }
                }
                sb.Append("]");
            }

            ResponseJSON(sb.ToString());
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }
    }
    #endregion



    #region Android Media
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string CheckMediaDirectory(string strDirsJson)
    {
        StringBuilder JsonRet = new StringBuilder();
        try
        {
            strDirsJson = strDirsJson.Replace(@"\", @"\\");
            if (strDirsJson == "]")
                strDirsJson = "[]";
            List<FilesNDirs> ArrList = JsonConvert.DeserializeObject<List<FilesNDirs>>(strDirsJson);

            string Dir = ConfigurationManager.AppSettings["MobiPlusMediaFiles"].ToString();
            if (!(Directory.Exists(Dir)))
            {
                Directory.CreateDirectory(Dir);
            }

            DirectoryInfo di = new DirectoryInfo(Dir);
            DirectoryInfo[] dirArr = null;
            FileInfo[] filesList = null;
            try
            {
                filesList = di.GetFiles("*", SearchOption.AllDirectories);
                dirArr = di.GetDirectories("*", SearchOption.AllDirectories);
            }
            catch (UnauthorizedAccessException e)
            {
                //Console.WriteLine("There was an error with UnauthorizedAccessException");
                Tools.HandleError(e, LogDir);
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
            }
            JsonRet.Append("[");
            for (int i = 0; i < dirArr.Length; i++)
            {
                //is dir
                if (!(IsFileOrDirExists(ref ArrList, dirArr[i].Name, true, dirArr[i].FullName.Replace(Dir, ""), dirArr[i].LastWriteTime)))
                    JsonRet.Append("{\"FileName\":\"" + dirArr[i].Name + "\",\"FilePath\":\"" + dirArr[i].FullName.Replace(Dir, "") + "\",\"IsDirectory\":\"True\",\"LastModified\":\"" + filesList[i].LastWriteTime.ToString("dd/MM/yyyy HH:mm:ss.ffff") + "\",\"IsToDelete\":\"False\"},");
            }

            for (int i = 0; i < filesList.Length; i++)
            {
                //is file
                if (!(IsFileOrDirExists(ref ArrList, filesList[i].Name, false, filesList[i].FullName.Replace(Dir, ""), filesList[i].LastWriteTime)))
                    JsonRet.Append("{\"FileName\":\"" + filesList[i].Name + "\",\"FilePath\":\"" + filesList[i].FullName.Replace(Dir, "") + "\",\"IsDirectory\":\"False\",\"LastModified\":\"" + filesList[i].LastWriteTime.ToString("dd/MM/yyyy HH:mm:ss.ffff") + "\",\"IsToDelete\":\"False\"},");
            }
            for (int i = 0; i < ArrList.Count; i++)
            {
                //is to delete?
                if ((IsFileOrDirDelete(ref filesList, ArrList[i].FileName, Convert.ToBoolean(ArrList[i].IsDirectory), ArrList[i].FilePath.Replace(Dir, ""), Dir)))
                    JsonRet.Append("{\"FileName\":\"" + ArrList[i].FileName + "\",\"FilePath\":\"" + ArrList[i].FilePath.Replace(Dir, "") + "\",\"IsDirectory\":\"" + ArrList[i].IsDirectory.ToString() + "\",\"LastModified\":\"NULL\",\"IsToDelete\":\"True\"},");
            }
            for (int i = 0; i < ArrList.Count; i++)
            {
                //is to delete?
                if (ArrList[i].IsDirectory == "True" && !Directory.Exists(Dir + "\\" + ArrList[i].FilePath))
                {
                    JsonRet.Append("{\"FileName\":\"" + ArrList[i].FileName + "\",\"FilePath\":\"" + ArrList[i].FilePath.Replace(Dir, "") + "\",\"IsDirectory\":\"True\",\"LastModified\":\"NULL\",\"IsToDelete\":\"True\"},");
                }
            }
            JsonRet.Append("]");

            JsonRet = JsonRet.Replace(@"\", @"\\");
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }

        //Tools.HandleError(new Exception(JsonRet.ToString()), LogDir);

        return JsonRet.ToString();
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public byte[] DownloadMediaFile(string FileName)
    {
        byte[] bRetFile = null;
        string Dir = ConfigurationManager.AppSettings["MobiPlusMediaFiles"].ToString();
        try
        {
            //lock (obj)
            {
                string AgentID = Context.Request.QueryString["AgentID"] == null ? "0" : Context.Request.QueryString["AgentID"].ToString();
                string LogID = "0";
                timer.Reset();
                timer.Start();

                DataTable dtt = DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                if (dtt != null && dtt.Rows.Count > 0)
                    LogID = dtt.Rows[0][0].ToString();
                FileName = FileName.Replace("/", "\\");

                byte[] arrBytes = new Byte[0];
                FileName = FileName.Replace(Dir, "");
                if (File.Exists(Dir + FileName))
                {
                    //ResponsBytes(File.ReadAllBytes(Dir + FileName), FileName.Split('.')[FileName.Split('.').Length - 1]);
                    bRetFile = File.ReadAllBytes(Dir + FileName);

                    timer.Stop();

                    DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                }
                else
                {
                    throw new Exception("Not Exist");
                }
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
        return bRetFile;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void DownloadMediaFileResponseBytes(string FileName)
    {
        byte[] bRetFile = null;
        string Dir = ConfigurationManager.AppSettings["MobiPlusMediaFiles"].ToString();
        try
        {
            //lock (obj)
            {
                string AgentID = Context.Request.QueryString["AgentID"] == null ? "0" : Context.Request.QueryString["AgentID"].ToString();
                string LogID = "0";
                timer.Reset();
                timer.Start();

                DataTable dtt = DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                if (dtt != null && dtt.Rows.Count > 0)
                    LogID = dtt.Rows[0][0].ToString();
                FileName = FileName.Replace("/", "\\");

                byte[] arrBytes = new Byte[0];
                FileName = FileName.Replace(Dir, "");
                if (File.Exists(Dir + FileName))
                {
                    //ResponsBytes(File.ReadAllBytes(Dir + FileName), FileName.Split('.')[FileName.Split('.').Length - 1]);
                    bRetFile = File.ReadAllBytes(Dir + FileName);

                    timer.Stop();

                    DAL.DAL.AddEntryToLog(AgentID, DateTime.Now, DateTime.Now, LogID);
                }
                else
                {
                    throw new Exception("Not Exist");
                }
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
        //return bRetFile;
        Context.Response.ContentType = "application/octet-stream";
        Context.Response.AddHeader("content-disposition", "attachment;filename=\"" + Path.GetFileName(Dir + FileName) + "\"");
        Context.Response.AddHeader("content-length", bRetFile.Length.ToString());
        Context.Response.TransmitFile(Dir + FileName);
        Context.Response.Flush();
    }
    #endregion

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public byte[] GetIMG(string FileName)
    {
        byte[] arrBytes = new Byte[0];
        try
        {
            FileName = FileName.Replace("/", "\\");

            if (File.Exists(FileName))
            {
                return FileToByteArray(FileName);
            }
            return arrBytes;
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public string GetManagerPushEmployeeData()
    {
        return GetJson(DAL.DAL.GetManagerPushEmployeeData());
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void UpdatePasswordManager(string RequestID, string RequestStatus, string ManagerComment)
    {
        ResponseJSON(DAL.DAL.UpdatePasswordManager(RequestID, RequestStatus, ManagerComment).ToString());
    }
    #endregion

    #region Private Metods
    private void ResponseJSON(string strjson)
    {
        try
        {
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-disposition", "attachment; filename=export.json");
            Context.Response.AddHeader("content-length", strjson.Length.ToString());
            Context.Response.Flush();
            Context.Response.Write((strjson));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }

    private void ResponseJSONHalf(string strjson)
    {
        try
        {
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-disposition", "attachment; filename=export.json");
            Context.Response.AddHeader("content-length", strjson.Length.ToString());
            Context.Response.Write(Context.Server.UrlEncode(strjson));
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    private void ResponsBytes(byte[] file, string Pre)
    {
        try
        {
            Context.Response.Clear();
            Context.Response.ContentType = "text/plain";
            Context.Response.AddHeader("content-disposition", "attachment;    filename=file." + Pre);
            Context.Response.BinaryWrite(file);
            //Context.Response.Flush();
            //Context.Response.End();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    private void ResponsBytesTest(byte[] file, string Pre)
    {
        try
        {
            Context.Response.Clear();
            Context.Response.ContentType = "text/plain";
            Context.Response.AddHeader("content-disposition", "attachment;    filename=file." + Pre);
            Context.Response.BinaryWrite(file);
            //Context.Response.Flush();
            //Context.Response.End();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    private void ResponsBytesApp(byte[] file, string Pre)
    {
        try
        {
            Context.Response.Clear();
            Context.Response.ContentType = "application/octet-stream";
            Context.Response.AddHeader("content-disposition", "attachment;    filename=file." + Pre);
            Context.Response.BinaryWrite(file);
            //Context.Response.Flush();
            //Context.Response.End();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
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
                    row.Add(col.ColumnName.Trim(), Server.UrlEncode(dr[col].ToString().Replace("'", "").Replace("\"", "''").Replace("\\", "/")));
                else
                    row.Add(col.ColumnName.Trim(), dr[col]);
            }
            rows.Add(row);
        }
        return serializer.Serialize(rows);
    }

    private bool IsFileOrDirDelete(ref FileInfo[] filesList, string FileName, bool isDirectory, string Path, string OrgDir)
    {
        Path = Path.Replace("/", "\\");
        if (Path.IndexOf("\\") > 0 || Path.IndexOf("\\") == -1)
            Path = "\\" + Path.ToLower(); ;
        if (filesList != null)
        {
            if (DicAllfilesList.Count == 0)
            {
                for (int i = 0; i < filesList.Length; i++)
                {
                    //D:\mtnout_android\Strauss\Media\
                    DicAllfilesList.Add("\\" + filesList[i].FullName.Replace(OrgDir, "").ToLower(), filesList[i]);
                }
            }

            if (!isDirectory)
            {
                FileInfo Current;
                if (DicAllfilesList.TryGetValue(Path.ToLower() + "\\" + FileName.ToLower(), out Current))
                {
                    if ("\\" + Current.FullName.Replace(OrgDir, "").ToLower() == Path.ToLower() + "\\" + FileName.ToLower())
                    {
                        return false;
                    }
                }
            }
            else
            {
                if (Directory.Exists(OrgDir + "\\" + Path))
                {
                    return false;
                }
            }
        }
        return true;
    }

    private bool IsFileOrDirExists(ref List<FilesNDirs> ArrList, string FileName, bool isDirectory, string Path, DateTime dt)
    {

        string orgPath = Path;
        if (ArrList != null)
        {
            //int tt = 0;
            //if (FileName.IndexOf("doc") > -1)
            //    tt = 7;

            if (DicAllArrList.Count == 0)
            {
                for (int i = 0; i < ArrList.Count; i++)
                {

                    FilesNDirs tmp = null;
                    if (!DicAllArrList.TryGetValue((ArrList[i].FilePath.ToLower() + "/" + ArrList[i].FileName.ToLower()).Replace("/", "\\"), out tmp))
                        DicAllArrList.Add((ArrList[i].FilePath.ToLower() + "/" + ArrList[i].FileName.ToLower()).Replace("/", "\\").ToLower(), ArrList[i]);
                    else if (!DicAllArrList.TryGetValue((ArrList[i].FilePath.ToLower()).Replace("/", "\\"), out tmp))
                        DicAllArrList.Add((ArrList[i].FilePath.ToLower()).Replace("/", "\\").ToLower(), ArrList[i]);
                }
            }
            IFormatProvider culture = new System.Globalization.CultureInfo("he-IL", true);

            FilesNDirs Current = new FilesNDirs();
            //if (DicAllArrList.TryGetValue(Path, out Current))
            //if (DicAllArrList.TryGetValue(isDirectory == true ? Path + "\\" + FileName : Path, out Current))            

            if (DicAllArrList.TryGetValue(Path.ToLower(), out Current))
            {
                string AndroPath = Current.FilePath.Replace("/", "\\").ToLower();
                if (Current.IsDirectory == "False")
                {
                    AndroPath += "\\" + Current.FileName.ToLower();
                    Path = "\\" + orgPath.ToLower();
                }
                //if (AndroPath == Path && (Convert.ToInt64(ArrList[i].LastModified) >= dt.ToUniversalTime().Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds || ArrList[i].IsDirectory == "True"))
                if (Current.IsDirectory == "True" && AndroPath == Path && (Convert.ToDateTime(Current.LastModified, culture) >= dt || Current.IsDirectory == "True"))
                {
                    return true;
                }
                else if ("\\" + AndroPath == Path && (Convert.ToDateTime(Current.LastModified, culture) >= dt || Current.IsDirectory == "True"))
                {
                    return true;
                }
            }
        }
        return false;
    }


    public byte[] FileToByteArray(string strdocPath)
    {
        FileStream objfilestream = new FileStream(strdocPath, FileMode.Open, FileAccess.Read);
        int len = (int)objfilestream.Length;
        byte[] documentcontents = new Byte[len];
        objfilestream.Read(documentcontents, 0, len);
        objfilestream.Close();

        return documentcontents;
    }

    private void CreateZip(string srcFileName, string resFileName)
    {
        //if (srcFileName.ToLower().IndexOf("_list") > -1)
        //{
        //    File.Copy(srcFileName, ConfigurationManager.AppSettings["TmpFiles"].ToString() + "str_list.db", true);
        //    srcFileName = ConfigurationManager.AppSettings["TmpFiles"].ToString() + "str_list.db";
        //}
        //else if (srcFileName.ToLower().IndexOf("_price") > -1)
        //{
        //    File.Copy(srcFileName, ConfigurationManager.AppSettings["TmpFiles"].ToString() + "STR_PRICE.db", true);
        //    srcFileName = ConfigurationManager.AppSettings["TmpFiles"].ToString() + "STR_PRICE.db";
        //}

        //using (ZipFile zip = new ZipFile())
        //{
        //    zip.AddFile(srcFileName, "");
        //    zip.Save(resFileName);
        //}
        File.Delete(resFileName);
        Resco.IO.Zip.ZipArchive z = new Resco.IO.Zip.ZipArchive(resFileName, Resco.IO.Zip.ZipArchiveMode.Create, FileShare.None);
        z.Add(srcFileName, "", true, null);
        z.Close();

    }


    #region Push Server
    [WebMethod(EnableSession = true)]
    public DataTable GetServerPushFiles()
    {
        DataTable dt;
        try
        {

            bool isToRefreshCache = false;
            if (cacheObj.Get("isToRefreshCache") != null)
                isToRefreshCache = (bool)cacheObj.Get("isToRefreshCache");
            if (!isToRefreshCache)
            {
                if (cacheObj.Get("AllMsgs") != null)
                {
                    dt = (DataTable)cacheObj.Get("AllMsgs");
                }
                else
                {
                    dt = DAL.DAL.GetServerPushFiles();
                    cacheObj.Add("AllMsgs", dt);
                }

            }
            else
            {
                dt = DAL.DAL.GetServerPushFiles();
                if (cacheObj.Get("AllMsgs") != null)
                    cacheObj.Update("AllMsgs", dt);
                else
                    cacheObj.Add("AllMsgs", dt);

                if (cacheObj.Get("isToRefreshCache") != null)
                    cacheObj.Update("isToRefreshCache", false);
                else
                    cacheObj.Add("isToRefreshCache", false);
                isToRefreshCache = false;
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
        return dt;
    }
    [WebMethod(EnableSession = true)]
    public void UpdateCache_ServerPushFiles()
    {
        try
        {
            if (cacheObj.Get("isToRefreshCache") != null)
                cacheObj.Update("isToRefreshCache", true);
            else
                cacheObj.Add("isToRefreshCache", true);

            isToRefreshCache = true;
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }

    }
    //isToRefreshCache
    [WebMethod(EnableSession = true)]
    public bool isToRefreshCacheFunc()
    {
        try
        {
            if (cacheObj.Get("isToRefreshCache") != null)
            {
                bool ret = isToRefreshCache;
                isToRefreshCache = false;
                return ret;//(bool)cacheObj.Get("isToRefreshCache");
            }
            else
                return false;


        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    [WebMethod(EnableSession = true)]
    public bool DeleteServerPushFile(string PushID)
    {
        bool res = true;
        try
        {
            isToRefreshCache = false;

            res = DAL.DAL.DeleteServerPushFile(PushID);

            DataTable dt = DAL.DAL.GetServerPushFiles();
            if (cacheObj.Get("AllMsgs") != null)
                cacheObj.Update("AllMsgs", dt);
            else
                cacheObj.Add("AllMsgs", dt);

        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
        return res;
    }
    [WebMethod(EnableSession = true)]
    public bool AddPushServerLog(string AgentID, string ManagerID, string Message)
    {
        return DAL.DAL.AddPushServerLog(AgentID, ManagerID, Message);
    }
    [WebMethod(EnableSession = true)]
    public bool AddPushServerData(string AgentID, string ManagerID, string Message)
    {
        return DAL.DAL.AddPushServerData(AgentID, ManagerID, Message);
    }
    [WebMethod(EnableSession = true)]
    public bool SetServerPushFilesAgain(string TimeToCheckInMinutes)
    {
        return DAL.DAL.SetServerPushFilesAgain(TimeToCheckInMinutes);
    }
    [WebMethod(EnableSession = true)]
    public void AddToPasswordManager(string RequestID, string pTime, string AgentId, string AgentName, string EmployeeId, string EmployeeName, string ActivityCode, string ActivityDescription, string Cust_Key, string CustName
           , string DocType, string DocName, string Comment, string ManagerEmployeeId, string ManagerName, string StatusChangeTime, string RequestStatus, string ManagerStatusTime, string ManagerComment, string ManagerDeviceType
           , string TransmissionState, string SubjectDescription, string IsTest, string DocNum)
    {
        DAL.DAL.AddToPasswordManager(RequestID, pTime, AgentId, AgentName, EmployeeId, EmployeeName, ActivityCode, ActivityDescription, Cust_Key, CustName
           , DocType, DocName, Comment, ManagerEmployeeId, ManagerName, StatusChangeTime, RequestStatus, ManagerStatusTime, ManagerComment, ManagerDeviceType, TransmissionState, SubjectDescription, IsTest, DocNum);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void Server_CheckAgentAndHWID(string AgentID, string HW_ID)
    {
        DataSet ds = DAL.DAL.Server_CheckAgentAndHWID(AgentID, HW_ID);
        string res = "";

        if (ds != null && ds.Tables.Count > 1 && isToCheckBlocked)
        {
            if (ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0]["HW_ID"].ToString() != "")//blocked hwid
            {
                res += "{\"isBlocked\":True,";
                if (ds.Tables[0].Rows[0]["isToDeleteTablet"].ToString() == "1")//to delete
                {
                    res += "\"isToDeleteTablet\":True,";
                }
                else
                {
                    res += "\"isToDeleteTablet\":False,";
                }
            }
            else
            {
                res += "{\"isBlocked\":False,";
                if (ds.Tables[0].Rows[0]["isToDeleteTablet"].ToString() == "1")//to delete
                {
                    res += "\"isToDeleteTablet\":True,";
                }
                else
                {
                    res += "\"isToDeleteTablet\":False,";
                }
            }

            if (ds.Tables[1].Rows.Count > 0)//Assigne Other Agent
            {
                res += "\"isAssigneOtherAgent\":True,\"OlddbHWID\":\"" + ds.Tables[1].Rows[0]["HW_ID"].ToString() + "\"}";
            }
            else
            {
                res += "\"isAssigneOtherAgent\":False,\"OlddbHWID\":\"\"}";
            }
        }
        else
        {
            if (ds != null && ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
                res = "{\"isBlocked\":False,\"isToDeleteTablet\":False,\"isAssigneOtherAgent\":False,\"OlddbHWID\":\"" + ds.Tables[1].Rows[0]["HW_ID"].ToString() + "\"}";
            else
                res = "{\"isBlocked\":False,\"isToDeleteTablet\":False,\"isAssigneOtherAgent\":False,\"OlddbHWID\":\"\"}";
        }


        ResponseJSON(res);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool Server_UpdateAgentToOnlineDB(string AgentID, string HW_ID)
    {
        return DAL.DAL.Server_UpdateAgentToOnlineDB(AgentID, HW_ID);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool AddPushServerDataAndBlockedDevice(string AgentID, string ManagerID, string Message, string HWID)
    {
        DAL.DAL.Server_InsertBlockedDevice(AgentID, HWID, "0");
        return DAL.DAL.AddPushServerData(AgentID, ManagerID, Message);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void MPush_GetManagersList()
    {
        ResponseJSON(GetJson(DAL.DAL.MPush_GetManagersList()));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void MPush_GetManagerSyncRequest(string ManagerEmployeeId, string StatusChangeTime)
    {
        ResponseJSON(GetJson(DAL.DAL.MPush_GetManagerSyncRequest(ManagerEmployeeId, StatusChangeTime)));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public DataTable GetManagersForTabletUI(string PermissionActivityCode)
    {
        return DAL.DAL.GetManagersForTabletUI(PermissionActivityCode);

        //ResponseJSON(GetJson(dt));
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void GetManagerAuthorizationGroupActivities(string EmployeeId)
    {
        ResponseJSON(GetJson(DAL.DAL.GetManagerAuthorizationGroupActivities(EmployeeId)));
    }
    #endregion
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public bool SendSMSToClient(string AgentID, string Cust1, string Cust2, string Lat, string Lon)
    {
        try
        {
            DataTable dt = DAL.DAL.RunQuery("Select c.CustName From [MobiHash-Android].dbo.Customers c WHERE c.Cust_Key = '" + Cust2 + "'");

            DataTable dtDB = DAL.DAL.RunQuery("exec AddLocationToSMS " + AgentID + "," + Cust1 + "," + Cust2 + ",'" + Lat + "', '" + Lon + "'");

            if (dtDB != null && dtDB.Rows.Count > 0)
            {
                if (MapsServerAddress == "" || MapsServerAddress == null)
                    MapsServerAddress = ConfigurationManager.AppSettings["MapsServerAddress"].ToString();

                if (MapsSendDemoSMSTo == "" || MapsSendDemoSMSTo == null)
                    MapsSendDemoSMSTo = ConfigurationManager.AppSettings["MapsSendDemoSMSTo"].ToString();

                if (SMSMaps == "" || SMSMaps == null)
                    SMSMaps = ConfigurationManager.AppSettings["SMSMaps"].ToString();

                if (SMSMaps2 == "" || SMSMaps2 == null)
                    SMSMaps2 = ConfigurationManager.AppSettings["SMSMaps2"].ToString();


                string url = " https://rest.nexmo.com/sms/json?api_key=606c83e0&api_secret=ca37755e34540ea6&type=unicode&from=HoglaKimberly&to=" + MapsSendDemoSMSTo + "&text=" + (SMSMaps.Replace("[X]", dt.Rows[0]["CustName"].ToString()) + " http://" + MapsServerAddress + "/MobiPlusGeneral/Pages/Main/ETA.aspx?AgentID=" + dtDB.Rows[0][0].ToString() + SMSMaps2 + ".");
                //972523839377 avi
                //972546644852 gil

                WebRequest request = WebRequest.Create((url).Replace("+", "%2b").Trim());

                request.Credentials = CredentialCache.DefaultCredentials;
                // Get the response.
                WebResponse response = request.GetResponse();
                // Get the stream containing content returned by the server.
                Stream dataStream = response.GetResponseStream();
                // Open the stream using a StreamReader for easy access.
                StreamReader reader = new StreamReader(dataStream);
                // Read the content.
                string responseFromServer = reader.ReadToEnd();
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            return false;
        }

        return true;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void SendSMSToClientTel(string AgentID, string CustID, string Lat, string Lon, string Tel)
    {
        try
        {
            DataTable dt = DAL.DAL.RunQuery("Select c.CustName From " + StraussOnDB + "v_Diplomat_Tasks c WHERE c.CustID = '" + CustID + "'");

            DataTable dtDB = DAL.DAL.RunQuery("exec AddLocationToSMS " + AgentID + "," + CustID + "," + CustID + ",'" + Lat + "', '" + Lon + "'");
            string Name = "gg";
            if (dtDB != null && dtDB.Rows.Count > 0)
            {
                if (dt != null && dt.Rows.Count > 0)
                    Name = dt.Rows[0]["CustName"].ToString();
                if (MapsServerAddress == "" || MapsServerAddress == null)
                    MapsServerAddress = ConfigurationManager.AppSettings["MapsServerAddress"].ToString();

                if (MapsSendDemoSMSTo == "" || MapsSendDemoSMSTo == null)
                    MapsSendDemoSMSTo = ConfigurationManager.AppSettings["MapsSendDemoSMSTo"].ToString();

                MapsSendDemoSMSTo = Tel;

                if (SMSMaps == "" || SMSMaps == null)
                    SMSMaps = ConfigurationManager.AppSettings["SMSMaps"].ToString();

                if (SMSMaps2 == "" || SMSMaps2 == null)
                    SMSMaps2 = ConfigurationManager.AppSettings["SMSMaps2"].ToString();


                string url = " https://rest.nexmo.com/sms/json?api_key=606c83e0&api_secret=ca37755e34540ea6&type=unicode&from=HoglaKimberly&to=" + MapsSendDemoSMSTo + "&text=" + (SMSMaps.Replace("[X]", Name) + " http://" + MapsServerAddress + "/MobiPlusGeneral/Pages/Main/ETA.aspx?AgentID=" + dtDB.Rows[0][0].ToString() + SMSMaps2 + ".");
                //972523839377 avi
                //972546644852 gil

                WebRequest request = WebRequest.Create((url).Replace("+", "%2b").Trim());

                request.Credentials = CredentialCache.DefaultCredentials;
                // Get the response.
                WebResponse response = request.GetResponse();
                // Get the stream containing content returned by the server.
                Stream dataStream = response.GetResponseStream();
                // Open the stream using a StreamReader for easy access.
                StreamReader reader = new StreamReader(dataStream);
                // Read the content.
                string responseFromServer = reader.ReadToEnd();
            }
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            ResponseToUpload(500, "500 InternalServerError");
        }

        ResponseToUpload(200, "200 OK");
    }
    private void ResponseToUpload(int Status, string Msg)
    {
        try
        {
            //Response.ClearHeaders();
            //Response.ClearContent();
            if (Status != 200)
                HttpContext.Current.Response.Status = Msg;
            HttpContext.Current.Response.StatusCode = Status;
            HttpContext.Current.Response.StatusDescription = Msg;
            //Response.Flush();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = true)]
    public void MPLayout_SetDriverGPSLocation(string AgentID, string Lat, string Lon)
    {       
        ResponseJSON(DAL.DAL.MPLayout_SetDriverGPSLocation(AgentID, Lat, Lon));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(UseHttpGet = false)]
    public void MPLayout_SetDriverGPSLocation_New(string jsonText)
    {

        //ResponseJSON(DAL.DAL.MPLayout_SetDriverGPSLocation(AgentID, Lat, Lon));
    }
    #endregion




    #region Cls
    public class FilesNDirs
    {
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public string IsDirectory { get; set; }
        public string LastModified { get; set; }
    }
    #endregion


    #region GetFolderFiles
    System.Collections.ArrayList fileList = new System.Collections.ArrayList();
    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public void GetFolderFiles()
    {
        System.Collections.ArrayList root = new System.Collections.ArrayList();
        foreach (var item in Directory.GetFiles(ConfigurationManager.AppSettings["Path2Files"]))
        {
            root.Add(new { Path = Path.GetFileName(item), DateModifies = new FileInfo(item).LastWriteTime.ToString("yyyymmddhhmm") });
        }

        var getFileName = DirSearch(ConfigurationManager.AppSettings["Path2Files"]);
        foreach (var item in root)
        {
            getFileName.Add(item);
        }

        var strResponse = Newtonsoft.Json.JsonConvert.SerializeObject(getFileName);
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Flush();

        Context.Response.Write(strResponse);
    }

    public System.Collections.ArrayList DirSearch(string sDir)
    {
        var path = ConfigurationManager.AppSettings["Path2Files"].ToString();
        try
        {
            foreach (string d in Directory.GetDirectories(sDir))
            {
                foreach (string f in Directory.GetFiles(d, "*.*"))
                {
                    string extension = Path.GetExtension(f);
                    if (extension != null)
                    {
                        fileList.Add(new { Path = f.Replace(path, ""), DateModifies = new FileInfo(f.ToString()).LastWriteTime.ToString("yyyymmddhhmm") });
                    }
                }
                DirSearch(d);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        return fileList;
    }

    #endregion
}
