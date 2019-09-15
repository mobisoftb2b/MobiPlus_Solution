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
using System.Diagnostics;

using System.Drawing;



public partial class UploadFile : System.Web.UI.Page
{
    string Msg = "";
    private string LogDir = "c:\\logger\\";//ConfigurationManager.AppSettings["LogDirectory"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //UploadFileM();
        }
    }
    protected void btn_click(object sender, EventArgs e)
    {
        UploadFileMN();
        dMsg.InnerHtml = "<script>alert('Resopnse From Server: " + Msg + "');window.location.href = window.location.href;</script>";
    }
    private void UploadFileM()
    {
        if (Request.Files.Count > 0)
        {
            
            ResponseToUpload(200,"Ok");
            return;
        }
        ResponseToUpload(404, "404 Not Found");            
        //ResponseToUpload(500, "500 InternalServerError");      
    }
    private void UploadFileMN()
    {
        if (upMain.FileName!="")
        {

            ResponseToUpload(200, "Ok");
            return;
        }
        ResponseToUpload(404, "404 Not Found");
        
        //ResponseToUpload(500, "500 InternalServerError");      
    }
    private void ResponseToUpload(int Status,string msg)
    {
        Msg = msg;
        try
        {
           //Response.ClearHeaders();
            //Response.ClearContent();
            if (Status!=200)
                Response.Status = Msg;
            Response.StatusCode = Status;
            Response.StatusDescription = Msg;
            Response.Flush();
        }
        catch (Exception ex)
        {
            
            throw ex;
        }
    }
}