using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DriverStatusModel
/// </summary>
public class DriverStatusModel
{
    public long? DriverID { get; set; }
    public string DriverName { get; set; }
    public string Cycle { get; set; }
    public string UpdateDate { get; set; }
    public string imgLineDownload { get; set; }
    public string STYLE_imgLineDownload { get; set; }
    public string imgWise { get; set; }
    public string STYLE_imgWise { get; set; }
    public string imgToDiplomat { get; set; }
    public string STYLE_imgToDiplomat { get; set; }
    public string imgLineEnded { get; set; }
    public string STYLE_imgLineEnded { get; set; }
    public string LongDistance { get; set; }
    public string Period { get; set; }
    public string imgArriveBB { get; set; }
    public string imgLeaveBB { get; set; }

    /// <summary>
    /// DriverStatusModel Popup
    /// </summary>
    public string TaskTime { get; set; }
    public string ShipmentID { get; set; }
    public string Customer { get; set; }
    public string CustAddress { get; set; }
    public string TaskID { get; set; }
    public string DocNumber { get; set; }
    public string ReportCode { get; set; }
    public string Description { get; set; }
    public string Comment { get; set; }
    public string LastChange { get; set; }
public string TaskDate { get; set; }
}