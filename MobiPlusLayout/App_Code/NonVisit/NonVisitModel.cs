using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for NonVisitModel
/// </summary>
public class NonVisitModel
{
    public string TaskDate { get; set; }
    public string DriverName { get; set; }
    public long? ShipmentID { get; set; }
    public long? TaskID { get; set; }
    public string CustomerData { get; set; }
    public string ReportDescription { get; set; }
    public string Delivery { get; set; }
}