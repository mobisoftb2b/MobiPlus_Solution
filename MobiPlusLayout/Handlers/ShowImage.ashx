﻿<%@ WebHandler Language="C#" Class="ShowImage" %>

using System;
using System.Configuration;
using System.Web;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Web.SessionState;

public class ShowImage : IHttpHandler, IRequiresSessionState
{
    public string SessionVersionID
    {
        get
        {
            if (HttpContext.Current.Session["SessionVersionID"] == null)
                HttpContext.Current.Session["SessionVersionID"] = "0";
            return HttpContext.Current.Session["SessionVersionID"].ToString();
        }
        set
        {
            HttpContext.Current.Session["SessionVersionID"] = value;
        }
    }
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
            else if (context.Request.QueryString["ShowDoc"] != null)
            {
                Stream strm = ShowDoc(context, context.Request["FileSrc"].ToString());
                byte[] buffer = new byte[4096];
                int byteSeq = strm.Read(buffer, 0, 4096);

                while (byteSeq > 0)
                {
                    context.Response.OutputStream.Write(buffer, 0, byteSeq);
                    byteSeq = strm.Read(buffer, 0, 4096);
                }
            }

        }
        catch (Exception ex)
        { }

    }

    public Stream ShowImageR(HttpContext context, string imgID)
    {
        try
        {
            MPLayoutService wr = new MPLayoutService();
            DataTable dt = wr.MPLayout_GetImageByID(imgID, SessionVersionID, ConStrings.DicAllConStrings[context.Session["SessionProjectName"].ToString()].ToString());
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
        catch
        {
            return null;
        }
    }
    public Stream ShowImageByName(HttpContext context, string ImageName)
    {
        MPLayoutService wr = new MPLayoutService();
        DataTable dt = wr.MPLayout_GetImageByName(ImageName, SessionVersionID, ConStrings.DicAllConStrings[context.Session["SessionProjectName"].ToString()].ToString());
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
    public Stream ShowDoc(HttpContext context, string FileSrc)
    {
        try
        {
            FileSrc = FileSrc.Replace("~", "\\");
            string Pre = FileSrc.Substring(FileSrc.ToString().IndexOf(".") + 1, FileSrc.Length - (FileSrc.ToString().IndexOf(".") + 1));

            byte[] file = File.ReadAllBytes(FileSrc);
            return new MemoryStream(file);
        }
        catch
        {
            return null;
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}