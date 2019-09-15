<%@ WebHandler Class="PhotoUpload" Language="C#" %>
using System;
using System.Web;
using PQ.BL.Persons;
using PQ.BE.Persons;
using PQ.BE.Common;

public class PhotoUpload : IHttpHandler
{
    #region IHttpHandler Members
    public bool IsReusable
    {
        get { return false; }
    }
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        context.Response.Expires = -1;
        try
        {
            HttpPostedFile postedFile = context.Request.Files[0];
            Byte[] imgByte = null;


            if (postedFile.FileName != null)
            {
                imgByte = new Byte[postedFile.ContentLength];
                postedFile.InputStream.Read(imgByte, 0, postedFile.ContentLength);
                string exten = System.IO.Path.GetExtension(postedFile.FileName);
                if (CheckExtention(exten))
                {
                    using (PersonBL pbl = new PersonBL())
                    {
                        PersonInfo prs = new PersonInfo();
                        prs.Person_ID = int.Parse(context.Request[appConfig.Keys.R_EMPID].ToString());
                        prs.PersonPhoto = imgByte;
                        pbl.Person_SavePicture(prs);
                    }
                }
                else
                {
                    throw new Exception("This is an unallowed type of a files");

                }
            }
            context.Response.StatusCode = 200;
        }
        catch (Exception ex)
        {
            PQ.BL.Common.ErrorLogBL.WriteToErrorTable(ex);
            SendError(ex.Message);
        }
    }
    #endregion

    /// <summary>
    /// Creates an error response using a common response construct
    /// </summary>
    private void SendError(string s)
    {
        HttpContext.Current.Response.Write(new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { Error = s }));
    }


    private bool CheckExtention(string test)
    {
        bool flag = false;
        string[] imgTypes = { ".jpg", ".png", ".jpeg", ".bmp", ".gif" };
        for (int i = 0; i < imgTypes.Length; i++)
        {
            if (test.ToLower() == imgTypes[i].ToString())
            {
                flag = true;
                break;
            }
            else
            {
                flag = false;
            }
        }
        return flag;
    }
}