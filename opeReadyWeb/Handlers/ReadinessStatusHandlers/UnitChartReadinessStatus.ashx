<%@ WebHandler Class="UnitChartReadinessStatus" Language="C#" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PQ.BE.Common;
using PQ.BL.Common;
using System.Drawing;
using System.Web.UI.DataVisualization.Charting;
using PQ.BL.ReadinessInformation;
using PQ.BE.ReadinessInformation;

public class UnitChartReadinessStatus : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    byte[] imageResult = null;

    #region IHttpHandler Members

    public void ProcessRequest(HttpContext context)
    {
        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;

        int? unitID = System.Int32.Parse(Request.QueryString[appConfig.Keys.R_UNITID]);
        List<UnitReadinessQtyPerson> result = null;
        //HttpCookie chartHeader = HttpContext.Current.Request.Cookies.Get(appConfig.Keys.S_CHARTCOLLECTION);
        
        int userID = System.Int32.Parse(HttpContext.Current.User.Identity.Name);
        
        var stream = new System.IO.MemoryStream();
        Chart m_chart = null;
        try
        {
            using (ReadinessBL _readiness = new ReadinessBL())
            {
                result = _readiness.UnitReadiness_SelectByUnitIDForUpperPie(unitID, userID, HttpContext.Current.Session["LanguageID"] == null ? 1 : int.Parse(HttpContext.Current.Session["LanguageID"].ToString()));
            }
            if (result.Count > 0)
            {
                using (RuntimeChart chartCol = new RuntimeChart())
                {
                    chartCol.ChartHeight = 250;
                    chartCol.ChartWidth = 280;
                    chartCol.IsColoredStripLine = false;
                    chartCol.SeriesChartTypes = SeriesChartType.Pie;
                    chartCol.IsLegend = true;
                    chartCol.IsAxisYMaximum = true;
                    int count = 0;
                    Series series = new Series();
                    series.ChartType = SeriesChartType.Pie;
                    series.BorderWidth = 3;
                    series.ShadowOffset = 2;
                    series.Label = "#PERCENT{P1}";

                    //var tempChart = result.GroupBy(r => new { r.Unit_ID, r.ReadinessLevel_ID, r.ORGName }).Select(r => new { Unit_ID = r.Key.Unit_ID, ReadinessLevelID = r.Key.ReadinessLevel_ID, ORGName = r.Key.ORGName, Ratio = (r.Count() * 100) / result.Count });

                    foreach (var info in result)
                    {
                        series.Points.AddY(info.Person_Count);
                        series.Points[count].LegendText = info.ORGName;
                        series.Points[count].Color = Utils.getZoneColor(info.ReadinessLevel_ID);
                        count++;
                    }
                    chartCol.SeriesPoints = series;
                    m_chart = chartCol.MakeSingleSeriesChart();

                    m_chart.SaveImage(stream, ChartImageFormat.Png);
                }
            }

        }
        catch (Exception ex) { ErrorLogBL.WriteToErrorTable(ex); }
        Response.ContentType = "image/png";
        imageResult = (byte[])stream.GetBuffer();
        if (stream.Length == 0)
            imageResult = Utils.imageToByteArray(Image.FromFile(HttpContext.Current.Server.MapPath("~/Resources/images/PieNoData.png")));
        Response.OutputStream.Write(imageResult, 0, imageResult.Length);
        HttpContext.Current.ApplicationInstance.CompleteRequest();

    }

    #endregion

    public bool IsReusable
    {
        get { return true; }
    }
}
