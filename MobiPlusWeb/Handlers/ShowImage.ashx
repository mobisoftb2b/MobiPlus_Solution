<%@ WebHandler Language="C#" Class="ShowImage" %>

using System;
using System.Configuration;
using System.Web;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Web.SessionState;

public class ShowImage : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            string imgID = "";
            if (context.Request.QueryString["id"] != null)
            {
                imgID = context.Request.QueryString["id"].ToString();
                context.Response.ContentType = "image/png";
                Stream strm = ShowImageR(context, imgID);
                byte[] buffer = new byte[4096];
                int byteSeq = strm.Read(buffer, 0, 4096);

                while (byteSeq > 0)
                {
                    context.Response.OutputStream.Write(buffer, 0, byteSeq);
                    byteSeq = strm.Read(buffer, 0, 4096);
                }
                //context.Response.BinaryWrite(buffer);
            }
            else if (context.Request.QueryString["UploadImg"] != null)
            {
                context.Response.ContentType = "image/png";
                byte[] buffer = (byte[])context.Session["imgFromImages"];
                context.Response.OutputStream.Write(buffer, 0, buffer.Length);
                //context.Session["imgFromImages"] = null;            
            }
            else if (context.Request.QueryString["ImageName"] != null)
            {
                string ImageName = context.Request.QueryString["ImageName"].ToString();
                context.Response.ContentType = "image/png";
                Stream strm = ShowImageByName(context, ImageName);
                byte[] buffer = new byte[4096];
                int byteSeq = strm.Read(buffer, 0, 4096);

                while (byteSeq > 0)
                {
                    context.Response.OutputStream.Write(buffer, 0, byteSeq);
                    byteSeq = strm.Read(buffer, 0, 4096);
                }
                //context.Response.BinaryWrite(buffer);
            }
        }
        catch (Exception ex)
        {
        }
    }

    public Stream ShowImageR(HttpContext context,string imgID)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataTable dt = wr.Layout_GetImageByID(imgID, ConStrings.DicAllConStrings[context.Session["SessionProjectName"].ToString()].ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            try
            {
                return new MemoryStream((byte[])dt.Rows[0]["ImgBlob"]);
            }
            catch
            {
                return null;
            }

        }
        return null;
    }
    public Stream ShowImageByName(HttpContext context, string ImageName)
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataTable dt = wr.Layout_GetImageByName(ConStrings.DicAllConStrings[context.Session["SessionProjectName"].ToString()].ToString(), ImageName);
        if (dt != null && dt.Rows.Count > 0)
        {
            try
            {
                return new MemoryStream((byte[])dt.Rows[0]["ImgBlob"]);
            }
            catch
            {
                return null;
            }

        }
        return null;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}