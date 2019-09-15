using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Customer
/// </summary>
public class CustomerModel
{
    public string Shipment { get; set; }
    public string TaskDate { get; set; }
    public string ImgStatus { get; set; }
    public int? IdStatus { get; set; }
    public string Driver { get; set; }
    public string CustomerID { get; set; }
    public string Customer { get; set; }
    public string CustomerAddress { get; set; }
    public string CustomerCoord { get; set; }
    public string TravelHours { get; set; }
    public string ServiceHours { get; set; }
    public string OriginalTime { get; set; }
    public string DeliveryTime { get; set; }
    public string Delivery { get; set; }
    public string CustReturn { get; set; }
    public string DriverReturn { get; set; }
    public string STYLE_DriverReturn { get; set; }
    public string STYLE_ServiceHours { get; set; }
    public string CollectedSurfaces { get; set; }
    public string STYLE_CollectedSurfaces { get; set; }
    public string TaskDescription { get; set; }
    public string DeliveryNum { get; set; }
    public string Comment { get; set; }
    public string Description { get; set; }
    public string DriverID { get; set; }
    public string DistrID { get; set; }
    public string ReportGPS_Lat { get; set; }
    public string ReportGPS_Lon { get; set; }
    public string Mission { get; set; }
    public int? Quality { get; set; }
    public string Cycle { get; set; }
    public string SortOrder { get; set; }
    public string ActualSortOrder { get; set; }
}