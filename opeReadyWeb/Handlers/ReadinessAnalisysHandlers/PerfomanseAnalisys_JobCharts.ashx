<%@ WebHandler Class="PerfomanseAnalisys_JobCharts" Language="C#" %>

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

public class PerfomanseAnalisys_JobCharts : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    byte[] imageResult = null;

    #region IHttpHandler Members

    public bool IsReusable
    {
        get { return true; }
    }
//JobReadinessReadinessAnalisysUnitsChart
    public void ProcessRequest(HttpContext context)
    {
        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;

        int? jobID = System.Int32.Parse(Request.QueryString[appConfig.Keys.R_JOBID]);
        int traningEventTypeID = Int32.Parse(Request.QueryString[appConfig.Keys.R_TRAININGEVENTTYPEID]);
        string dateFrom = Request.QueryString[appConfig.Keys.R_DATEFROM] == null ? string.Empty : Request.QueryString[appConfig.Keys.R_DATEFROM].ToString();
        string dateTo = Request.QueryString[appConfig.Keys.R_DATETO] == null ? string.Empty : Request.QueryString[appConfig.Keys.R_DATETO].ToString();
        List<ReadinessAnalisysUnitsChart> result = null;
        HttpCookie chartHeader = HttpContext.Current.Request.Cookies.Get(appConfig.Keys.S_CHARTCOLLECTION);

        var stream = new System.IO.MemoryStream();
        Chart m_chart = new Chart();
        try
        {
            using (ReadinessBL _readiness = new ReadinessBL())
            {
                result = _readiness.PerfomanceAnalisys_JobCharts(jobID, traningEventTypeID, dateFrom, dateTo);
            }
            if (result.Count > 0)
            {
                using (RuntimeChart chartCol = new RuntimeChart())
                {
                    string insertType = SelectPerfomanceCategory(result);
                    result.FindAll(s => s.TrainingEventCategory_Name == null).ForEach(s => s.TrainingEventCategory_Name = HttpContext.Current.Server.UrlDecode(chartHeader["SubEvaluations_NullValue"]));
                    chartCol.ChartHeight = 350;
                    chartCol.ChartWidth = 670;

                    if (NumberOfMonth(result) > 31 && NumberOfMonth(result) <= 90)
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Weeks;
                    }
                    else if (NumberOfMonth(result) >= 91 && NumberOfMonth(result) <= 719)
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Months;
                    }
                    else if (NumberOfMonth(result) >= 720)
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Years;
                    }
                    else
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Months;
                    }

                    chartCol.ChartTitles = new Title(string.Format("{0} - {1}", HttpContext.Current.Server.UrlDecode(chartHeader["TitlePerformanceEvaluation"]),
                              result.FirstOrDefault().TrainingEventType_Name), Docking.Top, new Font("Trebuchet MS", 10, FontStyle.Bold), Color.Black);
                    string yField = SelectPerfomanceCategory(result);
                    chartCol.IsAxisYMaximum = true;
                    chartCol.SeriesChartTypes = SeriesChartType.Line;
                    m_chart = chartCol.MakeMultipleSeriesChart(result, "TrainingEventCategory_Name",
                        "TrainingEvent_Date",
                        yField,
                        "Label=" + insertType);
                    m_chart.SaveImage(stream, ChartImageFormat.Png);
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

    private string SelectPerfomanceCategory(List<ReadinessAnalisysUnitsChart> _result)
    {
        string result = string.Empty;
        ReadinessAnalisysUnitsChart person = _result.FirstOrDefault();
        if (person.ExecutionLevel_Score != null)
        {
            result = "ExecutionLevel_Score";
        }
        if (person.TrainingEvent2Person_Quantity != null)
        {
            result = "TrainingEvent2Person_Quantity";
        }
        if (person.TrainingEvent2Person_Score != null)
        {
            result = "TrainingEvent2Person_Score";
        }
        return result;
    }

    public int NumberOfMonth(List<ReadinessAnalisysUnitsChart> _result)
    {
        DateTime? startingDate = _result.OrderBy(q => q.TrainingEvent_Date).First().TrainingEvent_Date;
        DateTime? endingDate = _result.OrderBy(q => q.TrainingEvent_Date).Last().TrainingEvent_Date;
        // first generate all dates in the month of 'date'

        int starting = startingDate.Value.Day;
        int ending = endingDate.Value.Day;
        List<DateTime?> allDates = new List<DateTime?>();
        for (DateTime? date = startingDate; date <= endingDate; date = date.Value.AddDays(1))
            allDates.Add(date);
        return allDates.Count;
    }

    #endregion
}
