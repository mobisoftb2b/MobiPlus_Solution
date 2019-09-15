<%@ WebHandler Class="LowerUnitReadinessStatusChart" Language="C#" %>

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

public class LowerUnitReadinessStatusChart : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    byte[] imageResult = null;

    #region IHttpHandler Members

    public void ProcessRequest(HttpContext context)
    {
        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;

        int? unitID = System.Int32.Parse(Request.QueryString[appConfig.Keys.R_UNITID]);
        List<UnitReadinessInfo> result = null;
        HttpCookie chartHeader = HttpContext.Current.Request.Cookies.Get(appConfig.Keys.S_CHARTCOLLECTION);

        var stream = new System.IO.MemoryStream();
        Chart m_chart = new Chart();
        try
        {
            using (ReadinessBL _readiness = new ReadinessBL())
            {
                result = _readiness.UnitReadiness_SelectByUnitID(unitID, HttpContext.Current.Session["LanguageID"] == null ? 1 : int.Parse(HttpContext.Current.Session["LanguageID"].ToString()))
                    .Where(i => i.UnitReadiness_Date.Value <= DateTime.Now && i.UnitReadiness_Date >= DateTime.Now.AddMonths(-24)).ToList();
            }
            if (result.Count > 0)
            {
                using (RuntimeChart chartCol = new RuntimeChart())
                {
                    chartCol.ChartHeight = 350;
                    chartCol.ChartWidth = 670;
                    chartCol.ChartTitles = new Title(HttpContext.Current.Server.UrlDecode(HttpContext.Current.Session["ReadinessGraphLabel"].ToString()), Docking.Top, new Font("Trebuchet MS", 10, FontStyle.Bold), Color.Black);
                    chartCol.IsNonNumberYArea = false;
                    chartCol.IsColoredStripLine = true;

                    int count = 0;
                    Series series = new Series();
                    series.IsValueShownAsLabel = true;
                    series.ChartType = SeriesChartType.Line;
                    series.BorderWidth = 3;
                    series.ShadowOffset = 2;
                    series.YValueType = ChartValueType.Double;
                    series.MarkerStyle = MarkerStyle.Star10;
                    series.XAxisType = AxisType.Primary;
                    series.MarkerBorderColor = Color.FromArgb(64, 64, 64);
                    series.LabelBackColor = Color.Transparent;
                    //series.LabelBorderColor = Color.Black;
                    series.LabelForeColor = Color.Black;
                    series.Font = new Font("Arial", 10, FontStyle.Bold);
                    series.SmartLabelStyle.Enabled = false;
                    chartCol.SeriesPoints = series;
                    foreach (UnitReadinessInfo unitRead in result)
                    {
                        series.Points.AddY(unitRead.UnitReadiness_Score);
                        series.Points[count].AxisLabel = unitRead.UnitReadiness_Date.Value.ToString("y", new System.Globalization.CultureInfo("en-US"));
                        count++;
                    }

                    m_chart = chartCol.MakeSingleSeriesChart();
                    m_chart.SaveImage(stream);
                }
            }

        }
        catch (Exception ex) { ErrorLogBL.WriteToErrorTable(ex); }
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
