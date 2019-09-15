<%@ WebHandler Class="readinessPictures" Language="C#" %>

using System;
using System.Web;
using PQ.BE.Common;
using PQ.BL.Persons;
using System.IO;
using System.Drawing;

public class readinessPictures : IHttpHandler
{
    byte[] _image;
    int readinessID = 3;
    #region IHttpHandler Members

    public bool IsReusable
    {
        get { return true; }
    }

    public void ProcessRequest(HttpContext context)
    {
        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;
        if (Request.QueryString[appConfig.Keys.R_READINESSLEVELID] != null && Request.QueryString[appConfig.Keys.R_READINESSLEVELID] != "null")
            readinessID = Int32.Parse(Request.QueryString[appConfig.Keys.R_READINESSLEVELID]);
        try
        {
            Response.ContentType = "image/jpeg";
            switch (readinessID)
            {
                case 1:
                    _image = Utils.imageToByteArray(Image.FromFile(HttpContext.Current.Server.MapPath("~/Resources/images/defaultUserGreen.gif")));
                    break;
                case 2:
                    _image = Utils.imageToByteArray(Image.FromFile(HttpContext.Current.Server.MapPath("~/Resources/images/defaultUserYellow.gif")));
                    break;
                case 3:
                    _image = Utils.imageToByteArray(Image.FromFile(HttpContext.Current.Server.MapPath("~/Resources/images/defaultUserRed.gif")));
                    break;
            }
            Response.OutputStream.Write(_image, 0, _image.Length);
        }
        catch (Exception ex) { PQ.BL.Common.ErrorLogBL.WriteToErrorTable(ex); }
        Response.End();
    }

    #endregion





}
