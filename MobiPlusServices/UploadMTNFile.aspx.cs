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
            if (Request["MTNPass"] != null && Request["MTNPass"].ToString()=="MTN102015")
                UploadFileM();
            else
                ResponseToUpload(403, "403 Forbidden");    
        }
    }
    private void UploadFileM()
    {
        if (Request.Files.Count > 0)
        {            
            try
            {
                string Dir = ConfigurationManager.AppSettings["UploadAgentFiles"].ToString();
                string FileName = Dir + Request.Files[0].FileName;

                HttpPostedFile file = Request.Files[0];
                byte[] bFile = new byte[file.ContentLength];
                file.InputStream.Read(bFile, 0, file.ContentLength);

               
                if (!(Directory.Exists(Dir)))
                {
                    Directory.CreateDirectory(Dir);
                }

                
                File.WriteAllBytes(FileName, bFile);                
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
    }

    private void ResponseToUpload(int Status,string Msg)
    {
        try
        {           
            if (Status!=200)
                Response.Status = Msg;
            Response.StatusCode = Status;
            Response.StatusDescription = Msg;         
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
            throw ex;
        }
    }
}