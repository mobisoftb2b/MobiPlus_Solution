﻿<%@ WebHandler Class="ReadinessAnalisys_UnitSubEvaluation" Language="C#" %>

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

public class ReadinessAnalisys_UnitSubEvaluation : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    byte[] imageResult = null;


    #region IHttpHandler Members
    public void ProcessRequest(HttpContext context)
    {
        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;
        int? trainingEventCategoryID = null;
        int? subevaluationID = null;
        
        System.Globalization.CultureInfo ci = null;
        SystemDateFormat dateFormat = new LanguageBL().DateFormat_SelectCurrent();
        if (dateFormat.DateCode == 103)
            ci = new System.Globalization.CultureInfo("fr-FR");
        if (dateFormat.DateCode == 101)
            ci = System.Globalization.CultureInfo.InvariantCulture;

        int? unitID = System.Int32.Parse(Request.QueryString[appConfig.Keys.R_UNITID]);
        int traningEventTypeID = Int32.Parse(Request.QueryString[appConfig.Keys.R_TRAININGEVENTTYPEID]);
        if (Request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID] != null && Request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID] != "null")
            trainingEventCategoryID = (int?)Int32.Parse(Request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID]);


        if (Request.QueryString[appConfig.Keys.R_SUBEVALUATIONID] != null && Request.QueryString[appConfig.Keys.R_SUBEVALUATIONID] != "null")
             subevaluationID =  Int32.Parse(Request.QueryString[appConfig.Keys.R_SUBEVALUATIONID]);
        
        
        string dateFrom = Request.QueryString[appConfig.Keys.R_DATEFROM] == null ? string.Empty : Request.QueryString[appConfig.Keys.R_DATEFROM].ToString();
        string dateTo = Request.QueryString[appConfig.Keys.R_DATETO] == null ? string.Empty : Request.QueryString[appConfig.Keys.R_DATETO].ToString();

        List<ReadinessAnalisysUnitSubEvaluation> result = null;
        HttpCookie chartHeader = HttpContext.Current.Request.Cookies.Get(appConfig.Keys.S_CHARTCOLLECTION);

        var stream = new System.IO.MemoryStream();
        Chart m_chart = null;


        DateTime dateFromObj = Convert.ToDateTime(dateFrom, ci);
        DateTime dateToObj = Convert.ToDateTime(dateTo, ci);
        using (ReadinessBL _readiness = new ReadinessBL())
        {
            result = _readiness.ReadinessAnalisysUnitsSubEvaluationChart_Select(unitID, traningEventTypeID, trainingEventCategoryID, subevaluationID, dateFrom, dateTo);
        }

        try
        {
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
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Weeks;
                    }
                    chartCol.ChartTitles = new Title(string.Format("{0} - {1}", result.FirstOrDefault().TrainingEventType_Name,
                        result.FirstOrDefault().TrainingEventCategory_Name), Docking.Top, new Font("Trebuchet MS", 10, FontStyle.Bold), Color.Black);
                    chartCol.IsAxisYMaximum = true;
                    chartCol.SeriesChartTypes = SeriesChartType.Line;
                    m_chart = chartCol.MakeMultipleSeriesChart(result.OrderBy(a => a.TrainingEvent_Date), "SubEvaluationType_Name",
                        "TrainingEvent_Date",
                        insertType,
                        string.Format("Label={0}", insertType));

                    m_chart.SaveImage(stream, ChartImageFormat.Png);
                }
            }
            Response.ContentType = "image/png";
            imageResult = (byte[])stream.GetBuffer();
            if (stream.Length == 0)
                imageResult = Utils.imageToByteArray(Image.FromFile(HttpContext.Current.Server.MapPath("~/Resources/images/NODATA.png")));
            Response.OutputStream.Write(imageResult, 0, imageResult.Length);
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        catch (Exception ex) { ErrorLogBL.WriteToErrorTable(ex); }

    }

    #endregion

    private string SelectPerfomanceCategory(List<ReadinessAnalisysUnitSubEvaluation> _result)
    {
        string result = string.Empty;
        ReadinessAnalisysUnitSubEvaluation person = _result.FirstOrDefault();
        if (person.ExecutionLevel_Score != null)
        {
            result = "ExecutionLevel_Score";
        }
        if (person.SubEvaluation2TrainingEvent_Quantity != null)
        {
            result = "SubEvaluation2TrainingEvent_Quantity";
        }
        if (person.SubEvaluation2TrainingEvent_Score != null)
        {
            result = "SubEvaluation2TrainingEvent_Score";
        }
        return result;
    }

    public int NumberOfMonth(List<ReadinessAnalisysUnitSubEvaluation> _result)
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


    public bool IsReusable
    {
        get { return true; }
    }
}
