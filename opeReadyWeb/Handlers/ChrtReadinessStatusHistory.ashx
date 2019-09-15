<%@ WebHandler Class="ChrtReadinessStatusHistory" Language="C#" %>

using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.DataVisualization.Charting;
using PQ.BE.Common;
using PQ.BE.ReadinessInformation;
using PQ.BL.Common;
using PQ.BL.ReadinessInformation;


public class ChrtReadinessStatusHistory : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    byte[] imageResult = null;


    #region IHttpHandler Members

    public void ProcessRequest(HttpContext context)
    {
        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;

        int? personID = System.Int32.Parse(Request.QueryString[appConfig.Keys.R_EMPID]);
        HttpCookie chartHeader = HttpContext.Current.Request.Cookies.Get(appConfig.Keys.S_CHARTCOLLECTION);

        var stream = new MemoryStream();
        try
        {
            List<PersonReadiness> result = null;
            using (var _readiness = new ReadinessBL())
            {
                result = _readiness.PersonReadiness_SelectByPersonID(personID).Where(i => i.PersonReadiness_Date <= DateTime.Now && i.PersonReadiness_Date >= DateTime.Now.AddMonths(-24)).ToList(); ;
            }
            if (result.Count > 0)
            {
                using (var chartCol = new RuntimeChart())
                {
                    int count = 0;
                    chartCol.ChartHeight = 350;
                    chartCol.ChartWidth = 715;
                    chartCol.IsAxisYMaximum = false;
                    chartCol.ChartTitles = new Title(HttpContext.Current.Server.UrlDecode(chartHeader["ReadinessLevel_SideLabel"].ToString()), Docking.Top, new Font("Arial", 14, FontStyle.Bold), Color.Black);
                    chartCol.TitleAreaTextReadinessLevelGreen = HttpContext.Current.Server.UrlDecode(chartHeader["ReadinessLevelGreen"].ToString());
                    chartCol.TitleAreaTextReadinessLevelRed = HttpContext.Current.Server.UrlDecode(chartHeader["ReadinessLevelRed"].ToString());
                    chartCol.TitleAreaTextReadinessLevelYellow = HttpContext.Current.Server.UrlDecode(chartHeader["ReadinessLevelYellow"].ToString());
                    chartCol.IsColoredStripLine = true;
                    chartCol.IsNonNumberYArea = true;
                    chartCol.IsAxisYMaximum = true;
                    var series = new Series();
                    series.ChartType = SeriesChartType.Line;
                    series.BorderWidth = 3;
                    series.ShadowOffset = 2;

                    foreach (PersonReadiness person in result)
                    {
                        series.Points.AddY(person.LineThresholdScore);
                        series.Points[count].AxisLabel = person.PersonReadiness_Date.ToString("y", new System.Globalization.CultureInfo("en-US"));
                        count++;
                    }

                    chartCol.SeriesPoints = series;
                    Chart m_chart = chartCol.MakeSingleSeriesChart();
                    m_chart.SaveImage(stream, ChartImageFormat.Png);
                }
            }
        }
        catch (Exception e) { ErrorLogBL.WriteToErrorTable(e); }
        Response.ContentType = "image/png";
        imageResult = (byte[])stream.GetBuffer();
        if (stream.Length == 0)
            imageResult = Utils.imageToByteArray(Image.FromFile(HttpContext.Current.Server.MapPath("~/Resources/images/NODATA.png")));
        Response.OutputStream.Write(imageResult, 0, imageResult.Length);
        HttpContext.Current.ApplicationInstance.CompleteRequest();

    }

    #endregion

    public bool IsReusable
    {
        get { return true; }
    }
}
