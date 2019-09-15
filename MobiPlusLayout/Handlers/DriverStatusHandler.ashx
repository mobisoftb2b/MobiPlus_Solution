<%@ WebHandler Language="C#" Class="DriverStatusHandler" %>

using System;
using System.Web;
using System.Linq;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI;
using System.Data;

public class DriverStatusHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
      HttpRequest request = context.Request;
        HttpResponse response = context.Response;
        const string CONTENT_ENCODING = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>" +
           "<html xmlns='http://www.w3.org/1999/xhtml'><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body>";

        var countryID = request["cid"] == "" ? null : request["cid"];
        var distrID = request["did"] == "" ? null : request["did"];
        var agentId = request["driverID"] == "" ? null : request["driverID"];
        var fromDate = request["date"] == "" ? null : request["date"];
        var toDate = request["toDate"] == "undefined" ? null : request["toDate"];

        try
        {
            //var reportsInfo = HttpContext.Current.Session["AgentDailyActivity"] as List<CustomerModel>; //new HardwareWebService().POD_WEB_AgentDailyActivity(countryID, distrID, agentId, fromDate, toDate);

            var reportsInfo = new HardwareWebService().Layout_POD_WEB_DriverStatus(countryID, distrID, agentId, fromDate, toDate);


            var grid = new GridView
            {
                DataSource = from a in reportsInfo
                             select new
                             {
                                 TaskDate = a.TaskDate,
                                 DriverID = a.DriverID,
                                 DriverName = string.IsNullOrEmpty(a.DriverName) ? null : a.DriverName.Trim(),
                                 Cycle = a.Cycle,
                                 UpdateDate = a.UpdateDate,
                                 ArriveBB = string.IsNullOrEmpty(a.imgArriveBB) ? null : (a.imgArriveBB == "YES1" ? "YES" : a.imgArriveBB),
                                 LeaveBB = string.IsNullOrEmpty(a.imgLeaveBB) ? null : (a.imgLeaveBB == "YES1" ? "YES" : a.imgLeaveBB),
                                 LineDownload = string.IsNullOrEmpty(a.imgLineDownload) ? null : (a.imgLineDownload == "YES1" ? "YES" : a.imgLineDownload),
                                 Wise = string.IsNullOrEmpty(a.imgWise) ? null : (a.imgWise == "YES1" ? "YES" : a.imgWise),
                                 ToDiplomat = string.IsNullOrEmpty(a.imgToDiplomat) ? null : (a.imgToDiplomat == "YES1" ? "YES" : a.imgToDiplomat),
                                 LineEnded = string.IsNullOrEmpty(a.imgLineEnded) ? null : (a.imgLineEnded == "YES1" ? "YES" : a.imgLineEnded),
                                 LongDistance = string.IsNullOrEmpty(a.LongDistance) ? null : (a.LongDistance == "YES1" ? "YES" : a.LongDistance),
                                 Period = a.Period
                             }
            };

            grid.DataBind();

            response.ClearContent();
            response.Cache.SetCacheability(HttpCacheability.NoCache);

            response.AddHeader("Content-Disposition", "attachment;filename=DriverStatusExcel.xls");
            response.ContentType = "application/ms-excel";
            response.Write(CONTENT_ENCODING);



            var sw = new StringWriter();
            var htw = new HtmlTextWriter(sw);
            grid.RenderControl(htw);

            response.Write(sw.ToString());
            response.Flush(); // Sends all currently buffered output to the client.
            response.SuppressContent = true;  // Gets or sets a value indicating whether to send HTTP content to the client.
            HttpContext.Current.ApplicationInstance.CompleteRequest(); // Causes ASP.NET to bypass all events and filtering in the HTTP pipeline chain of execution and directly execute the EndRequest event.
            response.End();
        }
        catch (Exception ex)
        {
            response.Write(ex);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}