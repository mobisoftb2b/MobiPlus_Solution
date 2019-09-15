<%@ WebHandler Language="C#" Class="ContActivityHandler" %>

using System;
using System.Web;
using System.Linq;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI;
using System.Data;
using System.Collections.Generic;

public class ContActivityHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        HttpRequest request = context.Request;
        HttpResponse response = context.Response;
        const string CONTENT_ENCODING = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>" +
           "<html xmlns='http://www.w3.org/1999/xhtml'><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body>";

        var reportID = request["ID"] == "" ? null : (int?)int.Parse(request["ID"].ToString());
        var countryID = request["cid"] == "" ? null : request["cid"];
        var distrID = request["did"] == "" ? null : request["did"];
        var agentId = request["driverID"] == "" ? null : request["driverID"];
        var fromDate = request["date"] == "" ? null : request["date"];
        var toDate = request["toDate"] == "undefined" ? null : request["toDate"];

        try
        {
            //var reportsInfo = HttpContext.Current.Session["AgentDailyActivity"] as List<CustomerModel>; //new HardwareWebService().POD_WEB_AgentDailyActivity(countryID, distrID, agentId, fromDate, toDate);

            var reportsInfo = new HardwareWebService().Layout_POD_WEB_ConcentrationActivityExcel(reportID, countryID, distrID, agentId, fromDate, toDate);


            var grid = new GridView
            {
                DataSource = from a in reportsInfo
                             select new
                             {
                                 TaskDate = a.TaskDate,
                                 DriverID = a.DriverID,
                                 DriverName = a.DriverName,
                                 Shipment = a.Shipment,
                                 Cycle = a.Cycle,
                                 PlannedCustomer = string.IsNullOrEmpty(a.Visit) ? null : a.Visit.Split('/')[1].Trim(),
                                 CompleteCustomer = string.IsNullOrEmpty(a.Visit) ? null : a.Visit.Split('/')[0].Trim(),
                                 PlannedDelivery = string.IsNullOrEmpty(a.Delivery) ? null : a.Delivery.Split('/')[1].Trim(),
                                 CompleteDelivery = string.IsNullOrEmpty(a.Delivery) ? null : a.Delivery.Split('/')[0].Trim(),
                                 NotVisited = a.NotVisited,
                                 NotFullDelivery = a.NotFullDelivery,
                                 PlannedReturn = string.IsNullOrEmpty(a.AgentReturn) ? null : (a.AgentReturn.IndexOf('/') != -1 ? a.AgentReturn.Split('/')[1].Trim() : a.AgentReturn),
                                 CompleteReturn = string.IsNullOrEmpty(a.AgentReturn) ? null : (a.AgentReturn.IndexOf('/') != -1 ? a.AgentReturn.Split('/')[0].Trim() : a.AgentReturn),
                                 DriverReturn = a.DriverReturn,
                                 DriverStatus = string.IsNullOrEmpty(a.DriverStatus) ? null : (a.DriverStatus.IndexOf('^') != -1 ? a.DriverStatus.Split('^')[0].Trim() : a.DriverStatus),
                                 Place = string.IsNullOrEmpty(a.DriverStatus) ? null : (a.DriverStatus.IndexOf('^') != -1 ? a.DriverStatus.Split('^')[1].Trim() : null),
                                 Preform = a.KPI
                             }
            };

            grid.DataBind();

            response.ClearContent();
            response.Cache.SetCacheability(HttpCacheability.NoCache);

            response.AddHeader("Content-Disposition", "attachment;filename=ConcentrationActivityExcel.xls");
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

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}