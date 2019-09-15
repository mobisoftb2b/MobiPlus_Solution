<%@ WebHandler Class="EventAttachmentFileUpload" Language="C#" %>
using System;
using System.Web;
using PQ.BL.Persons;
using PQ.BE.Persons;
using PQ.BE.Common;

public class EventAttachmentFileUpload : IHttpHandler
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
                string trainingEventID = context.Request.Form["TrainingEventID"];
                string eventAttachmentName = context.Request.Form["EventAttachmentName"];
                Byte[] imgByte = null;


                if (postedFile.FileName != null)
                {
                    imgByte = new Byte[postedFile.ContentLength];
                    postedFile.InputStream.Read(imgByte, 0, postedFile.ContentLength);
                    using (PQ.BL.TrainingEvents.TrainingEventBL pbl = new PQ.BL.TrainingEvents.TrainingEventBL())
                    {
                        using (PQ.BE.TrainingEvent.TrainingEventAttachments prs = new PQ.BE.TrainingEvent.TrainingEventAttachments())
                        {
                            try
                            {
                                prs.TrainingEventID = int.Parse(trainingEventID);
                                prs.TrainingEventAttachmentsName = eventAttachmentName;
                                prs.TrainingEventAttachments_FileName = System.IO.Path.GetFileName(postedFile.FileName);
                                prs.TrainingEventAttachmentsContent = imgByte;
                                pbl.TrainingEventAttachments_Save(prs);
                            }
                            catch (Exception ex) { PQ.BL.Common.ErrorLogBL.WriteToErrorTable(ex); }
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