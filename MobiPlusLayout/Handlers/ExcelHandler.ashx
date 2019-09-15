<%@ WebHandler Language="C#" Class="ExcelHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI;
using MobiPlusTools;


public class ExcelHandler : IHttpHandler
{
	string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();
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

            var reportsInfo = new HardwareWebService().Layout_POD_WEB_TrucksAndTrailorDataTable(countryID, distrID, agentId, fromDate, toDate);

            var grid = new GridView
            {
                DataSource = from a in reportsInfo
                             select new
                             {
								TaskDate = a.TaskDate,
								DistributionID = a.DistributionChannel,
								DistributionCenter = a.Description, 
                                DriverID = a.DriverID,
								DriverName = a.DriverName,
								CarNumber = a.CarNumber,
                                Time = a.DocTime,                                
                                DriverStatus = a.DriverStatus,
                                FileName = a.FileName              
                             }
            };

            grid.DataBind();

            response.ClearContent();
            response.Cache.SetCacheability(HttpCacheability.NoCache);

            response.AddHeader("Content-Disposition", "attachment;filename=ReportExcel.xls");
            response.ContentType = "application/ms-excel";
            response.Write(CONTENT_ENCODING);



            var sw = new StringWriter();
            var htw = new HtmlTextWriter(sw);
            grid.RenderControl(htw);

            response.Write(sw.ToString());
            response.Flush(); 
            response.SuppressContent = true;              
            HttpContext.Current.ApplicationInstance.CompleteRequest();
			response.End();
        }
        catch (Exception ex)
        {
            Tools.HandleError(ex, LogDir);
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