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

public partial class UploadFile : System.Web.UI.Page
{
    private string LogDir = ConfigurationManager.AppSettings["LogDirectory"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            UploadFileM();
        }
    }
    private void UploadFileM()
    {
        if (Request.Files.Count > 0)
        {
            string FileName = Request.Files[0].FileName;

            HttpPostedFile file = Request.Files[0];
            byte[] bFile = new byte[file.ContentLength];
            file.InputStream.Read(bFile, 0, file.ContentLength);

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
                ResponseToUpload(500, "500 InternalServerError");                
            }
            ResponseToUpload(200,"Ok");
            return;
        }
        ResponseToUpload(404, "404 Not Found");            
        //ResponseToUpload(500, "500 InternalServerError");      
    }

    private void ResponseToUpload(int Status,string Msg)
    {
        try
        {
           //Response.ClearHeaders();
            //Response.ClearContent();
            if (Status!=200)
                Response.Status = Msg;
            Response.StatusCode = Status;
            Response.StatusDescription = Msg;
            //Response.Flush();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
}