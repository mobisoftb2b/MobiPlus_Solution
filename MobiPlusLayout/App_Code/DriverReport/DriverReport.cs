using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DriverReport
/// </summary>
public class DriverReportModel
{
    public string DocDate { get; set; }
    public string DocStartTime { get; set; }
    public string DriverName { get; set; }
    public long? Reference { get; set; }
    public long? ShipmentNumber { get; set; }
    public string CustomerData { get; set; }
    public string Item { get; set; }
    public float? OrigCases { get; set; }
    public float? CaseQuantity { get; set; }
    public float? QTY { get; set; }
    public string ReturnResCode { get; set; }
    public string ReasonDescription { get; set; }
}