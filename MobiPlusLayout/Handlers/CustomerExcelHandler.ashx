<%@ WebHandler Language="C#" Class="CustomerExcelHandler" %>

using System;
using System.Web;
using System.Linq;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI;
using System.Data;
using System.Collections.Generic;


public class CustomerExcelHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
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

            var reportsInfo = new HardwareWebService().POD_WEB_AgentDailyActivity(countryID, distrID, agentId, fromDate, toDate);


            var grid = new GridView
            {
                 DataSource = from a in reportsInfo
                             select new
                             {
                                 TaskDate = a.TaskDate,
                                 Shipment = a.Shipment,
                                 DriverID = a.DriverID,
                                 DriverName = string.IsNullOrEmpty(a.Driver) ? null : a.Driver.Split('^')[0].Trim(),
                                 CustomerID = a.CustomerID,
                                 Customer = string.IsNullOrEmpty(a.Customer) ? null : a.Customer.Split('^')[0].Trim(),
                                 Address = string.IsNullOrEmpty(a.CustomerAddress) ? null : a.CustomerAddress.Split('^')[0].Trim(),
                                 Place = string.IsNullOrEmpty(a.CustomerAddress) ? null : a.CustomerAddress.Split('^')[1].Trim(),
                                 TravelHoursBegin = string.IsNullOrEmpty(a.TravelHours) ? null : a.TravelHours.Split('-')[0].Trim(),
                                 TravelHoursEnd = string.IsNullOrEmpty(a.TravelHours) ? null : a.TravelHours.Split('-')[1].Split('^')[0].Trim(),
                                 TravelDuration = string.IsNullOrEmpty(a.TravelHours) ? null : a.TravelHours.Split('-')[1].Split('^')[1].Trim(),
                                 ServiceHoursBegin = string.IsNullOrEmpty(a.ServiceHours) ? null : a.ServiceHours.Split('-')[0].Trim(),
                                 ServiceHoursEnd = string.IsNullOrEmpty(a.ServiceHours) ? null : a.ServiceHours.Split('-')[1].Split('^')[0].Trim(),
                                 ServiceDuration = string.IsNullOrEmpty(a.ServiceHours) ? null : a.ServiceHours.Split('-')[1].Split('^')[1].Trim(),
                                 OriginalTime = a.OriginalTime,
                                 DeliveryTime = a.DeliveryTime,
                                 PlannedDelivery = string.IsNullOrEmpty(a.Delivery) ? null : a.Delivery.Split('/')[1].Trim(),
                                 CompleteDelivery = string.IsNullOrEmpty(a.Delivery) ? null : a.Delivery.Split('/')[0].Trim(),
                                 PlannedReturn = string.IsNullOrEmpty(a.CustReturn) ? null : (a.CustReturn.IndexOf('/') != -1 ? a.CustReturn.Split('/')[1].Trim() : a.CustReturn),
                                 CompleteReturn = string.IsNullOrEmpty(a.CustReturn) ? null : (a.CustReturn.IndexOf('/') != -1 ? a.CustReturn.Split('/')[0].Trim() : a.CustReturn),
                                 DriverReturn = a.DriverReturn,
                                 Pallets = a.CollectedSurfaces,
                                 Lat = a.ReportGPS_Lat,
                                 Lon = a.ReportGPS_Lon
                             }
            };

            grid.DataBind();

            response.ClearContent();
            response.Cache.SetCacheability(HttpCacheability.NoCache);

            response.AddHeader("Content-Disposition", "attachment;filename=CustomerExcel.xls");
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