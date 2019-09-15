<%@ WebHandler Class="MultiSeriesChats" Language="C#" %>

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


public class MultiSeriesChats : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    byte[] imageResult = null;


    #region IHttpHandler Members

    public void ProcessRequest(HttpContext context)
    {
        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;
        int? subevaluationID = null;
        int? trainingEventCategoryID = null;
        
        int? personID = System.Int32.Parse(Request.QueryString[appConfig.Keys.R_EMPID]);
        int? traningEventTypeID = Int32.Parse(Request.QueryString[appConfig.Keys.R_TRAININGEVENTTYPEID]);
        string dateFrom = Request.QueryString[appConfig.Keys.R_DATEFROM] == null ? string.Empty : Request.QueryString[appConfig.Keys.R_DATEFROM].ToString();
        string dateTo = Request.QueryString[appConfig.Keys.R_DATETO] == null ? string.Empty : Request.QueryString[appConfig.Keys.R_DATETO].ToString();
        if (Request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID] != null && Request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID] != "null")
            trainingEventCategoryID = (int?)Int32.Parse(Request.QueryString[appConfig.Keys.R_TRAININGEVENTCATEGORYID]);
        if (Request.QueryString[appConfig.Keys.R_SUBEVALUATIONID] != null && Request.QueryString[appConfig.Keys.R_SUBEVALUATIONID] != "null")
            subevaluationID = Int32.Parse(Request.QueryString[appConfig.Keys.R_SUBEVALUATIONID]);
        
        List<PerfomanceAnalysisSubEvaluations> result = null;
        HttpCookie chartHeader = HttpContext.Current.Request.Cookies.Get(appConfig.Keys.S_CHARTCOLLECTION);

        var stream = new System.IO.MemoryStream();
        Chart m_chart = null;

        using (ReadinessBL _readiness = new ReadinessBL())
        {
            result = _readiness.PerfomanceAnalysisSubEvaluations_SelectAll(personID, traningEventTypeID, trainingEventCategoryID,subevaluationID, dateFrom, dateTo);
        }

        try
        {
            if (result.Count > 0)
            {
                result.FindAll(s => s.TrainingEventCategory_Name == null).ForEach(s => s.TrainingEventCategory_Name = HttpContext.Current.Server.UrlDecode(chartHeader["SubEvaluations_NullValue"]));
                string insertType = SelectPerfomanceCategory(result);
                using (RuntimeChart chartCol = new RuntimeChart())
                {
                    chartCol.ChartHeight = 350;
                    chartCol.ChartWidth = 670;
                    
                    if (Utils.NumberOfMonth(result) > 31 && Utils.NumberOfMonth(result) <= 90)
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Weeks;
                    }
                    else if (Utils.NumberOfMonth(result) >= 91 && Utils.NumberOfMonth(result) <= 1100)
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Months;
                    }
                    else if (Utils.NumberOfMonth(result) >= 1100)
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Years;
                    }
                    else if (Utils.NumberOfMonth(result) <= 30)
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Days;
                    }
                    else
                    {
                        chartCol.AxisDateTimeIntervalType = DateTimeIntervalType.Weeks;
                    }
                    chartCol.ChartTitles = new Title(string.Format("{0} - {1}", result.FirstOrDefault().TrainingEventType_Name,
                        result.FirstOrDefault().TrainingEventCategory_Name), Docking.Top, new Font("Trebuchet MS", 10, FontStyle.Bold), Color.Black);
                    chartCol.SeriesChartTypes = SeriesChartType.Line;
                    chartCol.IsAxisYMaximum = true;
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
        catch (Exception e) { ErrorLogBL.WriteToErrorTable(e); }

    }

    #endregion

    private string SelectPerfomanceCategory(List<PerfomanceAnalysisSubEvaluations> _result)
    {
        string result = string.Empty;
        PerfomanceAnalysisSubEvaluations person = _result.FirstOrDefault();
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




    public bool IsReusable
    {
        get { return true; }
    }
}