<%@ WebHandler Class="FileUploadHandler" Language="C#" %>
using System;
using System.Web;
using PQ.BL.Persons;
using PQ.BE.Persons;
using PQ.BE.Common;

public class FileUploadHandler : IHttpHandler
{
    #region IHttpHandler Members
    public bool IsReusable
    {
        get { return false; }
    }
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            context.Response.ContentType = "text/plain";
            context.Response.Expires = -1;
            try
            {
                HttpPostedFile postedFile = context.Request.Files[0];
                string personAttachmentsName = context.Request.Form["PersonAttachName"];
                Byte[] imgByte = null;


                if (postedFile.FileName != null)
                {
                    imgByte = new Byte[postedFile.ContentLength];
                    postedFile.InputStream.Read(imgByte, 0, postedFile.ContentLength);
                    using (PersonBL pbl = new PersonBL())
                    {
                        using (PersonAttachment prs = new PersonAttachment())
                        {
                            prs.Person_ID = int.Parse(HttpContext.Current.Request[appConfig.Keys.R_EMPID].ToString());
                            prs.PersonAttachments_Content = imgByte;
                            prs.PersonAttachments_FileName = System.IO.Path.GetFileName(postedFile.FileName);
                            prs.PersonAttachments_Name = personAttachmentsName;
                            pbl.PersonAttachment_SaveAttach(prs);
                        }
                    }
                }
                context.Response.StatusCode = 200;
            }
            catch (Exception ex)
            {
                PQ.BL.Common.ErrorLogBL.WriteToErrorTable(ex);
            }
        }
        catch
        {

        }
    }
    #endregion
}