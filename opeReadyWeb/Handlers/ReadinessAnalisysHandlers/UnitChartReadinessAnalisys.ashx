<%@ WebHandler Class="UnitChartReadinessAnalisys" Language="C#" %>

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

public class UnitChartReadinessAnalisys : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    byte[] _imageResult = null;

    #region IHttpHandler Members

    public void ProcessRequest(HttpContext context)
    {
        HttpRequest request = context.Request;
        HttpResponse response = context.Response;
        int? trainingEventCategoryID = null;
        int? unitID = null;

        if (request.QueryString[appConfig.Keys.R_UNITID] != null && request.QueryString[appConfig.Keys.R_UNITID] != "")
            unitID = (int?)Int32.Parse(request.QueryString[appConfig.Keys.R_UNITID]);
        int traningEventTypeID = Int32.Parse(request.QueryString[appConfig.Keys.R_TRAININGEVENTTYPEID]);
        if (request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID] != null && request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID] != "null")
            trainingEventCategoryID = (int?)Int32.Parse(request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID]);
        HttpCookie chartHeader = HttpContext.Current.Request.Cookies.Get(appConfig.Keys.S_CHARTCOLLECTION);
        string dateFrom = request.QueryString[appConfig.Keys.R_DATEFROM] == null ? string.Empty : request.QueryString[appConfig.Keys.R_DATEFROM].ToString();
        string dateTo = request.QueryString[appConfig.Keys.R_DATETO] == null ? string.Empty : request.QueryString[appConfig.Keys.R_DATETO].ToString();
        var stream = new System.IO.MemoryStream();
        try
        {
            List<ReadinessAnalisysUnitsChart> result = null;
            using (var readiness = new ReadinessBL())
            {
                DateTime dateFromObj = Convert.ToDateTime(dateFrom, new System.Globalization.CultureInfo("fr-FR"));
                DateTime dateToObj = Convert.ToDateTime(dateTo, new System.Globalization.CultureInfo("fr-FR"));
                result = readiness.ReadinessAnalisysUnitsChart_Select(unitID, traningEventTypeID, trainingEventCategoryID, dateFrom, dateTo);
            }
            using (var chartCol = new RuntimeChart())
            {
                if (result.Count > 0)
                {
                    chartCol.ChartTitles = new Title(string.Format("{0} - {1}", HttpContext.Current.Server.UrlDecode(chartHeader["TitlePerformanceEvaluation"]),
                            result.FirstOrDefault().TrainingEventType_Name), Docking.Top, new Font("Trebuchet MS", 10, FontStyle.Bold), Color.Black);
                    string insertType = SelectPerfomanceCategory(result);
                    result.FindAll(s => s.TrainingEventCategory_Name == null).ForEach(s => s.TrainingEventCategory_Name = HttpContext.Current.Server.UrlDecode(chartHeader["SubEvaluations_NullValue"]));
                    chartCol.ChartHeight = 350;
                    chartCol.ChartWidth = 670;
                    chartCol.DateTimeFormat = "he-IL";
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
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Weeks;
                    }
                    string yField = SelectPerfomanceCategory(result);
                    chartCol.IsAxisYMaximum = true;
                    chartCol.SeriesChartTypes = SeriesChartType.Line;
                    Chart mChart = chartCol.MakeMultipleSeriesChart(result, "TrainingEventCategory_Name",
                        "TrainingEvent_Date",
                        yField,
                        "Label=" + insertType);
                    mChart.SaveImage(stream, ChartImageFormat.Png);
                }
            }
        }
        catch (Exception) { }
        response.ContentType = "image/png";
        _imageResult = stream.GetBuffer();
        if (stream.Length == 0)
            _imageResult = Utils.imageToByteArray(Image.FromFile(HttpContext.Current.Server.MapPath("~/Resources/images/NODATA.png")));
        response.OutputStream.Write(_imageResult, 0, _imageResult.Length);
        HttpContext.Current.ApplicationInstance.CompleteRequest();

    }

    private string SelectPerfomanceCategory(IEnumerable<ReadinessAnalisysUnitsChart> _result)
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

    public bool IsReusable
    {
        get { return true; }
    }
}
