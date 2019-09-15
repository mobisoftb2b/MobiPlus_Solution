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
        if (Request["strData"] != null)
        {
            Tools.HandleError(new Exception("strData Len: " + Request["strData"].Length.ToString()), LogDir);
            ResponseToUpload(200, "OK");
            return;
            
            
        }
        Tools.HandleError(new Exception("strData Len: 0; 404"), LogDir);
        ResponseToUpload(404, "Data  - 404 Not Found");    
     return;
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